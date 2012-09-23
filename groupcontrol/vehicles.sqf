/*  Notes
*/
//-------------------------------------------------------------------------------args
_group = _this select 0;
_trav = _this select 1;
_oldpos = _this select 2;
_veh = _this select 3;                          //hint (just for search)

//-------------------------------------------------------------------------------settings
_speed = "full";
_allowdamage = 0.001;

_dist = 6*(_trav select 1);
_mindist =_dist * .25;
_proxy = _dist * .75;   //could have formula to disalow new < proxy?

//-------------------------------------------------------------------------------settings  Air
if (_veh isKindOf "Air") then {
  _veh flyInHeight 75;
  _dist = 8*(_trav select 1);
  _mindist =_dist * .25;
  _proxy = _dist * 1.25;
};
_origdamage = damage _veh;

//-------------------------------------------------------------------------------get in
[_group,1] setwaypointposition [getPosATL _veh,0];
[_group,1] setwaypointSpeed _speed;
_group addVehicle _veh;
{_x assignAsDriver _veh} foreach units _group;
(units _group) orderGetIn true;

waituntil {count crew _veh >= count units _group or count units _group == 0};
//-------------------------------------------------------------------------------main loop
while {count crew _veh > 0} do {
  waituntil {(currentWaypoint _group < 2 and (_veh distance (getwppos [_group,1]) < _proxy or
  (damage _veh - _origdamage) > _allowdamage)) or 
  !alive driver _veh};
  
  _area = _mindist + random _dist;
  _oldpos = waypointposition [_group,1];
  [_group,1] setwaypointposition [_oldpos,_area];
  [_group,1] setWaypointType "move";                    //already "move" in troops
  _group setcurrentwaypoint [_group,1];

  if ((damage _veh - _origdamage) > _allowdamage and isnull (gunner _veh) and side _group != Civilian) exitWith{};
  if (!(canMove _veh) or !alive driver _veh) exitWith{};
  
  _origdamage = damage _veh;
};
{unassignVehicle _x} foreach units _group;
_group leaveVehicle _veh;
hint format ["waiting to exit\n%1",typeOf _veh];
waituntil {_veh emptypositions "driver" == 1 or !alive driver _veh};
hint format ["exiting vehicles script\n%1",typeOf _veh];