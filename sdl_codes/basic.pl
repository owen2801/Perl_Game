#!/usr/bin/perl -w
use SDL;
use SDLx::App;
my $app=SDLx::App->new(w=>400,h=>400,d=>32,t=>"myprogram:hello world");
$app->draw_line([20,100],[200,20],[255,255,0,255]);
$app->draw_rect([20,100,120,120],[255,0,0,255]);
$app->draw_circle([100,100],15,[255,0,0,255]);
$app->draw_circle_filled([100,100],15,[255,0,255,255]);
$app->update();
sleep(10);

