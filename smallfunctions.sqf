/*  Notes  
  All small functions in one place
  Do I need to "private" any vars?
*/

//-------------------------------------------------------------------------------all clients
playerRespawn = {
  waitUntil {!isNull player};
  while {true} do {
    _sidearms = [["makarov","8rnd_9x18_makarov"],
      ["colt1911","7rnd_45acp_1911"],
      ["glock17_ep1","17rnd_9x19_glock17"],
      ["m9","15rnd_9x19_m9"],
      ["m9sd","15rnd_9x19_m9sd"],
      ["revolver_ep1","6Rnd_45ACP"],
      ["revolver_gold_ep1","6Rnd_45ACP"]
    ];
    _pick = floor random count _sidearms;
    _mag = (_sidearms select _pick) select 1;
    _weapon = (_sidearms select _pick) select 0;
    removeAllItems player;
    removeAllWeapons player;
    for "_i" from 1 to (1 + floor random 7) do {player addMagazine _mag};
    {player addWeapon _x} forEach [_weapon,"ItemMap","ItemCompass","ItemRadio","Binocular"];
    
    waitUntil {!alive player};
    waitUntil {alive player};
  };
};

setmhq = {
  _pos = _this select 0;
  _alt = _this select 1;
  if (_alt and _pos distance player < 50) then {
    _vehlist = _pos nearEntities [["landvehicle","tank","air"],20];
    if (count _vehlist > 0) then {
      _veh = _vehlist select 0;
      hint format ["Setting MHQ to %1",typeOf _veh]; //to blah...
      mhq = _veh;
      publicVariable "mhq";
      player sideChat "MHQ reset!";
    };
  };
};