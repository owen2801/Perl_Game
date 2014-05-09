#!/usr/bin/perl -w
use SDL;
use SDLx::App;
use SDL::Event;
use Term::ANSIColor;
use Win32::Sound;

my $event=SDL::Event->new();   
my $quit=2;
# prompt for user icon:

print 'please type the path to your user icon(Recommend: JPG Format, 40x40):';
my $user_pic = <STDIN>;
chomp($user_pic);
$user_pic ='user.jpg' if($user_pic eq '');


sub initialize
{
	$app=SDLx::App->new(w=>400,h=>500,d=>32,t=>"Flappy Me");
	$color =[108,108,108,108];
	$rect_dist=120; #The distance between two rectangles
	$rect_width=60; #The width of a rectangle

	$started = 0; #state if first mouse click is clicked
	$USER_WIDTH = 40;# const of user pic width
	$USER_HEIGHT = 40;#const of user pic height
	$lower_upper = 140;
	$life = 1;
	$score = 0; # saving score
	$current_score = 0; # saving score in int
	$final_score = 0;
	#initialize the program, assign corresponding values.

	while($quit == 2)
	{
		$quit = 0;
		@upper_rect=(); #A dynamic array to store the properties of Upper Rectangle [x-coordinate, y-coordinate, width, height]
		@lower_rect=(); #A dynamic array to store the properties of lower Rectangle [x-coordinate, y-coordinate, width, height]
		@height_upper=(); #A dynamic array to store the height of upper rectangle
		@height_lower=(); #A dynamic arrary to store the height of lower retangle
		@coord_x=(780, 960); #A dynamic arrat to store the x-coordinate of drawing 
		$velocity =0; # velocity of the bird, move top if negative
		$acceleration =0; #acceleration of user movement
		$user_pos =200;	#the y cord of the user
		#initialize the program, assign corresponding values.
		for ($i=0;$i<@coord_x;$i++)
		{
			push @height_upper, int(rand(320 - $lower_upper)) + 40;
			push @height_lower, (400-$lower_upper)-$height_upper[$i];
			push @upper_rect, [$coord_x[$i], 0, $rect_width, $height_upper[$i]];
			push @lower_rect, [$coord_x[$i], 400-$height_lower[$i], $rect_width, $height_lower[$i]];
		}
		game_loop();
	}
}

sub get_events
{
     SDL::Events::pump_events();   
     while (SDL::Events::poll_event($event))   
     {   
        $quit=1 if $event->type==SDL_KEYDOWN;   
		if ($event->type==SDL_MOUSEBUTTONDOWN){
			$started =1;
			$acceleration =-0.7;
			$velocity = 0;
			fly();
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
		$coord_x[$i] = $coord_x[$i] - 1.5;
		$upper_rect[$i] = [$coord_x[$i], 0, $rect_width, $height_upper[$i]];
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

	my $pic=SDL::Image::load($user_pic);
	$pic= SDLx::Surface->new(surface =>$pic);
    $pic->blit($app,[0,0,$USER_WIDTH,$USER_HEIGHT],[175,$user_pos,$USER_WIDTH,$USER_HEIGHT]);
	
	$app->update();
}

#calculate the user new position
sub cal_user_pos
{
		$velocity = $velocity + $acceleration;
		$acceleration =0.5 if($velocity < -6);
		$user_pos = $user_pos + $velocity 	if($started == 1);
		$user_pos = 0 if ($user_pos < 0);
		if($user_pos > 360){
			if ($life > 1 ){
					$life = $life - 1;
					print "Opps, your current number of life is $life. Start over";
					$quit = 2;
					$started = 0;
					dead();
				}else{
					gameover();
				}
		}
}

#check if user touch the blocks
sub check_coll(){
	FOO:{
	for($i=0; $i<@upper_rect; $i++)
	{
		if(($upper_rect[$i][0] > 175 - $rect_width) && ($upper_rect[$i][0] < 215) ){
			if(($height_upper[$i] > $user_pos) || ( $user_pos + $USER_HEIGHT > $height_upper[$i]  + $lower_upper)){
				if ($life > 1 ){
					$life = $life - 1;
					print "Opps, your remaining number of life is $life. Wait 3 seconds to play again\n";
					$quit = 2;
					$started = 0;
					dead();
					last FOO;
				}else{
					gameover();
				}
			}else{
				$score = $score + 1;
			}
		}
	}
	}
}

#cal life
sub lifeleft(){
		$current_score = int($score/60);
	  	if ( $current_score != $final_score){
	  		$final_score = $current_score;
	  		if ( $final_score % 2 == 0){
	  			$life = $life + 1;
	  		}
	  		print "current score = $final_score & life = $life. \n";
	  	}
	  
}


#handle when game over
sub gameover(){
	dead();
	$quit = 1;
	print 'Game Over! scorce = ' , int($score/60);
}

#play fly sound
sub fly()
{
	Win32::Sound::Volume('100%');
	Win32::Sound::Play("fly-test.wav", SND_ASYNC);
}

#play dead sound
sub dead()
{
	Win32::Sound::Volume('100%');
	Win32::Sound::Play("dead-test.wav");
	Win32::Sound::Stop();
}


initialize();
#while loop
sub game_loop
{
	while (!$quit)
	{   
      get_events();
	  rect_move() if($started == 1);
	  cal_user_pos();
	  render();
	  lifeleft();
	  check_coll();
      select(undef, undef, undef, 0.007);	  
    }
}
