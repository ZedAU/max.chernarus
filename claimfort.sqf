_args = _this select 3;
_fort = _args select 0;

_pos = getposATL _fort;

//set public flag var
call compile format ["flag%1 = 'flags\xds.jpg'",_fort];  //still not working
publicVariable format ["flag%1",_fort];
_fort setflagtexture (call compile format ["flag%1",_fort]);

_marker = createMarker [format ["icon%1",_fort], _pos];
_marker setMarkerType "Flag";
_marker setMarkerColor "ColorGreen";

_trig = call compile format ["trig%1",_fort];
_fact = "BAF";
_skill = [5,10];
_num = 1;

_spawn = format [
  "[%1,'%2',%3,['normal',50],100,%4] execVM 'groupcontrol\upsSpawner.sqf';[thisTrigger] spawn trigdelay",
  _pos, _fact, format ["mark%1",_fort], _num
];
_trig setTriggerStatements ["this", _spawn, ""];

[player, nil, rSIDECHAT, format ["%1 is ours",_fort]] call RE;