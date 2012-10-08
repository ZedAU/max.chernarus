/*  Notes
*/                     //hint;
//-------------------------------------------------------------------------------Settings
//sleep 30 + random 30;               //keep down sync issues/serverload on startup?
sleep random 3;                       //desync scripts on startup
_fortlook = 200;                      //Look radius for forts //not yet implemented
_dist = 100;                          //max distance possible per itteration //currently mindist + dist
//-------------------------------------------------------------------------------
_zone = _this select 0;
_heli = _this select 1;
_num = if (count _this > 2) then {_this select 2} else {2};
if (_heli) then {_num = 1};
_group = grpNull;
_veh = objNull;

_centre = getMarkerPos _zone;
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
    units _group select 0 setVehicleVarName format["%1pilot",_zone];
    _veh = createVehicle ["CH_47F_BAF", _pos, [], 0, "FLY"];
    _veh setVariable ["ready",false];
    call compile format["%1heli = _veh",_zone];
    _group addvehicle _veh;
    units _group select 0 moveIndriver _veh;
    _veh flyInHeight 80;
    if (rossco_debug) then {[_group,"colorYellow"] execVM "tracker.sqf"};
    _handler = [_veh, _zone] spawn loadheli;
    waitUntil {scriptDone _handler};
    [units _group select 0,_zone,"NOWAIT","NOSLOW","NAMED","SHOWMARKER"] spawn ups;
  } else {[units _group select 0,_zone,"SHOWMARKER"] spawn ups;
    if (rossco_debug) then {[_group,"colorYellow"] execVM "tracker.sqf"};
  };
  
  [_group,_zone] spawn banditmonitor;
  
  if (_heli) then {
    waitUntil {sleep 10; !alive _veh or !canMove _veh or count units _group == 0};
    if (count units _group > 0) then {
      {unassignVehicle _x} foreach units _group;
      _group leaveVehicle _veh;
    };
  } else {
    waitUntil {sleep 20; count units _group == 0};
  };
};

