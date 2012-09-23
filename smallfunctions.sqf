/*  Notes  
  All small functions in one place
  Do I need to "private" any vars?
*/

//-------------------------------------------------------------------------------all clients
playerRespawn = {
  waitUntil {!isNull player};
  _p = player;
  _weapons = [];
  _magazines = [];
  removeAllItems _p;
  removeAllWeapons _p;
  {_p addWeapon _x} forEach ["Binocular","ItemMap","ItemGPS"];
  {_p addMagazine _x} forEach [];
  while {true} do {
    waitUntil {!alive player};
    waitUntil {alive player};
    removeAllItems player;
    removeAllWeapons player;
  };
};

setmhq = {
  _pos = _this select 0;
  _alt = _this select 1;
  if (_alt and _pos distance player < 50) then {
    _vehlist = _pos nearEntities [["landvehicle","tank","air"],10];
    if (count _vehlist > 0) then {
      hint "Setting MHQ..."; //to blah...
      mhq = _vehlist select 0;
      publicVariable "mhq";
      [player, nil, rSIDECHAT, "MHQ reset!"] call RE;
      //player sideChat "MHQ reset!";
    };
  };
};