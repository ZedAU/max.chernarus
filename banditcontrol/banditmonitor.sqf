/*  Notes                       //hint
*/
//-------------------------------------------------------------------------------Settings
_sens = 1;                            //awareness level when spotted occures 1 -> 4
_reset = 120;                         //timer before retrigger (120 min arma2 knowsAbout reset)
_per = 3;                             //patrol search period
//-------------------------------------------------------------------------------
_group = _this select 0;
_zone = _this select 1;

_timer = time + 10;
_origdamage = damage vehicle (units _group select 0);

while {count units _group > 0} do {
  _look = time > _timer;
  
  _spottedpos = [];
  _spotted = false;
  _player = null;
  for "_i" from 0 to (count playableUnits) - 1 do {
    if ((units _group select 0) knowsAbout vehicle (playableUnits select _i) > _sens) exitWith{
      _spotted = true;
      _player = playableUnits select _i;
      _spottedpos = getPosATL _player;
    };
  };
  
  if (_spotted and _look) then {
    _gopara = false;
    if (damage vehicle (units _group select 0) - _origdamage > 0) then {
      _gopara = true;
      _origdamage = damage vehicle (units _group select 0);
    };
    _handler = [_zone,_spottedpos,_player,_gopara] spawn callheli;
    waituntil {scriptDone _handler or count units _group == 0};
    _timer = time + _reset;
  };
  sleep _per;
};