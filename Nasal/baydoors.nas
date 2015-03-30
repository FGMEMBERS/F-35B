# used to the animation of the baydoors switch and the baydoors move
# toggle keystroke or 2 position switch

var cnpy = aircraft.door.new("baydoors", 10);
var switch = props.globals.getNode("sim/model/F-35B/controls/baydoors/baydoors-switch", 1);
var pos = props.globals.getNode("baydoors/position-norm", 1);

var baydoors_switch = func(v) {

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
	var switch = getprop("sim/model/F-35B/controls/baydoors/baydoors-switch");
	if ( switch == 1 ) {
		setprop("baydoors/position-norm", 0);
	}
}

