#!/usr/bin/perl -w
use SDL;
use SDLx::App;
use SDL::Event;

my $app=SDLx::App->new(w=>400,h=>400,d=>32,t=>"my paint");
my $color =[255,255,255,255];
my $drawing=0;
$app->add_event_handler(\&quit_handle);
$app->add_event_handler(\&key_event);
$app->add_event_handler(\&mouse_event);
$app->run();


sub quit_handle
{
    my $event=shift;
	my $controller=shift;
	$controller->stop() if $event->type==SDL_QUIT;
}

sub key_event
{
   my $keyevent=shift;
   if ($keyevent->type==SDL_KEYDOWN)
   {
       my $key_name=SDL::Events::get_key_name($keyevent->key_sym);
	   if ($key_name=~/^c$/){
	      $app->draw_rect([0,0,400,400],0);
	   }
	   elsif  ($key_name=~/^q$/)
	   {
	      $app->stop();
	   }
	   else
	   {
	        my $col1=int(rand(255));
			my $col2=int(rand(255));
			my $col3=int(rand(255));
         	$color =[$col1,$col2,$col3,255];
	   }   
   }
}

sub  mouse_event
{
    my $event=shift;
	if ($event->type==SDL_MOUSEBUTTONDOWN||$drawing)
	{
	    $drawing=1;
		my $x=$event->button_x;
		my $y=$event->button_y;		
		$app->draw_rect([$x,$y,2,2],$color);
		$app->update();
	}
    $drawing=0 if ($event->type==SDL_MOUSEBUTTONUP);	
	
}