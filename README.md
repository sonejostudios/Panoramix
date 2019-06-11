# Panoramix
Stereo Panorama/Balance and Volume Automation Tool.


![screenshot](https://raw.githubusercontent.com/sonejostudios/Panoramix/master/Panoramix11.png "Panoramix (Ardour)")

Demo: https://www.youtube.com/watch?v=vEbl62ZnjqU


__Features:__
* Bypass the DSP, but not the meters (can be used as input monitor)
* Balance and Volume Mode
* Balance Mode for panorama/balance manipulation
* Volume Mode for volume LFOs
* Beat/Period: How many beats (n) in one LFO period (LFO = bpm / n).
* Speed Multiplier : How many LFO period in one beat (n) (LFO = bpm * n)
* LFOs: sin, triangle, saw, square, random
* Invert LFO
* LFO Bandwidth
* LFO Smoothness: change smooth time
* Make up Gain
* Final Balance
* Stereo Balance Meter: analyses the position of the source in the panorama
* Stereo clip indicator
* LV2 Presets



__Inputs/Outputs:__
* Audio Inputs (L,R)
* Audio Outputs (L,R)


__LV2:__
* An LV2 Build with presets can be found under releases: https://github.com/sonejostudios/Panoramix/releases
* Unpack LV2 build in your LV2 folder, e.g ~/.lv2
* Panoramix.lv2 : the dsp
* Panoramix.presets.lv2 : the presets


__Build/Install:__
* Use the Faust Online Compiler to compile it as Standalone Jack Application or Audio Plugin (LV2, VST, etc): http://faust.grame.fr/compiler
* This software was tested only with Linux JackQT Faust Compiler and as LV2 on a Linux machine.

* To compile a JackQt Standalone application simply with (you'll need to install the Faust Compiler): 
  * $ faust2jaqt Panoramix.dsp
* To Start:
  * $ ./Panoramix



__LV2 Presets:__
* default
* ducking: simulates a ducking on the beat
* lanscape: scanning slowly the panorama
* random-bal: random position in the panorama
* random-vol: random volume
* reverse-saw: a saw up LFO
* shutter: fast volume lfo





