/*  Notes
*/
//-------------------------------------------------------------------------------args
_zone = _this select 0;                                                                     //hint
_spottedpos = _this select 1;
_player = _this select 2;
_gopara = _this select 3;

//-------------------------------------------------------------------------------setup
_veh = call compile format ["%1heli",_zone];
call compile format ["KRON_UPS_%1pilot = 0", _zone];
waitUntil {
  sleep (random 1 + 1);
  _ready = _veh getVariable "ready";
  if (isNil "_ready") then {false} else {_ready};
};

_veh = vehicle _veh;   //lock in current vehicle name from _veh global var... may not do a damn thing?
_veh setVariable ["ready",false];
_driver = driver _veh;
_group = group _driver;
_groupE = group ((assignedCargo _veh) select 0);
_para = (_player != vehicle _player or _gopara);

//-------------------------------------------------------------------------------get moving
_driver doMove (_spottedpos);
_group setspeedMode "normal";

if (rossco_debug) then {
  hint format [
    "%1Heli called\nPara: %2\ngroupE: %3",
    _zone,_para, count units _groupE
  ];
};

sleep 1;
waituntil {(_veh distance _spottedpos) < 300 or !alive _driver or !canMove _veh};

//-------------------------------------------------------------------------------abort
if (!alive _driver or !canMove _veh) exitWith{
  if (rossco_debug) then {hint format ["%1Heli broke",_zone]};
};

//-------------------------------------------------------------------------------drop off
if (_para) then {
  for "_i" from 1 to 5 do {_veh fire "CMFlareLauncher";sleep .2};
  {_x action ["eject", vehicle _x]; sleep 1;} foreach units _groupE
} else {
  {unassignVehicle _x;} foreach units _groupE;
};
waituntil {count crew _veh <= 1};
_groupE leaveVehicle _veh;
if (rossco_debug) then {[_groupE] execVM "tracker.sqf"};

_markname = format ["%1drop%2",_zone,zonedrops];
zonedrops = zonedrops + 1;
_mark = createMarker [_markname,_spottedpos];
_mark setMarkerSize [200,200];
if (rossco_debug) then {_mark setMarkerShape "rectangle"; _mark setMarkerColor "colorRed";};

[leader _groupE,_markname] spawn ups;
_groupE reveal _player;
[_groupE] spawn rangemonitor;

//-------------------------------------------------------------------------------go load back up
[_veh, _zone] spawn loadheli;