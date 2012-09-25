/*  Notes
*/
//-------------------------------------------------------------------------------settings
_period = 20;								//check period                    30
_range = 2000;							//range before despawn              1500

//-------------------------------------------------------------------------------args
_group = _this select 0;
_inrange = true;
//-------------------------------------------------------------------------------monitor range

while {count units _group > 0 and _inrange} do {
  sleep _period;
	for "_i" from 0 to (count playableUnits) - 1 do {
		if ((units _group select 0) distance vehicle (playableUnits select _i) < _range) exitWith{_inrange = true};
    _inrange = false;
  };
};

_veh = vehicle (units _group select 0);
if (units _group select 0 != _veh) then {
  _group leaveVehicle _veh;
  {unassignVehicle _x} foreach units _group;
  waituntil {!isEngineOn _veh};
  sleep 10;                            //should be waituntil crew == 0??? already tried some variations with issues
};

{deleteVehicle _x} foreach units _group;