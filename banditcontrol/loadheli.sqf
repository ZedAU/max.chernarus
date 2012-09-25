/*  Notes
*/                       //hint
//-------------------------------------------------------------------------------args
_group = _this select 0;      //one or the other?
_veh = _this select 1;
_zone = _this select 2;

//-------------------------------------------------------------------------------move to capital
if ((count waypoints group _veh) < 3) then {
  _group addWaypoint [getmarkerpos _zone,0];
} else {
  [_group,2] setwaypointposition [getmarkerpos _zone,0];
};
_driver = driver _veh;

[_group,2] setWaypointType "move";  //needed?
_group setcurrentwaypoint [_group,2];
waituntil {(_veh distance (getwppos [_group,2])) < 200 or !alive _driver or !canMove _veh};

//-------------------------------------------------------------------------------abort
if (!alive _driver or !canMove _veh) exitWith{
  _group setcurrentwaypoint [_group,1];
  deleteWaypoint [_group,2];
  hint "aborting loadheli";
};
//-------------------------------------------------------------------------------spawn load
//spawn new
_pick = USlist select (floor random (count USlist));  //zone magic needed
_spawn = (configFile >> "CfgGroups" >> _pick select 0 >> _pick select 1 >> "Infantry" >> _pick select 2);

_groupE = [getmarkerpos _zone, west, _spawn] call BIS_fnc_spawnGroup;
_groupE setCombatMode "red";
sleep 1;
//-------------------------------------------------------------------------------load up
_groupE addVehicle _veh;
{_x assignAsCargo _veh;} foreach (units _groupE);
(units _groupE) orderGetIn true;                     //may not be needed??? was assigning the wrong group
//-------------------------------------------------------------------------------return to pre call location
//need to check progress?
//-------------------------------------------------------------------------------cleanup
waituntil {count crew _veh >= count units _groupE or count units _group == 0 or count units _groupE == 0};
_group setcurrentwaypoint [_group,1];
deleteWaypoint [_group,2];          //only instance deleted? added to callheli abort
//need to reloadheli if the troops are dead? wastetime location?
hint "load done";