
private ["_veh","_group","_groupE","_zone"];
//-------------------------------------------------------------------------------args
_zone = _this select 0;                                                                     //hint
_spottedpos = _this select 1;
_player = _this select 2;
_gopara = _this select 3;

//-------------------------------------------------------------------------------setup
_veh = call compile format ["%1heli",_zone];
_busy = _veh getVariable "busy";
while {if (isNil "_busy") then {true} else {_busy}} do {
  sleep (random 2 + 1);
  _veh = call compile format ["%1heli",_zone];
  _busy = _veh getVariable "busy";
};

call compile format ["UPS_paused_%1pilot = false",_zone];
call compile format ["KRON_UPS_%1pilot = 0", _zone];
waitUntil {call compile format ["UPS_paused_%1pilot",_zone] or !canMove _veh};
sleep 2;


_veh = vehicle _veh;   //lock in current vehicle name from _veh global var... may not do a damn thing?
_veh setVariable ["busy",true];
_pilot = driver _veh;
_group = group _pilot;
_groupE = group ((assignedCargo _veh) select 0);
_para = (_player != vehicle _player or _gopara);

//-------------------------------------------------------------------------------get moving
_pilot doMove (_spottedpos);
_veh flyInHeight 80;
_group setspeedMode "full";

if (rossco_debug) then {
  hint format [
    "%1Heli called\nPara: %2\ngroupE: %3",
    _zone,_para, count units _groupE
  ];
};

waituntil {(_veh distance _spottedpos) < 300 or !alive _pilot or !canMove _veh};

//-------------------------------------------------------------------------------abort
if (!alive _pilot or !canMove _veh) exitWith{
  if (rossco_debug) then {hint format ["%1Heli broke",_zone]};
};

//-------------------------------------------------------------------------------drop off
if (_para) then {
  for "_i" from 1 to 5 do {_veh fire "CMFlareLauncher";sleep .2};
  {_x action ["eject", vehicle _x]; sleep 1;} foreach units _groupE;
  {unassignVehicle _x;} foreach units _groupE;
  waituntil {count crew _veh <= 1};
} else {
  _unloadpos = [_spottedpos] call findClear;
  _group addWaypoint [_unloadpos,0];
  [_group,1] setWaypointType "UNLOAD";
  _group setcurrentwaypoint [_group,1];
  {unassignVehicle _x;} foreach units _groupE;
  waituntil {count crew _veh <= 1};
  deleteWaypoint [_group,1];
};
{unassignVehicle _x;} foreach units _groupE;
waituntil {count crew _veh <= 1};
_groupE leaveVehicle _veh;
if (rossco_debug) then {[_groupE] execVM "tracker.sqf"};

_markname = format ["%1drop%2",_zone,zonedrops];
zonedrops = zonedrops + 1;
_mark = createMarker [_markname,_spottedpos];
_mark setMarkerSize [200,200];
if (rossco_debug) then {_mark setMarkerShape "rectangle"; _mark setMarkerColor "colorRed";};

sleep 5;
[leader _groupE,_markname] spawn ups;
//_groupE reveal _player;                      //this seems to be jamming helis
[_groupE] spawn rangemonitor;

//-------------------------------------------------------------------------------go load back up
[_veh, _zone] spawn loadheli;
