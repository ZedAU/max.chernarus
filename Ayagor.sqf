//Ayagor.sqf

_chopper = _this select 0;

waitUntil {sleep 2; (getposATL _chopper select 2) > 10};

[player, nil, rGLOBALCHAT, "I took Ayagor's chopper!"] call RE;
sleep 3;
_chopper setdamage 1;