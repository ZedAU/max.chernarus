/*  Notes
*/                                                  //hint (just for search)
if (!IsServer) exitwith{};
//-------------------------------------------------------------------------------args
_group = _this select 0;
_skill = _this select 1;
_trav = _this select 2;

_speed = _trav select 0;
_dist = _trav select 1;
//-------------------------------------------------------------------------------settings
_mindist =_dist * .25;                  //min distance percentage;
_proxy = 20;                            //has issues if travel < 20;
_vehlook = 50;                          //greater look radius lower iterations?
_vehits = 2;                            //wait itterations before look again
//-------------------------------------------------------------------------------set skill
_skmin = _skill select 0;
_diff = (_skill select 1) - _skmin;
_skrand = compile format ["(random %1 + %2)/10",_diff,_skmin];
{_x setskill ["aimingAccuracy",(call _skrand *.5)];
  _x setskill ["spotDistance",(call _skrand *.6)];
  _x setskill ["spotTime",(call _skrand *1)];
  _x setskill ["courage",(call _skrand *.1)]; 
  _x setskill ["commanding",(call _skrand *.1)]; 
  _x setskill ["aimingShake",(call _skrand *.5)];
  _x setskill ["aimingSpeed",(call _skrand *.9)];
} foreach units _group ;

if (side _group != Civilian) then {[_group] spawn rangemonitor};
// else {[_group,_zone] spawn banditmonitor;}; ??
//-------------------------------------------------------------------------------get patrolling
_group addWaypoint [getPosATL (units _group select 0),0];       //chance of multi waypoints? stays with group for life...
[_group,1] setWaypointType "move";
//-------------------------------------------------------------------------------loop
_drive = 1;
//needs group cleanup?
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
  [_group,1] setWaypointSpeed _speed;
  _group setcurrentwaypoint [_group,1];
  
//-------------------------------------------------------------------------------look for vehicles
  _drive = _drive - 1; // does =- work in amra2?
  if (_drive == 0) then {
    _drive = _vehits;
    _vehlist = _oldpos nearEntities [["landvehicle","tank","air"],_vehlook];
//-------------------------------------------------------------------------------trim unusable
    _vehok = [];
    {if (canMove _x and (count units _x) == 0) then {_vehok = _vehok + [_x]}} foreach _vehlist;
    
    if (count _vehok > 0)  then {
      _veh = _vehok select (floor random count _vehok);

      _seats  = 0;
      _positions = ["Driver","Cargo"];                    //,"Commander",  "Gunner" if just cargo simplify;
      {_seats = _seats + (_veh emptypositions _x)} foreach _positions;
      
//-------------------------------------------------------------------------------leftover troops
      _tovers = count units _group - _seats;
      if (_tovers > 0) then {
        _count = count units _group;
        _group1 = createGroup (side _group);
        for "_i" from _count to (_count - _tovers) step -1 do {[units _group select _i] joinSilent _group1};
        [_group1,_skill,_trav] spawn troops;
        if (side _group == Civilian) then {[_group1,"NWzone"] spawn banditmonitor}; //temp zone
      };
      [_group,_trav,_veh] spawn vehicles;
      waituntil {count crew _veh >= count units _group or count units _group == 0};
    };
  };
};