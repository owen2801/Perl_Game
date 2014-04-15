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
my $rect_dist=120;
my $rect_width=60;
my @coord_x=(20, 200, 380);

for ($i=0;$i<@coord_x;$i++)
{
	push @height_up, int(rand(200)) + 40;
	push @height_down, 280-$height_up[$i];
	push @upper_rect, [$coord_x[$i], 0, 60, $height_up[$i]];
	push @down_rect, [$coord_x[$i], 400-$height_down[$i], 60, $height_down[$i]];
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
sub rect_move
{
	if($coord_x[1] < $rect_dist)
	{
		shift @coord_x;
		shift @height_up;
		shift @height_down;
	}
	
	if($coord_x[@coord_x - 1] < (400-$rect_dist-$rect_width))
	{
		push @coord_x, 400;
		push @height_up, int(rand(200)) + 40;
		push @height_down, 280-$height_up[$i];
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
      select(undef, undef, undef, 0.03);	  
    } 