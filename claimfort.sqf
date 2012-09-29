_args = _this select 3;
_fort = _args select 0;

_pos = getposATL _fort;

//set public flag var
call compile format ["flag%1 = 'flags\xds.jpg'",_fort];
publicVariable format ["flag%1",_fort];
_fort setflagtexture (call compile format ["flag%1",_fort]);

_marker = createMarker [format ["mark%1",_fort], _pos];
_marker setMarkerType "Flag";
_marker setMarkerColor "ColorGreen";

[player, nil, rSIDECHAT, format ["%1 not fully working...",_fort]] call RE;