#!/usr/bin/perl -w
use SDL;
use SDLx::App;
use SDL::Event;

my $app=SDLx::App->new(w=>400,h=>500,d=>32,t=>"Flappy Me");
my $color =[108,108,108,108];
my $drawing=0;
my @upper_rect=(); #A dynamic array to store the properties of Upper Rectangle [x-coordinate, y-coordinate, width, height]
my @lower_rect=(); #A dynamic array to store the properties of lower Rectangle [x-coordinate, y-coordinate, width, height]
my @height_upper=(); #A dynamic array to store the height of upper rectangle
my @height_lower=(); #A dynamic arrary to store the height of lower retangle 
my $rect_dist=120; #The distance between two rectangles
my $rect_width=60; #The width of a rectangle
my @coord_x=(320, 500); #A dynamic arrat to store the x-coordinate of drawing rectangles

my $started = 0; #state if first mouse click is clicked
my $velocity =0; # velocity of the bird, move top if negative
my $acceleration =0; #acceleration of user movement
my $user_pos =200;	#the y cord of the user
my $USER_WIDTH = 40;# const of user pic width
my $USER_HEIGHT = 40;#const of user pic height
my $lower_upper = 140;

my $score = 0; # saving score

#initialize the program, assign corresponding values.
for ($i=0;$i<@coord_x;$i++)
{
	push @height_upper, int(rand(320 - $lower_upper)) + 40;
	push @height_lower, (400-$lower_upper)-$height_upper[$i];
	push @upper_rect, [$coord_x[$i], 0, $rect_width, $height_upper[$i]];
	push @lower_rect, [$coord_x[$i], 400-$height_lower[$i], $rect_width, $height_lower[$i]];
}

my $event=SDL::Event->new();   
my $quit=0;   

sub get_events
{
     SDL::Events::pump_events();   
     while (SDL::Events::poll_event($event))   
     {   
        $quit=1 if $event->type==SDL_KEYDOWN;   
		if ($event->type==SDL_MOUSEBUTTONDOWN){
			$started =1;
			$acceleration =-2;
			$velocity = 0;
		}
	    $quit=1 if $event->type==SDL_QUIT;
     }   
}
#draw background
sub draw_bg
{
	#draw the ground
	$app->draw_rect([0,400,400,100],[10,80,10,255]);
	#draw the sky
	my $sky=SDLx::Surface->new(width=>400,height=>400);
	$sky->draw_rect([0,0,400,400],[0,0,0,255]);

	#draw the moon
	$sky->draw_circle_filled([150,50],25,[255,255,0,255]);
	$sky->blit($app);
}
#move the rectangles in the while loop
sub rect_move
{
	#once the first rectangle is totally out of screen, it will be removed
	if($coord_x[1] < $rect_dist)
	{
		shift @coord_x;
		shift @height_upper;
		shift @height_lower;
	}
	#once there is space for next rectangle, it will generate the corresponding values
	if($coord_x[@coord_x - 1] < (400-$rect_dist-$rect_width))
	{
		push @coord_x, 400;
		push @height_upper, int(rand(320-$lower_upper)) + 40;
		push @height_lower, (400-$lower_upper)-$height_upper[@height_upper - 1];
	}
	#every time 1 pixel movement for every rectangle
	for ($i = 0; $i < @coord_x; $i++)
	{
		$upper_rect[$i] = [$coord_x[$i]--, 0, $rect_width, $height_upper[$i]];
		$lower_rect[$i] = [$coord_x[$i], 400-$height_lower[$i], $rect_width, $height_lower[$i]];
	}
}
#draw the rectangles
sub render
{
	#draw a full screen black rectangle to cover all objects
	#$app->draw_rect([0,0,400,400], [0,0,0,0]);
	draw_bg();
	#draw the new rectangles
	for ($i = 0; $i< @coord_x; $i++)
	{
		$app->draw_rect($upper_rect[$i],$color);
    	$app->draw_rect($lower_rect[$i],$color);
	}
	my $pic=SDL::Image::load('user.jpg');
	$pic= SDLx::Surface->new(surface =>$pic);
    $pic->blit($app,[0,0,$USER_WIDTH,$USER_HEIGHT],[175,$user_pos,$USER_WIDTH,$USER_HEIGHT]);
	
	$app->update();
}

#calculate the user new position
sub cal_user_pos
{
		$velocity = $velocity + $acceleration;
		$acceleration =0.5 if($velocity < -4);
		$user_pos = $user_pos + $velocity 	if($started == 1);
		$user_pos = 0 if ($user_pos < 0);
		gameover() if($user_pos > 360);
}

#check if user touch the blocks
sub check_coll(){
	for($i=0; $i<@upper_rect; $i++){
		if(($upper_rect[$i][0] > 175 - $rect_width) && ($upper_rect[$i][0] < 215) ){
			if(($height_upper[$i] > $user_pos) || ( $user_pos + $USER_HEIGHT > $height_upper[$i]  + $lower_upper)){
			gameover();
			}
		}
	}
}

#handle when game over
sub gameover(){
	$quit =1; 
	print 'Game Over! scorce = ' ,$score;
}

#while loop, runs every 0.03 sec
while (!$quit){   
      get_events();
	  rect_move() if($started == 1);
	  cal_user_pos();
	  render();
	  check_coll();
      select(undef, undef, undef, 0.01);	  
    } 