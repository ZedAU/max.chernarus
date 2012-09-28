/*  Notes
*/

showRadio true;
0 fadeRadio .05;

_handler = execVM "smallfunctions.sqf";
waitUntil {scriptDone _handler};
[] spawn playerRespawn;

onMapSingleClick "[_alt] call setmhq; if (_alt) then {true} else {false}";

//3rd party scripts
execVM "3rdparty\DynamicWeatherEffects.sqf";

if (!IsServer) exitwith{};
//-------------------------------------------------------------------------------server only
_handler = execVM "fortsys.sqf";
waitUntil {scriptDone _handler};
//hint "fortsys off!!!";

execVM "groupcontrol\groupslist.sqf";

//-------------------------------------------------------------------------------precompiling
{call compile format ["%1 = compile preprocessFileLineNumbers 'groupcontrol\%1.sqf'",_x]}
  foreach ["spawner","rangemonitor","troops","vehicles"];
  
{call compile format ["%1 = compile preprocessFileLineNumbers 'banditcontrol\%1.sqf'",_x]}
  foreach ["banditspawner","banditmonitor","loadheli","callheli"];
  
//-------------------------------------------------------------------------------get bandits going
_zones = ["SWzone","SEzone","NEzone","NWzone"];
{[_x,true] spawn banditspawner} foreach _zones; //heli bandits
{[_x,false] spawn banditspawner} foreach _zones; //foot bandits

//-------------------------------------------------------------------------------mhq marker

if (isNil "mhq") then {mhq = mhq1};
while {true} do {
  if (alive mhq) then {
    "respawn_guerrila" setmarkerpos (getPosATL mhq);
  } else {
    "respawn_guerrila" setmarkerpos (getmarkerpos "home");
  };
sleep 1;
};