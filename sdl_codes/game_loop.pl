#!/usr/bin/perl -w
use SDL;
use SDLx::App;
use SDL::Event;

my $app=SDLx::App->new(w=>400,h=>400,d=>32,t=>"my lines");
my $color =[108,108,108,108];
my $drawing=0;
my @upper_rect=();
my @down_rect=();
my @height_up=();
my @height_down=();
my @coord_x=(20, 140, 260, 380);

push @height_up, int(rand(120)) + 40;
push @height_down, 300-$height_up[0];
push @height_up, int(rand(120)) + 40;
push @height_down, 300-$height_up[1];
push @height_up, int(rand(120)) + 40;
push @height_down, 300-$height_up[2];
push @height_up, int(rand(120)) + 40;
push @height_down, 300-$height_up[3];

push @upper_rect, [$coord_x[0], 0, 60, $height_up[0]];
push @upper_rect, [$coord_x[1], 0, 60, $height_up[1]];
push @upper_rect, [$coord_x[2], 0, 60, $height_up[2]];
push @upper_rect, [$coord_x[3], 0, 60, $height_up[3]];
push @down_rect, [$coord_x[0], 400-$height_down[0], 60, $height_down[0]];
push @down_rect, [$coord_x[1], 400-$height_down[1], 60, $height_down[1]];
push @down_rect, [$coord_x[2], 400-$height_down[2], 60, $height_down[2]];
push @down_rect, [$coord_x[3], 400-$height_down[3], 60, $height_down[3]];	

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
sub rect_move
{
	if($coord_x[1] < 60)
	{
		shift @coord_x;
		shift @height_up;
		shift @height_down;
	}
	
	if($coord_x[@coord_x - 1] < 280)
	{
		push @coord_x, 400;
		push @height_up, int(rand(120)) + 40;
		push @height_down, 300-$height_up[@coord_x-1];
	}
	
	for ($i = 0; $i < @coord_x; $i++)
	{
		$upper_rect[$i] = [$coord_x[$i]--, 0, 60, $height_up[$i]];
		$down_rect[$i] = [$coord_x[$i], 400-$height_down[$i], 60, $height_down[$i]];
	}
}
sub render
{
	$app->draw_rect([0,0,400,400], [0,0,0,0]);
	for ($i = 0; $i< @coord_x; $i++)
	{
		$app->draw_rect($upper_rect[$i],$color);
    	$app->draw_rect($down_rect[$i],$color);
	}
	$app->update();
}
while (!$quit){   
      get_events();
	  rect_move();
	  render();
      #sleep(1);	  
    } 