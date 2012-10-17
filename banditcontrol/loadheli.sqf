
private ["_veh","_zone","_loadCATO","_loadpos","_pilot","_fact","_groupCargo","_timer"];
//-------------------------------------------------------------------------------args
_veh = _this select 0;
_zone = _this select 1;
_loadCATO = 120;                        //time for loadup before CATO "resets" heli

_fortlist = [];
call compile format ["_fortlist = %1forts",_zone];
_fort = _fortlist select (floor random count _fortlist);

_loadpos = [getPosATL _fort] call findClear;
if (rossco_debug) then {hint format ["%1\n%2",_zone,_fort]};

_pilot = driver _veh;
//-------------------------------------------------------------------------------move to capital
_pilot doMove (_loadpos);
group _pilot setspeedMode "normal";
waituntil {(_veh distance _loadpos) < 300 or !alive _pilot or !canMove _veh};

//-------------------------------------------------------------------------------abort
if (!alive _pilot or !canMove _veh) exitWith{
  hint "loadheli broke heli or driver";
};
//-------------------------------------------------------------------------------spawn load
//spawn new
_fact = switch (_zone) do {case "SWzone" :{"TK"};case "SEzone" :{"INS"};case "NEzone" :{"RU"};case "NWzone" :{"US"};};
_groupCargo = [getPosATL _fort, _fact, _zone, "norun"] call upsSpawner;

//-------------------------------------------------------------------------------load up
_groupCargo addVehicle _veh;
{_x assignAsCargo _veh;} foreach (units _groupCargo);  //needed?
_groupCargo addWaypoint [_loadpos,0];
[_groupCargo,1] setWaypointType "getin";

_timer = time + _loadCATO; //time to get in before CATO;
waituntil {count crew _veh > count units _groupCargo or time > _timer or !alive _pilot or !canMove _veh};

deleteWaypoint [_groupCargo,1];
if (time > _timer or !alive _pilot or !canMove _veh) exitWith{
  if (count units _groupCargo > 0) then {
    {_x action ["eject", vehicle _x]} foreach units _groupCargo;
    _groupCargo leaveVehicle _veh;
    sleep 5;
    [leader _groupCargo,_zone] spawn ups;
    [_groupCargo] spawn rangemonitor;
  };
  _veh setDamage 1;
  call compile format ["KRON_UPS_%1pilot = 1", _zone];
};

call compile format ["KRON_UPS_%1pilot = 1", _zone];
_veh setVariable ["busy",false];
if (rossco_debug) then {hint format ["%1 load done",_zone]};