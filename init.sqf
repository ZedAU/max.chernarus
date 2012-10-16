//---------Master Settings---------//
rossco_debug = true;              //teleport, tracker dots, visible markers and lots of hint stuff
_districts = ["NW","NE","SW","SE"]; //edit this to reflect district markers in editor... not ideal
                                   //need place in editor to pull list from user?
//---------------------------------//

showRadio true;                    //still not working, this command is default true and not the map radio anyway
0 fadeRadio .05;                   //stops ai yelling eveything

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
//-------------------------server only

districts = _districts;
range = 1000; //global trigger and despawn range
zonedrops = 0;

zones = [
  "NWzone","NEzone",
  "SWzone","SEzone"
]; //do not change these

//global functions
execVM "groupcontrol\groupslist.sqf";
_handler = execVM "3rdparty\UPS_INIT.sqf";
waitUntil {scriptDone _handler};

_handler = execVM "fort_init.sqf";
waitUntil {scriptDone _handler};

//precompiling
{call compile format ["%1 = compile preprocessFileLineNumbers 'groupcontrol\%1.sqf'",_x]}
  foreach ["upsSpawner","rangemonitor"];
  
{call compile format ["%1 = compile preprocessFileLineNumbers 'banditcontrol\%1.sqf'",_x]}
  foreach ["banditspawner","banditmonitor","loadheli","callheli"];
  
ups = compile preprocessFileLineNumbers "3rdparty\ups.sqf";
  
//get bandits going
{[_x] spawn banditspawner} foreach zones; //heli bandits

//mhq marker
if (isNil "mhq") then {mhq = mhq1};  //needs to be automated? or just set to "home"?
//MHQ tracker  -  init never finishes because of this, nobueno?
while {true} do {
  if (alive mhq) then {
    "respawn_guerrila" setmarkerpos (getPosATL mhq);
  } else {
    "respawn_guerrila" setmarkerpos (getmarkerpos "home");
  };
sleep 1;
};