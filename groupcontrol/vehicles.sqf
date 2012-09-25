/*  Notes
*/
//-------------------------------------------------------------------------------args
_group = _this select 0;
_trav = _this select 1;
_veh = _this select 2;                          //hint (just for search)

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
//{_x assignAsDriver _veh} foreach units _group; //????????????
(units _group) orderGetIn true;

waituntil {count crew _veh >= count units _group or count units _group == 0};
_driver = driver _veh;
//-------------------------------------------------------------------------------main loop
while {count crew _veh > 0} do {
  waituntil {
    _veh distance (getwppos [_group,1]) < _proxy or 
    (damage _veh - _origdamage) > _allowdamage or
    !alive _driver;
  };
  waituntil {currentWaypoint _group < 3};

//-------------------------------------------------------------------------------abort
  if ((damage _veh - _origdamage) > _allowdamage and isnull (gunner _veh) and side _group != Civilian) exitWith{};
  if (!canMove _veh or !alive _driver) exitWith{};
  //would they kick body out???  they do, but it takes a lot of time and the other dudes dont get back in
  
  _area = _mindist + random _dist;
  _oldpos = waypointposition [_group,1];
  [_group,1] setwaypointposition [_oldpos,_area];
  _group setcurrentwaypoint [_group,1];

  _origdamage = damage _veh;
};

//-------------------------------------------------------------------------------cleanup
{unassignVehicle _x} foreach units _group;
_group leaveVehicle _veh;
waituntil {_veh emptypositions "driver" == 1 or !alive driver _veh}; //count crew _veh == 0
hint format ["exiting vehicles script\n%1",typeOf _veh];