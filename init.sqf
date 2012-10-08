/*  Notes
*/
rossco_debug = false;

showRadio true;
0 fadeRadio .05;

_handler = execVM "smallfunctions.sqf";
waitUntil {scriptDone _handler};
[] spawn playerRespawn;

//3rd party scripts
execVM "3rdparty\DynamicWeatherEffects.sqf";

//event handlers
if (rossco_debug) then {
  onMapSingleClick "if (!(_alt or _shift)) then {player setpos _pos; true} else {if (_alt) then {call setmhq; true} else {false}}";
} else {
  onMapSingleClick "if (_alt) then {call setmhq; true} else {false}";
};

if (!IsServer) exitwith{};
//-------------------------------------------------------------------------------server only

range = 1000; //trigger and despawn range

_handler = execVM "fort_init.sqf";
waitUntil {scriptDone _handler};

execVM "groupcontrol\groupslist.sqf";

//-------------------------------------------------------------------------------precompiling
{call compile format ["%1 = compile preprocessFileLineNumbers 'groupcontrol\%1.sqf'",_x]}
  foreach ["upsSpawner","rangemonitor"];
  
{call compile format ["%1 = compile preprocessFileLineNumbers 'banditcontrol\%1.sqf'",_x]}
  foreach ["banditspawner","banditmonitor","loadheli","callheli"];
  
ups = compile preprocessFileLineNumbers "3rdparty\ups.sqf";
  
//-------------------------------------------------------------------------------get bandits going
_zones = ["SWzone","SEzone","NEzone","NWzone"];
{[_x,true] spawn banditspawner} foreach _zones; //heli bandits
{[_x,false] spawn banditspawner} foreach _zones; //foot bandits

//-------------------------------------------------------------------------------mhq marker

if (isNil "mhq") then {mhq = mhq1};  //(needs to be autoed)
while {true} do {
  if (alive mhq) then {
    "respawn_guerrila" setmarkerpos (getPosATL mhq);
  } else {
    "respawn_guerrila" setmarkerpos (getmarkerpos "home");
  };
sleep 1;
};