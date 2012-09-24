/*  Notes
*/
if (!IsServer) exitwith{};                      //hint;
//-------------------------------------------------------------------------------Settings
//sleep 30 + random 30;               //keep down sync issues/serverload on startup?
sleep random 3;                       //desync scripts on startup
_fortlook = 200;                      //Look radius for forts //not yet implemented
_skillmin = 5;                        //min bandit skill //needed?
_skillmax = 10;                       //max bandit skill //needed?
_dist = 100;                          //max distance possible per itteration //currently mindist + dist
_period = 3;                         //respawn frequency
//-------------------------------------------------------------------------------
_zone = _this select 0;
_heli = _this select 1;
_num = if (count _this > 2) then {_this select 2} else {2};
if (_heli) then {_num = 1};

_centre = getMarkerPos _zone;        //assuming centre
_cx = _centre select 0; _cy = _centre select 1;
_area = getMarkerSize _zone;
_ax = (_area select 0) * 2; _ay = (_area select 1) * 2; //'radius' not width
_zx = _cx - (_ax/2); _zy = _cy - (_ay/2);
_skin = ["Functionary1","Policeman"];     //???
//-------------------------------------------------------------------------------spawner/respawner
while {true} do {
  _group = createGroup Civilian;
  _pos = [_zx + random _ax, _zy + random _ay,0];
  for "_i" from 1 to _num do {
    _bandit = _skin select (floor random count _skin);
    _bandit = _bandit createUnit [_pos, _group];
  };
  if (_heli) then {
    _veh = createVehicle ["CH_47F_BAF", _pos, [], 0, "FLY"];
    call compile format["%1 = _veh", format ["%1heli",_zone]];
    _group addvehicle _veh;
    units _group select 0 moveIndriver _veh;
    sleep 1;
    [_group,[_skillmin,_skillmax],["normal",_dist]] spawn troops;
    sleep 1;
    [_group,["normal",_dist],_veh] spawn vehicles;
    [_group, _veh, _zone] spawn loadheli;
  } else {
    [_group,[_skillmin,_skillmax],["normal",_dist]] spawn troops;
  };
  [_group,_zone] spawn banditmonitor;   //handle in troops? no zone??
  if (_heli) then {
    waitUntil {sleep _period; !canMove _veh or count units _group == 0};
    {unassignVehicle _x} foreach units _group;
    _group leaveVehicle _veh;
  } else {
    waitUntil {sleep _period; count units _group == 0};
  };
}; //what side does a unit return when in a different sided group???

