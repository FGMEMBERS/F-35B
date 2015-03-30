#Terrain following script by glazmax
#To activate/use prepare the following properties:
#1.)set/create property: "instruments/tfs/range" to 1,2 or 3 (=nm radar range terrain prefetch)
#2.)set/create property: "controls/switches/terrain-follow-clr" to desired terrain clearance in ft (eg.200 or 600)
#3.)set/create/toggle property: "controls/switches/terrain-follow" to true
#
#terrain following 1000km/h:277.778m/s

setlistener("controls/switches/terrain-follow", func() {
  var act_path = [0,0,0];
  setprop("controls/switches/terrain-follow-rng",1);
  setprop("instrumentation/tfs/range",1);
  setprop("instrumentation/tfs/high", 0);
  setprop("instrumentation/tfs/time", 0);
  setprop("instrumentation/tfs/loww", 0);
  tfs.beam_max();
});

#create beam interval 0.1s = 27m resolution at 540knots

var beam_max = func() { 

  #var alt_mat = n;
  var range = getprop("instrumentation/tfs/range");
  var radar_range = range * 1852;#to m

  var clat = getprop("position/latitude-deg");
  var clon = getprop("position/longitude-deg");
  var c_pos = geo.Coord.new().set_latlon(clat, clon);
  #debug.dump(c_pos);
  var c_hdg = getprop("orientation/heading-magnetic-deg");
  var c_speed = getprop("velocities/groundspeed-kt");
  var d_alt = getprop("controls/switches/terrain-follow-clr");
  var m_speed = c_speed * 0.51444;#conv to m/s
  var t_time = radar_range / m_speed;

  var point_coord = c_pos.apply_course_distance(c_hdg, radar_range);
  var point_e = geo.elevation(point_coord.lat(),point_coord.lon());

  if (point_e == nil){
    point_e = 0;
    print("Radar scan malfunction, no terrain found!");
    setprop("instrumentation/tfs/beam-malfunction",1);
    #return(beam_max);
  } elsif (point_e != nil){
      setprop("instrumentation/tfs/beam-malfunction",0);
  }

  var point_ele = int((point_e * 3.2808) + d_alt);
  #debug.dump(point_ele);

  #if tfs on --> loop and feed ap_react
  var enabled = getprop("controls/switches/terrain-follow");
  if (enabled) {
    ap_react(radar_range, point_ele, t_time);
    settimer(beam_max,0.1);
  }
}

#compute following behaviour according to scan results
var ap_react = func(n,m,o){

  var radar_range = n;
  var point_ele = m;
  var t_time = o;

  #var alt_mat = getprop("instrumentation/tfs/alt_mat");
  var high = getprop("instrumentation/tfs/high");
  var time = getprop("instrumentation/tfs/time");
  var loww = getprop("instrumentation/tfs/loww");
  
  var c_alt = getprop("position/altitude-ft");

  if (point_ele > c_alt) {
    print("^up");
    if (high < point_ele){
      high = point_ele;
      time = t_time;
    } elsif (high > point_ele){
        time -= 0.1;
        if (loww < point_ele){
          loww = point_ele;
        }
  }
  
    setprop("instrumentation/tfs/high", high);
    setprop("instrumentation/tfs/time", time);
    setprop("instrumentation/tfs/loww", loww);
    ap_adjust(high);

  } elsif (point_ele < c_alt){
      print("vdown");
      setprop("instrumentation/tfs/high", -999);  
      time -= 0.1;
      setprop("instrumentation/tfs/time", time);
      if (loww < point_ele){
        loww = point_ele;
        setprop("instrumentation/tfs/loww", loww);
  }
      if (time < 0){

        time = t_time;
        setprop("instrumentation/tfs/time", time);
        setprop("instrumentation/tfs/loww", -999);
        ap_adjust(loww);
  }
  }
}

#adjust the autopilot "terrain-follow" function
var ap_adjust = func(n) {

  var t_alt = n;
  setprop("autopilot/settings/target-follow-altitude-ft",t_alt);
  setprop("autopilot/locks/altitude", "terrain-follow");
  #print("t_alt:");
  #debug.dump(t_alt);
}

#set range according to knob setting
var range_set = func(){
  var ranges = [0.5,1,2];
  var r_set = getprop("controls/switches/terrain-follow-rng");
  setprop("instrumentation/tfs/range",ranges[r_set]);
  var set_print = ranges[r_set];
  #print("tfs_range: " ~ set_print ~ "!");
}