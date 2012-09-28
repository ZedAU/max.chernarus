_args = _this select 3;
_fort = _args select 0;

_pos = getposATL _fort;
_trig = call compile format ["trig%1",_fort];

_fort setflagtexture "flags\xds.jpg";

_marker = createMarker [format ["-%1-",_fort], _pos];
_marker setMarkerType "Flag";
_marker setMarkerColor "ColorGreen";

[player, nil, rSIDECHAT, format ["%1 not fully working...",_fort]] call RE;