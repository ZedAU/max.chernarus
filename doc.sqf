
if (!IsServer) exitwith{};

_doc = _this select 0;
hint str _doc;

for "_i" from 1 to 5 do {_doc addmagazine "30rnd_556x45_stanag"};
_doc addweapon "M4a3_rco_gl_ep1";

waituntil {damage _doc > 0};
hint format ["Doc damaged: %1", damage _doc];

if (!alive _doc) then {
  _group = createGroup Civilian;
  "doctor" createUnit [getPosATL _doc, _group];
  _doc = units _group select 0; 
  for "_i" from 0 to 4 do {_doc addmagazine "30rnd_556x45_stanag"};
  _doc addweapon "M4a3_rco_gl_ep1";
};

_group = createGroup west;
_doc allowDamage false;
[_doc] joinsilent _group;
[_group,[9,10],["normal",50],getPosATL _doc] spawn troops;
