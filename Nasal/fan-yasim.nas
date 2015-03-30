var ffan = func{
var throttle   = getprop("/controls/engines/engine[0]/throttle");
var pitch    = 1-getprop("/controls/engines/engine[0]/mixture");
var thrust = 2*pitch-1; if (thrust<0) {thrust=0;}
var elevator = 1-getprop("/surface-positions/elevator-pos-norm");
var fan_target = throttle*thrust*elevator/2;
var flap_target = 1-(getprop("/velocities/airspeed-kt")-150)/50;
if (flap_target<0) {flap_target=0;}
if (flap_target>1) {flap_target=1;}
setprop("/controls/flight/fan", fan_target);
setprop("/controls/flight/flaps", flap_target);
setprop("/surface-positions/nozzle-yaw", (getprop("/surface-positions/rudder-pos-norm")*thrust));
}


setlistener("/surface-positions/elevator-pos-norm", ffan);