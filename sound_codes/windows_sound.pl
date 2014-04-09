#!/usr/bin/perl -w

use Win32::Sound;
Win32::Sound::Volume('100%');
Win32::Sound::Play("file.wav");
Win32::Sound::Stop();