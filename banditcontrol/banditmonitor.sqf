//-------------------------------------------------------------------------------Settings
_sens = 1;                            //awareness level when spotted occures 1 -> 4
_reset = 120;                         //timer before retrigger (120 min arma2 knowsAbout reset)
_per = 3;                             //patrol search period
_sightingtimessetting = 3;
//-------------------------------------------------------------------------------
_group = _this select 0;
_zone = _this select 1;

_timer = time + 10;
_origdamage = damage vehicle (units _group select 0);
_sightingtimes = _sightingtimessetting;
_sightingtimer = time + 600;

_search = { private ["_knowledge","_spottedpos","_spotted","_player"];
  _spottedpos = [];
  _spotted = false;
  _player = null;
  _knowledge = 0;
  
  for "_i" from 0 to (count playableUnits) - 1 do {
    _knowledge = (units _group select 0) knowsAbout vehicle (playableUnits select _i);
    if (_knowledge > 0) exitWith{
      _spotted = true;
      _player = playableUnits select _i;
      _spottedpos = getPosATL _player;
    };
  };
  [_spotted, _player, _spottedpos, _knowledge]
};

while {count units _group > 0} do {

  if (_sightingtimes == 0 and time > _sightingtimer) then {
    _sightingtimes = _sightingtimessetting;
    _sightingtimer = time + 600;
  };
  
  _found = call _search;
  _spotted = _found select 0; _player = _found select 1; _spottedpos = _found select 2; _knowledge = _found select 3; //could just let _search set?
  if (_spotted) then {
    ;/*
    if (_knowledge < _sens and _sightingtimes > 0) then {
      //pause ups;
      call compile format ["KRON_UPS_%1pilot = 0", _zone];
      (units _group select 0) domove (_sighting select 2);
      waituntil {unitReady (units _group select 0)};  //may not work?
      _sightingtimes = _sightingtimes - 1;
      //continue ups;    
      call compile format ["KRON_UPS_%1pilot = 1", _zone];
    };
    */
    if (_knowledge > _sens and time > _timer) then {
      _gopara = false;
      if (damage vehicle (units _group select 0) - _origdamage > 0) then {
        _gopara = true;
        _origdamage = damage vehicle (units _group select 0);
      };
      _handler = [_zone,_spottedpos,_player,_gopara] spawn callheli;
      waituntil {scriptDone _handler or count units _group == 0}; //need to check if dead?  should finish anyway
      _timer = time + _reset;
      _sightingtimes = _sightingtimessetting;
      _sightingtimer = time + 600;
    };
  };
  sleep _per;
};