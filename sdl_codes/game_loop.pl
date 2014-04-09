#!/usr/bin/perl -w
use SDL;
use SDLx::App;
use SDL::Event;

my $app=SDLx::App->new(w=>400,h=>400,d=>32,t=>"my lines");
my $color =[255,255,255,255];
my $drawing=0;
my $start=[0,0];
my $end=[400,400];



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
sub newline
{
    my $col1=int(rand(255));   
    my $col2=int(rand(255));   
    my $col3=int(rand(255));   
    $color =[$col1,$col2,$col3,255]; 
	$start=[int(rand(400)),int(rand(400))];
	$end=[int(rand(400)),int(rand(400))];	
}
sub render
{
    $app->draw_line($start,$end,$color,true);
	$app->update();
}
while (!$quit){   
      get_events();
	  newline();
	  render();
      sleep(1);	  
    } 