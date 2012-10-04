/*  Notes
*/
_group = _this select 0;

_isGone = {
  _gone = true;
  for "_i" from 0 to (count playableUnits) - 1 do {
    if ((units _group select 0) distance vehicle (playableUnits select _i) < range) exitWith{_gone = false};
  };
  _gone
};

while {count units _group > 0} do {
  waitUntil {sleep 2; call _isGone};
  sleep 30;
  waitUntil {count playableUnits > 0};
  if (call _isGone) exitWith{};
};

_veh = vehicle (units _group select 0);
if (units _group select 0 != _veh) then {
  _group leaveVehicle _veh;
  {unassignVehicle _x} foreach units _group;
  waituntil {!isEngineOn _veh};
  sleep 10;                            //should be waituntil crew == 0??? already tried some variations with issues
};

{deleteVehicle _x} foreach units _group;