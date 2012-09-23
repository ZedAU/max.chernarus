/*  Notes
*/                                                  //hint (just for search)
//-------------------------------------------------------------------------------args
_group = _this select 0;
_skill = _this select 1;
_trav = _this select 2;
_orig = _this select 3;

_speed = _trav select 0;
_dist = _trav select 1;
//-------------------------------------------------------------------------------settings
_mindist =_dist * .25;                  //min distance percentage;
_proxy = 20;                            //has issues if travel < 20;
_vehlook = 50;                          //greater look radius lower iterations?
_vehits = 2;                            //wait itterations before look again
//-------------------------------------------------------------------------------set skill
_skillmin = _skill select 0;
_skilldiff = (_skill select 1) - _skillmin;
{_x setskill ["aimingAccuracy",((((random _skilldiff)+_skillmin)*.7)/10)];
  _x setskill ["spotDistance",((((random _skilldiff)+_skillmin)*.8)/10)];
  _x setskill ["spotTime",((((random _skilldiff)+_skillmin)*1)/10)];
  _x setskill ["courage",((((random _skilldiff)+_skillmin)*.1)/10)]; 
  _x setskill ["commanding",((((random _skilldiff)+_skillmin)*.1)/10)]; 
  _x setskill ["aimingShake",((((random _skilldiff)+_skillmin)*1)/10)];
  _x setskill ["aimingSpeed",((((random _skilldiff)+_skillmin)*.9)/10)];
} foreach units _group ;

if (side _group != Civilian) then {[_group] spawn rangemonitor};
// else {[_group,_zone] spawn banditmonitor;}; ??
//-------------------------------------------------------------------------------get patrolling
_group addWaypoint [_orig,0];       //chance of multi waypoints? hangs with group for life...
[_group,1] setWaypointType "move";
[_group,1] setWaypointSpeed _speed;
//-------------------------------------------------------------------------------loop
_drive = 1;
while {count units _group > 0} do {
  waituntil {
    (((getPosATL (units _group select 0)) distance (getwppos [_group,1])) < _proxy AND
    units _group select 0 == vehicle (units _group select 0)) OR
    count units _group == 0;                  //goal proxy and not in vehicle or all dead
  };
  if (count units _group == 0) exitWith{};   //and delete group?
  _area = _mindist + random _dist;
  _oldpos = waypointposition [_group,1];

  [_group,1] setwaypointposition [_oldpos,_area];
  [_group,1] setWaypointType "move";
  _group setcurrentwaypoint [_group,1];
//-------------------------------------------------------------------------------look for vehicles
  _drive = _drive - 1;
  if (_drive == 0) then {
    _drive = _vehits;
    _vehlist = _oldpos nearEntities [["landvehicle","tank","air"],_vehlook];
//-------------------------------------------------------------------------------trim any imobile
    _vehok = [];
    for "_i" from 0 to (count _vehlist - 1) do {
      if (canMove (_vehlist select _i) and (count units (_vehlist select _i)) == 0) then {
        _vehok = _vehok + [_vehlist select _i];
      };
    };
    if (count _vehok > 0)  then {
      _veh = _vehok select (floor random count _vehok);
      _drivefrom = getPosATL _veh;

      _seats  = 0;
      _positions = ["Driver","Gunner"];                    //,"Cargo""Commander",   some hang on getin?;
      {_seats = _seats + (_veh emptypositions _x)} foreach _positions;
      
      _tovers = count units _group - _seats;
      if (_tovers > 0) then {
        _group1 = createGroup (side _group);
        for "_i" from 1 to _tovers do {[units _group select 0] joinSilent _group1};
        [_group1,_skill,_trav,_drivefrom] spawn troops;
        if (side _group == Civilian) then {[_group1,"NWzone"] spawn banditmonitor}; //temp zone
      };
      [_group,_trav,_drivefrom,_veh] spawn vehicles;
      waituntil {count crew _veh >= count units _group or count units _group == 0};
    };
  };
};