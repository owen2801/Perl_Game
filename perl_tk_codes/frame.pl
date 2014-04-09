 #!/usr/bin/perl -w
    use Tk;
    use strict;

    # Take top and the bottom - now implicit top is in the middle
    my $mw = MainWindow->new;
    $mw->title( 'The MainWindow' );
    $mw->Label(-text => 'At the top (default)')->pack;
    $mw->Label(-text => 'At the bottom')->pack(-side => 'bottom');
    $mw->Label(-text => 'The middle remains')->pack;

    # Since left and right are taken, bottom will not work...
    my $top1 = $mw->Toplevel;
    $top1->title( 'Toplevel 1' );
    $top1->Label(-text => 'Left')->pack(-side => 'left');
    $top1->Label(-text => 'Right')->pack(-side => 'right');
    $top1->Label(-text => '?Bottom?')->pack(-side => 'bottom');

    # But when you use Frames, things work quite alright
    my $top2 = $mw->Toplevel;
    $top2->title( 'Toplevel 2' );
    my $frame = $top2->Frame;
    $frame->pack;
    $frame->Label(-text => 'Left2')->pack(-side => 'left');
    $frame->Label(-text => 'Right2')->pack(-side => 'right');
    $top2->Label(-text => 'Bottom2')->pack(-side => 'bottom');

    MainLoop;