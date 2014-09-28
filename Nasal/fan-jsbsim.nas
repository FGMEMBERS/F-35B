var ffan = func{
eng = props.globals.getNode("/controls/engines/engine[0]");
var throttle   = getprop("/controls/engines/engine[0]/throttle");
var pitch    = 1-getprop("/controls/engines/engine[0]/mixture");
var thrust = 2*pitch-1; if (thrust<0) {thrust=0;}
var rudder = getprop("/fdm/jsbsim/fcs/rudder-cmd-norm-filtered");
var elevator = 1-getprop("/surface-positions/elevator-pos-norm");
var fan_target = throttle*thrust*elevator/2;
var jetL = throttle*thrust*(getprop("/controls/flight/aileron")+1)/2; if (jetL < 0) {jetL=0;} if (jetL > 1) {jetL=1;}
var jetR = throttle*thrust*(1-getprop("/controls/flight/aileron"))/2; if (jetR < 0) {jetR=0;} if (jetR > 1) {jetR=1;}
if ((throttle > 0.99) and (pitch < 0.1))
{eng.getChild("augmentation").setBoolValue(1);}
else
{eng.getChild("augmentation").setBoolValue(0);}
if ((getprop("/fdm/jsbsim/fcs/fbw-override")==0) and (pitch > 0.1))
{
setprop("/fdm/jsbsim/fcs/fbw-override",1);
screen.log.write("FBW override ON",1,1,1);
}
setprop("/fdm/jsbsim/propulsion/engine[0]/yaw-angle-rad", rudder*thrust*(-0.21));
setprop("/surface-positions/nozzle-yaw", rudder*thrust);
setprop("/fdm/jsbsim/propulsion/engine[0]/pitch-angle-rad", 1.66*thrust);
setprop("/fdm/jsbsim/fcs/throttle1", fan_target);
setprop("/fdm/jsbsim/fcs/throttle2", jetR);
setprop("/fdm/jsbsim/fcs/throttle3", jetL);
}

setlistener("/surface-positions/elevator-pos-norm", ffan);