/*  Notes
*/
//-------------------------------------------------------------------------------args
_zone = _this select 0;                                                                     //hint
_spottedpos = _this select 1;
_player = _this select 2;
_gopara = _this select 3;

//-------------------------------------------------------------------------------setup
_veh = call compile format ["%1heli",_zone];
//---------randomizer to estimate ticket call
while {(count waypoints group _veh) > 2} do {sleep (random 5 + 5)}; //leave while!

_veh = vehicle _veh;   //lock in current vehicle name from _veh global var
_driver = driver _veh;
_group = group _driver;
_groupE = group ((assignedCargo _veh) select 0);
_para = (_player != vehicle _player or _gopara);

//-------------------------------------------------------------------------------get moving
_group addWaypoint [_spottedpos,0];
[_group,2] setWaypointType "move";
[_group,2] setwaypointSpeed "full";
_group setcurrentwaypoint [_group,2];
hint format [
  "Heli called\nPara: %1\ngroupE: %2",
  _para, count units _groupE
];
waituntil {(_veh distance _spottedpos) < 300 or !alive _driver or !canMove _veh};

//-------------------------------------------------------------------------------abort
if (!alive _driver or !canMove _veh) exitWith{
  hint "aborting callheli";
};
[_group,1] setwaypointposition [_spottedpos,0]; //set for continuing search

//-------------------------------------------------------------------------------drop off
if (_para) then {
  for "_i" from 1 to 5 do {_veh fire "CMFlareLauncher";sleep .2};
  {_x action ["eject", vehicle _x]; sleep 1;} foreach units _groupE
} else {
  {unassignVehicle _x;} foreach units _groupE;
};
_groupE leaveVehicle _veh;
waituntil {count crew _veh <= 1};
[_groupE,[8,10],["normal",100]] spawn troops;   

//-------------------------------------------------------------------------------go load back up
[_veh, _zone] spawn loadheli;