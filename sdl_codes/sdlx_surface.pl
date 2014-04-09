#!/usr/bin/perl -w
use SDL;
use SDLx::App;

my $app=SDLx::App->new(w=>400,h=>400,d=>32,t=>"myprogram");
#draw the ground
$app->draw_rect([0,0,400,400],[10,80,10,255]);

for (my $i = 1; $i < 500; $i++){
    $app->[int(rand(400))][200+int(rand(200))]=[10,10,10,255];
}
#draw the sky
my $sky=SDLx::Surface->new(width=>400,height=>200);
$sky->draw_rect([0,0,400,200],[0,0,0,255]);

#draw the moon
$sky->draw_circle_filled([150,50],25,[255,255,0,255]);
#draw the stars
for (my $i = 1; $i < 50; $i++)
{
   my $x=int(rand(400));
   my $y=int(rand(200));
   if (not ($x>125 and $x<175  and $y >25 and $y<75))
   {
      $sky->draw_circle_filled([$x,$y],2,[0,0,200,255]);      
   }  
}
$sky->blit($app);
#draw the trees
for (my $i = 1; $i < 20; $i++){
    $x=int(rand(350));
    $y=150+int(rand(100));
    my $tree=SDL::Image::load('tree.jpg');
	$tree= SDLx::Surface->new(surface =>$tree);
    $tree->blit($app,[0,0,100,133],[$x,$y,100,133]);	
}
$app->update();
sleep(5);

