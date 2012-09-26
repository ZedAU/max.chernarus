/*  Notes
*/                       //hint
//-------------------------------------------------------------------------------args
_veh = _this select 0;
_zone = _this select 1;

_loadCATO = 120;                        //time to loadup before CATO "resets" heli

_zonepos = getmarkerpos _zone;
_driver = driver _veh;
_group = group _driver;
//-------------------------------------------------------------------------------move to capital
if ((count waypoints group _veh) < 3) then {
  _group addWaypoint [_zonepos,0];
} else {
  [_group,2] setwaypointposition [_zonepos,0];
};

[_group,2] setWaypointType "move";  //needed?
_group setcurrentwaypoint [_group,2];
waituntil {(_veh distance _zonepos) < 200 or !alive _driver or !canMove _veh};

//-------------------------------------------------------------------------------abort
if (!alive _driver or !canMove _veh) exitWith{
  hint "aborting loadheli";
};
//-------------------------------------------------------------------------------spawn load
//spawn new
_pick = USlist select (floor random (count USlist));  //zone magic needed
_spawn = (configFile >> "CfgGroups" >> _pick select 0 >> _pick select 1 >> "Infantry" >> _pick select 2);

_groupE = [_zonepos, west, _spawn] call BIS_fnc_spawnGroup;
_groupE setCombatMode "red";
sleep 1;
//-------------------------------------------------------------------------------load up
_groupE addVehicle _veh;
{_x assignAsCargo _veh;} foreach (units _groupE);
(units _groupE) orderGetIn true;                     //may not be needed??? was assigning the wrong group
//-------------------------------------------------------------------------------cleanup
_timer = time + _loadCATO; //time to get in before CATO;
waituntil {count crew _veh >= count units _groupE or time > _timer};
if (count units _groupE == 0 or time > _timer) exitWith{
  _veh setDamage 1;
  [_groupE,[8,10],["normal",100]] spawn troops;
};
_group setcurrentwaypoint [_group,1];
deleteWaypoint [_group,2];          //only instance deleted?
hint "load done";