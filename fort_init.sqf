
// zone setup
_first = getMarkerPos (districts select 0);
_xmin = _first select 0; _xmax = _first select 0;
_ymin = _first select 1; _ymax = _first select 1;
  
{
  _pos = getMarkerPos _x;
  _size = (getMarkerSize _x) select 0;
  if ((_pos select 0) - _size < _xmin) then {_xmin = (_pos select 0) - _size};
  if ((_pos select 0) + _size > _xmax) then {_xmax = (_pos select 0) + _size};
  if ((_pos select 1) - _size < _ymin) then {_ymin = (_pos select 1) - _size};
  if ((_pos select 1) + _size > _ymax) then {_ymax = (_pos select 1) + _size};
} forEach districts;

_xtot = _xmax - _xmin; _ytot = _ymax - _ymin;
_xhalf = _xtot/2; _yhalf = _ytot/2;
_xquart = _xtot/4; _yquart = _ytot/4;

_grid = [
  [_xmin + _xquart,_ymax - _yquart,0],[_xmax - _xquart,_ymax - _yquart,0],
  [_xmin + _xquart,_ymin + _yquart,0],[_xmax - _xquart,_ymin + _yquart,0]
];

_cols = ["ColorRed","ColorOrange","ColorGreen","ColorYellow"];
_index = 0;
{
  _mark = createMarker [zones select _index,_x];
  _mark setMarkerSize [_xquart,_yquart];
  if (rossco_debug) then {
    _mark setMarkerShape "rectangle";
    _mark setMarkerColor (_cols select _index);
  };
  _index = _index + 1;
} forEach _grid;
  
//FUNCTIONS
_bldArea = { private ["_x","_list","_fortPos","_minx","_maxx","_miny","_maxy","_pos","_rx","_ry","_cPos"];
  _list = _this select 0;
    
  _fortPos = _this select 1;
  _minx = _fortPos select 0;
  _maxx = _minx;
  _miny = _fortPos select 1;
  _maxy = _miny;
  {
    _pos = getposATL _x;
    if (count (_pos nearObjects ["Building",40]) > 1) then {
      if (_pos select 0 < _minx) then {_minx = _pos select 0};
      if (_pos select 0 > _maxx) then {_maxx = _pos select 0};
      if (_pos select 1 < _miny) then {_miny = _pos select 1};
      if (_pos select 1 > _maxy) then {_maxy = _pos select 1};
    };
  } foreach _list;
  
  _rx = (_maxx - _minx)/2; _ry = (_maxy - _miny)/2;
  _cPos = [_minx + _rx,_miny + _ry,0];
  [_rx,_ry,_cPos]
};

_fortsetup = { private ["_x","_forts","_fact","_skill","_num","_spRadius","_fortpos","_houselist",
  "_area","_rx","_ry","_cPos","_markname","_mark","_markarray","_marks","_trig","_spawn","_trigarray","_trigs"];
  _forts = _this select 0;
  _fact = _this select 1;
  _skill = _this select 2;
  _num = _this select 3;
  _spRadius = 100;
  
  {
    _fortpos = getPosATL _x;
    _houselist = _fortpos nearObjects ["Building",range/3];
    _area = [_houselist,_fortpos] call _bldArea;
    _rx = _area select 0; _ry = _area select 1; _cPos = _area select 2;
    
    //make marker for patrol area
    _markname = format ["mark%1%2",_x,_fact];
    _mark = createMarker [_markname, _cPos];
    _mark setMarkerSize [_rx,_ry];
    if (rossco_debug) then {_mark setMarkerShape "rectangle"};
    //set in fort variable
    _markarray = _x getVariable "mark";
    _marks = if (isnil "_markarray") then {
      [_mark];
    } else {
      _markarray + [_mark];
    };
    _x setVariable ["marks",_marks,false];
    
    //make trigger
    _trig = createTrigger["EmptyDetector", _fortpos];
    _trig setTriggerActivation ["guer", "present", true];
    _trig setTriggerArea [range, range, 0, false];
    _spawn = format [
      "[%1,'%2','%3',%4,%5,%6] spawn upsSpawner;[thisTrigger] spawn trigdelay",
      _fortpos, _fact, _markname, _skill, _spRadius, _num
    ];
    _trig setTriggerStatements ["this", _spawn, ""];
    //set in fort variable
    _trigarray = _x getVariable "trig";
    _trigs = if (isnil "_trigarray") then {
      [_trig];
    } else {
      _trigarray + [_trig];
    };
    _x setVariable ["trig",_trigs,false];
  } foreach _forts;
};

NWzoneforts = []; NEzoneforts = []; SWzoneforts = []; SEzoneforts = []; //global zone forts lists
// each district
{
  _size = (getMarkerSize _x) select 0;
  _districtPos = getMarkerPos _x;
  _districtx = _districtPos select 0;
  _districty = _districtPos select 1;
  _districtforts = _districtPos nearObjects ["FlagPole_EP1",_size];
  
  _enemy = ["US","\ca\data\Flag_usa_co.paa"];  //default if anything goes wrong?
  if (_districtx < _xhalf and _districty > _yhalf) then {
    _enemy = ["US","\ca\data\Flag_usa_co.paa"];
    NWzoneforts = NWzoneforts + _districtforts;
  } else {
    if (_districtx > _xhalf and _districty > _yhalf) then {
      _enemy = ["RU","\ca\data\Flag_rus_co.paa"];
      NEzoneforts = NEzoneforts + _districtforts;
    } else {
      if (_districtx < _xhalf and _districty < _yhalf) then {
        _enemy = ["TK","\ca\ca_e\data\flag_tka_co.paa"];
        SWzoneforts = SWzoneforts + _districtforts;
      } else {
        if (_districtx > _xhalf and _districty < _yhalf) then {
          _enemy = ["INS","\ca\data\Flag_chdkz_co.paa"];
          SEzoneforts = SEzoneforts + _districtforts;
        };
      };
    };
  };
  
  _cap = 10;
  _cat1 = _size * .66; //from this to next
  _cat2 = _size * .33;
  _cat1forts = [];
  _cat2forts = [];
  _cat3forts = [];
  _capital = "";
  
// each fort in district
  {
    clearVehicleInit _x; //leaves only one addaction for multizone forts
    _x setVehicleInit format ["this addaction ['Claim %1', 'claimfort.sqf', this]",_x];
    _x setflagtexture (_enemy select 1); //sets last zone flag, not ideal
    
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
        } else {_capital = _x};  // has to be only one fort pole within cap distance
      };
    };
  } foreach _districtforts;
  
  [_cat1forts,_enemy select 0,[0,3],2] call _fortsetup;
  [_cat2forts,_enemy select 0,[2,5],3] call _fortsetup;
  [_cat3forts,_enemy select 0,[3,7],5] call _fortsetup;
  [[_capital],_enemy select 0,[5,10],6] call _fortsetup;
  
} foreach districts;

processInitCommands;