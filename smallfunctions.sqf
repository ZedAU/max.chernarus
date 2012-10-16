/*  Notes  
  All small functions in one place
  Do I need to "private" vars?
*/

//-------------------------------------------------------------------------------all clients
playerRespawn = {
  _sidearms = [["makarov","8rnd_9x18_makarov"],
    ["colt1911","7rnd_45acp_1911"],
    ["glock17_ep1","17rnd_9x19_glock17"],
    ["m9","15rnd_9x19_m9"],
    ["m9sd","15rnd_9x19_m9sd"],
    ["revolver_ep1","6Rnd_45ACP"],
    ["revolver_gold_ep1","6Rnd_45ACP"]
  ];
  while {true} do {
    waitUntil {!isNull player};
    {_x setVariable ["BIS_nocoreConversations", true]} forEach playableUnits;
    _pick = floor random count _sidearms;
    _mag = (_sidearms select _pick) select 1;
    _weapon = (_sidearms select _pick) select 0;
    removeAllItems player;
    removeAllWeapons player;
    for "_i" from 1 to (1 + floor random (count _sidearms)) do {player addMagazine _mag};
    {player addWeapon _x} forEach ["Binocular","ItemRadio","ItemMap","ItemCompass",_weapon];
    player selectWeapon _weapon;
    waitUntil {!alive player};
    waitUntil {alive player};
  };
};

setmhq = {
  if (player != vehicle player) then {
    _veh = vehicle player;
    hint format ["Setting MHQ to %1",typeOf _veh];
    mhq = _veh;
    publicVariable "mhq";
    [player, nil, rSIDECHAT, format ["MHQ set to %1",typeOf _veh]] call RE;
  } else {hint "Not in vehicle\nCannot set MHQ"};
};

if (!isServer) exitWith{};
//-----------------------loaded on server only
trigdelay = {
  _trig = _this select 0;
  _statements = triggerStatements _trig;
  _statements set [0,"true"];
  _trig setTriggerStatements _statements;
  
  _isGone = {
    _gone = true;  //if not reset bellow
    _intrig = getposATL _trig nearEntities ["AllVehicles",(triggerArea _trig select 0)];
    for "_i" from 0 to (count playableUnits) - 1 do {
      if (vehicle (playableUnits select _i) in _intrig) exitWith {_gone = false};
    };
    _gone
  };
  
  while {true} do {
    waitUntil {sleep 2; call _isGone}; //checks if out of trig every 2 secs
    sleep 30;
    waitUntil {count playableUnits > 0};
    if (call _isGone) exitWith{_statements = triggerStatements _trig;}; //exit if still out of trig
  };
  
  _statements set [0,"this"];
  _trig setTriggerStatements _statements;
};

findClear = { private ["_pos","_minClear","_tries","_maxGrad","_ignore","_loadpos"];
  _orig = _this select 0;
  _minClear = if (count _this > 1) then {_this select 1} else {20};
  _tries = if (count _this > 2) then {_this select 2} else {5};
  _maxGrad = if (count _this > 3) then {_this select 3} else {20};
  _ignore = if (count _this > 4) then {_this select 4} else {objNull};
  _loadpos = []; _try = 0; _resets = 2; _pos = _orig;// and _resets < _tries //removed from while for testing
  while {count _loadpos < 1} do {
    //isFlatEmpty [float minDistance,float precizePos,float maxGradient,float gradientRadius,float onWater,bool onShore,object skipobj]
    _loadpos = _pos isFlatEmpty [_minClear,1,_maxGrad,10,0,false,_ignore];
    _pos = [
      (_orig select 0) - (25*_resets) + random (50*_resets),
      (_orig select 1) - (25*_resets) + random (50*_resets),
      0
    ]; //set new random pos to test
    _try = _try + 1;
    if (_try == 20) then {_try = 0; _resets = _resets + 1, hint str _resets;};
  };
  _loadpos
};