_args = _this select 3;
_fort = _args select 0;

//_fort setflagtexture "flags\xds.jpg"; //local
changeflag = _fort;
publicVariable "changeflag"; //other clients

_pos = getposATL _fort;
_marker = createMarker [format ["icon%1",_fort], _pos];
_marker setMarkerType "Flag";
_marker setMarkerColor "ColorGreen";

_trig = call compile format ["trig%1",_fort];
_statements = triggerStatements _trig;
_fact = "BAF";
_skill = [5,10];
_spRadius = 100;
_num = 1;

_spawn = format [
  "[%1,'%2','%3',%4,%5,%6] spawn upsSpawner;[thisTrigger] spawn trigdelay",
  _pos, _fact, format ["mark%1",_fort], _skill, _spRadius, _num
];
_statements set [1,_spawn];
_trig setTriggerStatements _statements;

[player, nil, rSIDECHAT, format ["%1 is ours",_fort]] call RE;