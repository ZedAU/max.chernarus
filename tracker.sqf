_group = _this select 0;
_count = 0;
waitUntil {count units _group > 0};
while {count units _group > 0} do {
  {
    _name = format ["%1_%2",_group,_count];
    _mark = createMarker [_name,getposATL _x];
    _mark setMarkerShape "icon";
    _mark setMarkerType "Dot";
    _mark setMarkerColor "ColorWhite";
    _mark setMarkerSize [.5,.5];
    _count = _count + 1;
  } foreach units _group;
  sleep 3;
};

for "_i" from 0 to _count - 1 do {
  deleteMarker format ["%1_%2",_group,_i];
};