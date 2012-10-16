private ["_zone","_group","_groupE","_pilot"];

//-------------------------------------------------------------------------------Settings
_sens = 1;                            //knowledge level before call heli 1 -> 4
_reset = 120;                         //timer before retrigger (120 min arma2 knowsAbout reset)
_per = 3;                             //patrol search period
_sightingtimessetting = 3;
//-------------------------------------------------------------------------------
_group = _this select 0;
_zone = _this select 1;

_pilot = units _group select 0;
_veh = vehicle _pilot;
_groupE = group ((assignedCargo _veh) select 0);
_timer = time + 10;
_origdamage = damage _veh;
_sightingtimes = _sightingtimessetting;
_sightingtimer = time + 600;

_search = {
  _maxKnow = 0;
  for "_i" from 0 to (count playableUnits) - 1 do {
    _knowledge = _pilot knowsAbout vehicle (playableUnits select _i);
    if (_knowledge > 0 and _knowledge > _maxKnow) then {
      _maxKnow = _knowledge;
      _spotted = true;
      _player = playableUnits select _i;
      _spottedpos = getPosATL _player;
    };
  };
};

while {alive _pilot and alive _veh and canMove _veh} do {

  if (_sightingtimes == 0 and time > _sightingtimer) then {
    _sightingtimes = _sightingtimessetting;
    _sightingtimer = time + 600;
  };
  
  _spottedpos = [];
  _spotted = false;
  _player = objNull;
  _knowledge = 0;
  call _search;
  
  if (_spotted) then {
    /*
    if (_knowledge < _sens and _sightingtimes > 0) then {
      //pause ups;
      call compile format ["KRON_UPS_%1pilot = 0", _zone];
      _pilot domove _spottedpos;
      hint format ["heli waypoints: %1",count waypoints _group];
      waituntil {(_pilot distance _spottedpos) < 200 or !alive _pilot};
      _sightingtimes = _sightingtimes - 1;
      //continue ups;    
      call compile format ["KRON_UPS_%1pilot = 1", _zone];
    };
    */
    if (_knowledge > _sens and time > _timer) then {
      _gopara = false;
      if (damage _veh - _origdamage > 0) then {
        _gopara = true;
        _origdamage = damage _veh;
      };
      _handler = [_zone,_spottedpos,_player,_gopara] spawn callheli;
      waituntil {sleep 2; scriptDone _handler};
      waituntil {!(_veh getVariable "busy") or !alive _veh or !canMove _veh};
      _timer = time + _reset;
      _sightingtimes = _sightingtimessetting;
      _sightingtimer = time + 600;
    };
  };
  sleep _per;
};

if (count units _groupE > 0) then {
  {_x action ["eject", vehicle _x]} foreach units _groupE;
  _groupE leaveVehicle _veh;
  [leader _groupE,_zone] spawn ups;
  [_groupE] spawn rangemonitor;
};