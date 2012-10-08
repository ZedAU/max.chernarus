/*  Notes
  nearObjects is cpu intensive, looks through all objects of the map!
*/

_districts = ["SWzone","SEzone","NEzone","NWzone"]; //blah!
//need some global place to pull list from user
// zone setup
/*
  _minx = _fortPos select 0;
  _maxx = _minx;
  _miny = _fortPos select 1;
  _maxy = _miny;
{
  
} forEach _districts;
*/
  
//FUNCTIONS for later

_bldArea = { private ["_list","_fortPos","_minx","_maxx","_miny","_maxy","_pos","_rx","_ry","_cPos"];
  _list = _this select 0;
  _fortPos = _this select 1;
  
  _minx = _fortPos select 0;
  _maxx = _minx;
  _miny = _fortPos select 1;
  _maxy = _miny;
  {
    _pos = getposATL _x;
    if (_pos select 0 < _minx) then {_minx = _pos select 0};
    if (_pos select 0 > _maxx) then {_maxx = _pos select 0};
    if (_pos select 1 < _miny) then {_miny = _pos select 1};
    if (_pos select 1 > _maxy) then {_maxy = _pos select 1};
  } foreach _list;
  
  _rx = (_maxx - _minx)/2; _ry = (_maxy - _miny)/2;
  _cPos = [_minx + _rx,_miny + _ry,0];
  [_rx,_ry,_cPos]
};

_fortsetup = {
  _forts = _this select 0;
  _fact = _this select 1;
  _skill = _this select 2;
  _num = _this select 3;
  _spRadius = 100;
  
  {
    _fortpos = getposATL _x;
    _houselist = _fortpos nearObjects ["Building",range/3];
    _area = [_houselist,_fortpos] call _bldArea;
    _rx = _area select 0; _ry = _area select 1; _cPos = _area select 2;
    
    _markname = format ["mark%1%2",_x,_fact];
    _mark = createMarker [_markname, _cPos];
    _mark setMarkerSize [_rx,_ry];
    if (rossco_debug) then {_mark setMarkerShape "rectangle"};
    
    _trig = createTrigger["EmptyDetector", _fortpos];
    _trig setTriggerActivation ["guer", "present", true];
    _trig setTriggerArea [range, range, 0, false];
    _spawn = format [
      "[%1,'%2','%3',%4,%5,%6] spawn upsSpawner;[thisTrigger] spawn trigdelay",
      _fortpos, _fact, _markname, _skill, _spRadius, _num
    ];
    _trig setTriggerStatements ["this", _spawn, ""];
    
    _trigarray = _x getVariable "trig";
    _trig = if (isnil "_trigarray") then {
      [_trig];
    } else {
      _trigarray + [_trig];
    };
    _x setVariable ["trig",_trig,false];
  } foreach _forts;
};

// each district
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
  
  _enemy = switch (_x) do {
    case "SWzone":{["TK","\ca\ca_e\data\flag_tka_co.paa"]};
    case "SEzone":{["INS","\ca\data\Flag_chdkz_co.paa"]};
    case "NEzone":{["RU","\ca\data\Flag_rus_co.paa"]};
    case "NWzone":{["US","\ca\data\Flag_usa_co.paa"]};
  };
  
// each fort
  {
    clearVehicleInit _x; //leaves only one addaction for multizone forts
    _x setVehicleInit format ["this addaction ['Claim %1', 'claimfort.sqf', this]",_x];
    _x setflagtexture (_enemy select 1); //sets last zones flag... lots of switching for nothing?
    
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
  } foreach _districtforts;
  
  [_cat1forts,_enemy select 0,[0,3],2] call _fortsetup;
  [_cat2forts,_enemy select 0,[2,5],3] call _fortsetup;
  [_cat3forts,_enemy select 0,[3,7],5] call _fortsetup;
  [[_capital],_enemy select 0,[5,10],6] call _fortsetup;
  
} foreach _districts;

processInitCommands;