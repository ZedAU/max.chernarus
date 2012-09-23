/*  Notes
*/
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
[_group,2] setWaypointType "move";
_group setcurrentwaypoint [_group,2];
waituntil {((units _group select 0) distance (getwppos [_group,2])) < 200};
//or new enemy to load is engaged? etc;
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

hint format ["---Loading---\n_group: %1\n_groupE: %2", units _group select 0 , units _groupE];
//-------------------------------------------------------------------------------return to pre call location
//need to check progress
_group setcurrentwaypoint [_group,1];
//-------------------------------------------------------------------------------cleanup
deleteWaypoint [_group,2];          //only instance deleted?
waituntil {count crew _veh >= count units _groupE or count units _group == 0 or count units _groupE == 0};
//need to reloadheli if the troops are dead? wastetime location
hint "load done";