/*  Notes
  nearObjects is cpu intensive, looks through all objects of the map!
*/

_trigsize = 800; //???
_districts = ["SWzone","SEzone","NEzone","NWzone"]; //blah!
  
//FUNCTION for later
_fortsetup = {
  _forts = _this select 0;
  _enemyF = _this select 1;
  _skill = _this select 2;
  _num = _this select 3;
  {
    _fortpos = getposATL _x;
    _trig = createTrigger["EmptyDetector", _fortpos];
    call compile format ["trig%1 = _trig",_x];                       //this is for claimfort
    _trig setTriggerActivation ["guer", "present", true];
    _trig setTriggerArea [_trigsize, _trigsize, 0, false];
    _spawn = format [
      "[%1,'%2',%3,['normal',50],100,%4] spawn spawner;[thisTrigger] spawn trigdelay",
      _fortpos, _enemyF, _skill, _num
    ];
    _trig setTriggerStatements ["this", _spawn, ""];
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
  
// each fort
  {
    _index = _x addaction [format ["Claim %1", _x], "claimfort.sqf", [_x]];  //****** args?
    if (_index > 0) then {_x removeAction _index};
    
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
  
  _enemy = switch (_x) do {
    case "SWzone":{"TK"};
    case "SEzone":{"INS"};
    case "NEzone":{"RU"};
    case "NWzone":{"US"};
  };
  [_cat1forts,_enemy,[0,3],2] call _fortsetup;
  [_cat2forts,_enemy,[2,5],4] call _fortsetup;
  [_cat3forts,_enemy,[3,7],5] call _fortsetup;
  [[_capital],_enemy,[5,10],6] call _fortsetup;
  
} foreach _districts;