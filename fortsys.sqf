/*  Notes
  nearObjects is cpu intensive, looks through all objects of the map!
*/

/*
_zones = ["SWzone","SEzone","NEzone","NWzone"];

_zonepos = getMarkerPos "SWzone";
_capitalpos = getposATL ((_zonepos nearObjects ["FlagPole_EP1",20]) select 0);

_trig = createTrigger["EmptyDetector",_capitalpos];
_trig setTriggerActivation ["GUER", "PRESENT", true];
_trig setTriggerArea [1000, 1000, 0, false];
_cat1spawn = format ["[%1,'US',[0,3],['normal',50],100,1] spawn spawner; [thisTrigger] spawn trigdelay", _capitalpos];
_trig setTriggerStatements ["this", _cat1spawn, ""];
*/

_zones = ["SWzone","SEzone","NEzone","NWzone"];

{
  _size = (getMarkerSize _x) select 0;
  _zonepos = getMarkerPos _x;
  _forts = _zonepos nearObjects ["FlagPole_EP1",_size];
  
  {
    _fortpos = getposATL _x;
    _trig = createTrigger["EmptyDetector", _fortpos];
    _trig setTriggerActivation ["GUER", "PRESENT", true];
    _trig setTriggerArea [1000, 1000, 0, false];
    _cat1spawn = format ["[%1,'TK',[0,3],['normal',50],100,2] spawn spawner; [thisTrigger] spawn trigdelay", _fortpos];
    _trig setTriggerStatements ["this", _cat1spawn, ""];
  } foreach _forts;
  
} foreach _zones;
/*

  
  
  _capital = _zonepos nearObjects ["FlagPole_EP1",20]; //remeber this is an array of hopefully 1
  _cat3forts = _zonepos nearObjects ["FlagPole_EP1",_size * .33];
  _cat2forts = _zonepos nearObjects ["FlagPole_EP1",_size * .66];
  _cat1forts = (_zonepos nearObjects ["FlagPole_EP1",_size]) - _cat2forts;
  _cat2forts = _cat2forts - _cat3forts;
  _cat3forts = _cat3forts - _capital;
  
  {
    _trig = createTrigger["EmptyDetector",getposATL _x];
    _trig setTriggerActivation ["GUER", "PRESENT", true];
    _trig setTriggerArea [1000, 1000, 0, false];
    _cat1spawn = format ["[%1,'US',[0,3],['normal',50],100,1] spawn spawner", getposATL _x];
    _trig setTriggerStatements ["this", _cat1spawn, ""];
    
  } forEach _cat1forts;
  

*/