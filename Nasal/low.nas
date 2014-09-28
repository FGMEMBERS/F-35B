##### low level animation loop
 
setlistener("/sim/signals/fdm-initialized", func {
 
settimer(low_loop, 1);
});
 
var low_loop = func {
 
var calt = getprop("position/altitude-agl-ft");
var cspd = getprop("velocities/groundspeed-kt");
var croll = getprop("orientation/roll-deg");
var burn0 = getprop("controls/engines/engine[0]/afterburner");
var burn1 = getprop("controls/engines/engine[1]/afterburner");
 
if((calt <= 100) and (cspd >= 400) and ((croll >= -60) and (croll <= 60)) ) 
  {   setprop("controls/state/low_level", 1);
  } 
elsif( ((calt > 100) and (calt <= 300)) and (cspd >= 400) and ((croll >= -40) and (croll <= 40)) ) 
  {   setprop("controls/state/low_level", 1);
  } 
elsif ((calt <= 100) and ((burn0 == 1) or (burn1 == 1)) and ((croll >= -60) and (croll <= 60)) ) 
  {   setprop("controls/state/low_level", 1);
  } 
elsif (((calt > 100) and (calt <= 300))  and ((burn0 == 1) or (burn1 == 1)) and ((croll >= -40) and (croll <= 40)) ) 
  {   setprop("controls/state/low_level", 1);
  } 
 
else 
  {   setprop("controls/state/low_level", 0);
  }
 
settimer(low_loop, 1);
}