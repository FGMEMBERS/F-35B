    setlistener("/controls/engines/engine[0]/throttle", func(n) {
	position=n.getValue();
    setprop("/controls/engines/engine[0]/reheat",0);
        if(position >= 0.95){

               setprop("/controls/engines/engine[0]/reheat",1);
     };
   },1);






## LIGHTS

beacon_switch = props.globals.getNode("controls/lighting/beacon", 1);
var beacon = aircraft.light.new( "/sim/model/lights/beacon", [0.05, 1.2,], "/controls/lighting/beacon" );

strobe_switch = props.globals.getNode("controls/switches/strobe", 1);
var strobe = aircraft.light.new( "/sim/model/lights/strobe", [0.05, 3,], "/controls/lighting/strobe" );


beacon_switch = props.globals.getNode("controls/lighting/nav-lights", 1);
var strobe = aircraft.light.new( "/sim/model/lights/nav-lights", [0.5, 1,], "/controls/lighting/nav-lights" );



# WING FOLD

var wing = aircraft.door.new("wings", 10);
var switch = props.globals.getNode("sim/model/F-35/controls/wings/wings-switch", 1);
var pos = props.globals.getNode("wings/position-norm", 1);

var wings_switch = func(v) {

	var p = pos.getValue();

	if (v == 2 ) {
		if ( p < 1 ) {
			v = 1;
		} elsif ( p >= 1 ) {
			v = -1;
		}
	}

	if (v < 0) {
		switch.setValue(1);
		wing.close();

	} elsif (v > 0) {
		switch.setValue(3);
		wing.open();

	}
}

# fixes cockpit when use of ac_state.nas #####
var cockpit_state = func {
	var switch = getprop("sim/model/F-35/controls/wings/wings-switch");
	if ( switch == 1 ) {
		setprop("wings/position-norm", 0);
	}
}

# used to the animation of the canopy switch and the canopy move
# toggle keystroke or 2 position switch

var cnpy = aircraft.door.new("canopy", 10);
var switch = props.globals.getNode("sim/model/F-35/controls/canopy/canopy-switch", 1);
var pos = props.globals.getNode("canopy/position-norm", 1);

var canopy_switch = func(v) {

	var p = pos.getValue();

	if (v == 2 ) {
		if ( p < 1 ) {
			v = 1;
		} elsif ( p >= 1 ) {
			v = -1;
		}
	}

	if (v < 0) {
		switch.setValue(1);
		cnpy.close();

	} elsif (v > 0) {
		switch.setValue(3);
		cnpy.open();

	}
}

# fixes cockpit when use of ac_state.nas #####
var cockpit_state = func {
	var switch = getprop("sim/model/35/controls/canopy/canopy-switch");
	if ( switch == 1 ) {
		setprop("canopy/position-norm", 0);
	}
}

