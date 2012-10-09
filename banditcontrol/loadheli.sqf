/*  Notes
*/                       //hint
private ["_veh","_zone","_loadCATO","_loadpos","_driver","_group","_fact","_groupE","_timer"];
//-------------------------------------------------------------------------------args
_veh = _this select 0;
_zone = _this select 1;

_loadCATO = 120;                        //time for loadup before CATO "resets" heli

_fortlist = [];
call compile format ["_fortlist = %1forts",_zone];
_fort = _fortlist select (floor random count _fortlist);

_loadpos = [getPosATL _fort] call findClear;
if (count _loadpos == 0) exitWith{[_veh, _zone] spawn loadheli};

_driver = driver _veh;
_group = group _driver;
//-------------------------------------------------------------------------------move to capital
_driver doMove (_loadpos);
_group setspeedMode "normal";
waituntil {(_veh distance _loadpos) < 200 or !alive _driver or !canMove _veh};

//-------------------------------------------------------------------------------abort
if (!alive _driver or !canMove _veh) exitWith{
  hint "loadheli broke heli or driver";
};
//-------------------------------------------------------------------------------spawn load
//spawn new
_fact = switch (_zone) do {case "SWzone" :{"TK"};case "SEzone" :{"INS"};case "NEzone" :{"RU"};case "NWzone" :{"US"};};
_groupE = [_loadpos, _fact, _zone, "norun"] call upsSpawner;

//-------------------------------------------------------------------------------load up
_groupE addVehicle _veh;
{_x assignAsCargo _veh;} foreach (units _groupE);
(units _groupE) orderGetIn true;                     //may not be needed??? was assigning the wrong group
//-------------------------------------------------------------------------------cleanup
_timer = time + _loadCATO; //time to get in before CATO;
waituntil {count crew _veh >= count units _groupE or time > _timer or !alive _driver or !canMove _veh};
if (time > _timer or !alive _driver or !canMove _veh) exitWith{
  if (count units _groupE > 0) then {
    {_x action ["eject", vehicle _x]} foreach units _groupE;
    _groupE leaveVehicle _veh;
    sleep 3;
  };
  _veh setDamage 1;
};
call compile format ["KRON_UPS_%1pilot = 1", _zone];
_veh setVariable ["ready",true];
if (rossco_debug) then {hint format ["%1 load done",_zone]};