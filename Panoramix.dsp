declare name        "Panoramix";
declare version     "1.0";
declare author      "Vincent Rateau";
declare license     "GPL v3";
declare reference   "www.sonejo.net";
declare description	"Stereo Panorama/Balance and Volume Automation Tool.";

//Panoramix

import("stdfaust.lib");

process = bypassstereo : stereorama,_,_ :> _, _   : balancemeter : clipmeter ;

// main
stereorama = _*(inverter - oscil), _*(inverter2 - oscil)*(-volmode@avdelay)  : balance :  makeupgain : autovolstereo ;

// short break preventing clics for balance/volumemode
autovolstereo = _ * autovol, _ * autovol ;
autovol = (volmode==-1) - ((volmode==1)@avdelay) : an.amp_follower_ud(0.1, 0.1) ;
avdelay = 22050 ;


//osc inverter and volume mode
inverter = (volmode==1)@avdelay - invertbox * volmode@avdelay;
inverter2 = invertbox ;
invertbox =  gui_invertbox : si.smooth(0.999);
volmode =  gui_volmode , 1, -1 : select2 ;


// bpm to bps tools
bps = hgroup("[02]",  bpm_slider : _/60 : multiplier : divider)
  with{
    bpm_slider = gui_bpm_slider ;
    divider = _ / gui_devider ;
    multiplier = _ * gui_multiplier;
  };



// oscillator for balance/volume
oscil = autopanner : hgroup("[08]", bandwidth : smoothness) : _*(1-bypassbox) : gui_oscillator
  with{
    // for testing only
    autopanner_test = sinuslive ;
    sinuslive = (os.osc(bps) + 1) / 2 ;

    //lfo choice
    autopanner = synthchoice <: (_==0) * sinus, (_==1) * triangle, (_==2) *  saw, (_==3) *  square, (_==4) *  random :> _ ;
    synthchoice = gui_synthchoice ;

    //lfos
    sinus = (os.oscsin(bps) + 1) / 2 ;
    saw = (os.lf_sawpos(bps)) ;
    triangle = os.lf_trianglepos(bps) ;
    square = os.lf_squarewavepos(bps) ;
    random = no.lfnoise0(bps);

    bandwidth = (_ - 0.5) * gui_bandwidth : _ + 0.5 : si.smooth(0.999) ;

    smoothness = an.amp_follower_ud(smoothness_slider,smoothness_slider) ;
    smoothness_slider = gui_smoothness : si.smooth(0.999) ;
  };


//bypass
bypassstereo = bypassmono, bypassmono : route
  with{
    bypassmono = _ <: _ , _ : _*(1-bypassbox), _*bypassbox ;
    route(a,b,c,d) = a,c,b,d ;
  };
  //this is outside  the bypass function because of osc-bargraph * bypass-checkbox
  bypassbox =  gui_bypassbox : si.smooth(0.999);


// balance
//balance(a, b) = (a*(1-bal)), (b*(bal));
balance(a, b) = (a*(1-bal:sqrt)), (b*(bal:sqrt));
bal = gui_bal : si.smooth(0.999);


// output clip led
clipmeter = hgroup("[30]", outputclipL, outputclipR) ;
outputclipL = _ <: _, (an.amp_follower(1)  <:  _*(_>0.99)  : hbargraph("L Clip",0,1)) : attach ;
outputclipR = _ <: _, (an.amp_follower(1)  <:  _*(_>0.99)  : hbargraph("R Clip",0,1)) : attach ;


// extragain
makeupgain =  _ *gainslider, _ *gainslider ;
gainslider = gui_gainslider : si.smooth(0.999);



// stereo balance meter
balancemeter =  _,_ <: (_, _, stereometer) : (_ , _ , _) : (_, attach)
  with{
    //stereometer
    stereometer =  ampfollowers  <: ratiou, ratiod : ranges : gui_stereometer ;
    // amp follower for l and r
    ampfollowers = an.amp_follower_ud(0.1,0.1), an.amp_follower_ud(0.1,0.1) ;
    // ratio l/r
    ratiou(l,r) =  l / r :  _*(-1) : _+(1);
    // ratio r/l
    ratiod(l,r) =  r / l :  _*(-1) : _+(2) : 1-_;
    // use u if val >= 0, d if val < 0
    ranges(u,d) = u * (u >= 0) +  d * (d < 0);
    };




// GUI
///////////////////////////


gui_bypassbox = checkbox("[00]Bypass") ;
gui_volmode = checkbox("[01]Balance/Volume Mode") ;


gui_bpm_slider = hslider("[03]Bpm[style:knob]",120,0,240,0.01) ;
gui_devider = nentry("[04]Beat/Period", 2,1,256,1) ;
gui_multiplier = nentry("[05]Speed Multiplier", 1,1,128,1) ;

gui_synthchoice = vslider("[06]Oscillator Type[style:menu{'sin':0 ; 'triangle':1 ; 'saw':2 ; 'square':3 ; 'random':4}]", 0,0,4,1) ;
gui_invertbox = checkbox("[07]Invert Oscillator") ;

gui_bandwidth = hslider("[08]Bandwidth[style:knob]",1,0.001,1,0.001) ;
gui_smoothness = hslider("[09]Smoothness[style:knob]",0,0,0.5,0.001) ;

gui_oscillator =  hbargraph("[10]Oscillator",0 ,1) ;

gui_gainslider =  hslider("[11]Make Up Gain", 1.5, 0, 3, 0.01);
gui_bal = hslider("[12]Balance",0.5,0,1,0.01) ;

gui_stereometer = hbargraph("[13]Stereo Balance Meter",-1,1) ;





// for testing only
synthtest = os.osc(440) <: _*0.9, _*0.9;
