/*  Notes
*/                     //hint;
//-------------------------------------------------------------------------------Settings
//sleep 30 + random 30;               //keep down sync issues/serverload on startup?
sleep random 3;                       //desync scripts on startup
_fortlook = 200;                      //Look radius for forts //not yet implemented
//-------------------------------------------------------------------------------
_zone = _this select 0;

_group = grpNull;
_veh = objNull;

_orig = getMarkerPos _zone;
_cx = _orig select 0;
_cy = _orig select 1;
_size = (getMarkerSize _zone) select 0;
//-------------------------------------------------------------------------------spawner/respawner
while {true} do {
  _pos = [_cx - _size + (random (_size * 2)), _cy - _size + (random (_size * 2)),0];
  
  _group = createGroup Civilian;
  _pilot = "Functionary1" createUnit [_pos, _group];
  
  _pilot = units _group select 0;
  _pilot setSkill 1;
  _pilot setVehicleVarName format["%1pilot",_zone];
  _veh = createVehicle ["CH_47F_BAF", _pos, [], 0, "FLY"];
  _veh setVariable ["busy",true];
  call compile format["%1heli = _veh",_zone];                    //this needs to be changed to vehVariableName and used throughout
  _group addvehicle _veh;
  _pilot moveIndriver _veh;
  _veh flyInHeight 80;
  if (rossco_debug) then {[_group,"colorYellow"] execVM "tracker.sqf"};
  [_veh, _zone] spawn loadheli;
  waitUntil {sleep 2; !(_veh getVariable "busy") or !alive _veh or !canMove _veh};
  
  [_pilot,_zone,"NOWAIT","NOSLOW","NAMED","SHOWMARKER"] spawn ups;
  [_group,_zone] spawn banditmonitor;
  
  waitUntil {sleep 10; !alive _pilot or !alive _veh or !canMove _veh};
  //_pilot setVehicleVarName "";
  deleteVehicle _pilot;
};

