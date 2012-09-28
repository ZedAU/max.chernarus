/*  Notes
  nearObjects is cpu intensive, looks through all objects of the map!
*/

_trigsize = 800; //???

_starttime = time;
_districts = ["SWzone","SEzone","NEzone","NWzone"]; //blah!


{
  _size = (getMarkerSize _x) select 0;
  _districtPos = getMarkerPos _x;
  _districtforts = _districtPos nearObjects ["FlagPole_EP1",_size];

  _cap = 10;
  _cat1 = _size * .66; //from this to next
  _cat2 = _size * .33;
  _cat1forts = [];
  _cat2forts = [];
  _cat3forts = [];
  _capital = "";

  {
    _action = _x addaction [format ["Claim %1", _fortname], "claimfort.sqf", [_fortname]];  //******needs sqf, got all args?
    if (_action > 0) then {_x removeAction _action};
    
    //sort forts
    _dist = _districtPos distance _x;
    if (_dist > _cat1) then {
      _cat1forts set [count _cat1forts,_x];
    } else {
      if (_dist > _cat2) then {
        _cat2forts set [count _cat2forts,_x];
      } else {
        if (_dist > _cap) then {
          _cat3forts set [count _cat3forts,_x];
        } else {_capital = _x};
      };
    };
    
    /*    
    _fortpos = getposATL _district;
    _trig = createTrigger["EmptyDetector", _fortpos];
    _trig setTriggerActivation ["guer", "present", true];
    _trig setTriggerArea [_trigsize, _trigsize, 0, false];
    _spawn = format [
      "[%1,'%2',%3,['normal',50],100,%4] spawn spawner;[thisTrigger] spawn trigdelay",
      _fortpos, _enemy, _skill, _num
    ];
    _trig setTriggerStatements ["this", _spawn, ""];
    */

  } foreach _districtforts;
  
  player sideChat format ["cat1::::%1",_cat1forts];
  player sideChat format ["cat2::::%1",_cat2forts];
  player sideChat format ["cat3::::%1",_cat3forts];
  player sideChat format ["capital::::%1",_capital];
    
} foreach _districts;

hint format ["setup time: %1",time - _starttime];



/*

  _capital = _zonepos nearObjects ["FlagPole_EP1",20]; //remeber this is an array of hopefully 1
  _cat3forts = _zonepos nearObjects ["FlagPole_EP1",_size * .33];
  _cat2forts = _zonepos nearObjects ["FlagPole_EP1",_size * .66];
  _cat1forts = (_zonepos nearObjects ["FlagPole_EP1",_size]) - _cat2forts;
  _cat2forts = _cat2forts - _cat3forts;
  _cat3forts = _cat3forts - _capital;
  
*/