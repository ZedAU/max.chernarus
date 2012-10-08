
if (!IsServer) exitwith{};

_doc = _this select 0;

for "_i" from 1 to 5 do {_doc addmagazine "30rnd_556x45_stanag"};
_doc addweapon "M4a3_rco_gl_ep1";

waitUntil {damage _doc > 0};

_doc setSkill 1;
//[_doc, nil, rGLOBALCHAT, "Blah!"] call RE;

_mark = createMarkerLocal ["doc",getposATL _doc];
_mark setMarkerSize [100,100];

_group = createGroup west;
[_doc] joinsilent _group;
[_doc,"doc"] spawn ups;