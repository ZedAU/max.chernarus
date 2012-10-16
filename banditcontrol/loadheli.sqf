
private ["_veh","_zone","_loadCATO","_loadpos","_pilot","_fact","_groupE","_timer"];
//-------------------------------------------------------------------------------args
_veh = _this select 0;
_zone = _this select 1;
_loadCATO = 120;                        //time for loadup before CATO "resets" heli

_fortlist = [];
call compile format ["_fortlist = %1forts",_zone];
_fort = _fortlist select (floor random count _fortlist);
hint format ["veh: %1\nfort: %2",_veh,_fort]; //remove

_loadpos = [getPosATL _fort] call findClear;
//if (count _loadpos == 0) exitWith{hint "restarting loadheli"; [_veh, _zone] spawn loadheli};  //failed, restart

_pilot = driver _veh;
//-------------------------------------------------------------------------------move to capital
_pilot doMove (_loadpos);
group _pilot setspeedMode "normal";
waituntil {(_veh distance _loadpos) < 400 or !alive _pilot or !canMove _veh};

//-------------------------------------------------------------------------------abort
if (!alive _pilot or !canMove _veh) exitWith{
  hint "loadheli broke heli or driver";
};
//-------------------------------------------------------------------------------spawn load
//spawn new
_fact = switch (_zone) do {case "SWzone" :{"TK"};case "SEzone" :{"INS"};case "NEzone" :{"RU"};case "NWzone" :{"US"};};
_groupE = [getPosATL _fort, _fact, _zone, "norun"] call upsSpawner;

//-------------------------------------------------------------------------------load up
_groupE addVehicle _veh;
{_x assignAsCargo _veh;} foreach (units _groupE);  //needed?
_groupE addWaypoint [_loadpos,0];
[_groupE,1] setWaypointType "getin";

_timer = time + _loadCATO; //time to get in before CATO;
waituntil {count crew _veh > count units _groupE or time > _timer or !alive _pilot or !canMove _veh};

deleteWaypoint [_groupE,1];
if (time > _timer or !alive _pilot or !canMove _veh) exitWith{
  if (count units _groupE > 0) then {
    {_x action ["eject", vehicle _x]} foreach units _groupE;
    _groupE leaveVehicle _veh;
    sleep 5;
    [leader _groupE,_zone] spawn ups;
    [_groupE] spawn rangemonitor;
  };
  _veh setDamage 1;
  call compile format ["KRON_UPS_%1pilot = 1", _zone];
};

call compile format ["KRON_UPS_%1pilot = 1", _zone];
_veh setVariable ["busy",false];
if (rossco_debug) then {hint format ["%1 load done",_zone]};