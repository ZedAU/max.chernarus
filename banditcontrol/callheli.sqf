/*  Notes
*/
//-------------------------------------------------------------------------------args
_zone = _this select 0;                                                                     //hint
_spottedpos = _this select 1;
_player = _this select 2;
_gopara = _this select 3;

//-------------------------------------------------------------------------------setup
_veh = call compile format ["%1heli",_zone];  //need call???
//---------randomizer to estimate ticket call
while {!alive _veh or (count waypoints group _veh) > 2} do {sleep (random 5 + 5)};
_group = group driver _veh;
_groupE = group (assignedCargo _veh select 0);
  //player is in veh or para called (bandit damage)
_para = (_player != vehicle _player or _gopara);

//-------------------------------------------------------------------------------get moving
_group addWaypoint [_spottedpos,0];
[_group,2] setWaypointType "move";
_group setcurrentwaypoint [_group,2];
sleep 2;
[_group,1] setwaypointposition [_spottedpos,0]; //set for continuing search from here
hint format [
  "Heli called\nPara: %1\ngroupE: %2",
  _para, count units _groupE
];

waituntil {(_veh distance (getwppos [_group,2])) < 300 or !alive driver _veh or !(canMove _veh)};

//-------------------------------------------------------------------------------abort
if (!alive driver _veh or !(canMove _veh)) exitWith {
  _group setcurrentwaypoint [_group,1];
  deleteWaypoint [_group,2];
};

//-------------------------------------------------------------------------------drop off
if (_para) then {
  for "_i" from 1 to 5 do {_veh fire "CMFlareLauncher";sleep .2};
  {_x action ["eject", vehicle _x]; sleep 1;} foreach units _groupE
} else {
  {unassignVehicle _x;} foreach units _groupE;
};
_groupE leaveVehicle _veh;
waituntil {sleep 1; count crew _veh == 1 or (count units _group) == 0};
  //could add trigger for persistance
[_groupE,[8,10],["normal",100]] spawn troops;   

//-------------------------------------------------------------------------------go load back up
[_group, _veh, _zone] spawn loadheli;