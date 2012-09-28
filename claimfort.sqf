_args = _this select 3;
_fort = _args select 0;

_trig = call compile format ["trig%1",_fort];
player sideChat format ["%1 not yet working...",_x];