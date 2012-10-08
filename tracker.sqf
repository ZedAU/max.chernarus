_group = _this select 0;
_col = if (count _this > 1) then {_this select 1} else {"ColorWhite"};
_count = 0;
waitUntil {count units _group > 0};
while {count units _group > 0} do {
  {
    _name = format ["%1_%2",_group,_count];
    _mark = createMarker [_name,getposATL _x];
    _mark setMarkerShape "icon";
    _mark setMarkerType "Dot";
    _mark setMarkerColor _col;
    _mark setMarkerSize [.5,.5];
    _count = _count + 1;
  } foreach units _group;
  _speed = speed (units _group select 0);
  _markerdist = 5;
  if (_speed < 1) then {sleep 1} else {sleep (1 / (_speed * .28) * _markerdist)};
};

for "_i" from 0 to _count - 1 do {
  deleteMarker format ["%1_%2",_group,_i];
};