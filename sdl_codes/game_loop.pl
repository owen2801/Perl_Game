#!/usr/bin/perl -w
use SDL;
use SDLx::App;
use SDL::Event;

my $app=SDLx::App->new(w=>400,h=>400,d=>32,t=>"Flappy Me");
my $color =[108,108,108,108];
my $drawing=0;
my @upper_rect=(); #A dynamic array to store the properties of Upper Rectangle [x-coordinate, y-coordinate, width, height]
my @lower_rect=(); #A dynamic array to store the properties of lower Rectangle [x-coordinate, y-coordinate, width, height]
my @height_upper=(); #A dynamic array to store the height of upper rectangle
my @height_lower=(); #A dynamic arrary to store the height of lower retangle 
my $rect_dist=120; #The distance between two rectangles
my $rect_width=60; #The width of a rectangle
my @coord_x=(20, 200, 380); #A dynamic arrat to store the x-coordinate of drawing rectangles

#initialize the program, assign corresponding values.
for ($i=0;$i<@coord_x;$i++)
{
	push @height_upper, int(rand(200)) + 40;
	push @height_lower, 280-$height_upper[$i];
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
     }   
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
		push @height_upper, int(rand(200)) + 40;
		push @height_lower, 280-$height_upper[$i];
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
	$app->draw_rect([0,0,400,400], [0,0,0,0]);
	#draw the new rectangles
	for ($i = 0; $i< @coord_x; $i++)
	{
		$app->draw_rect($upper_rect[$i],$color);
    	$app->draw_rect($lower_rect[$i],$color);
	}
	$app->update();
}
#while loop, runs every 0.03 sec
while (!$quit){   
      get_events();
	  rect_move();
	  render();
      select(undef, undef, undef, 0.03);	  
    } 