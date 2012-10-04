/*  Notes
usage: nul = ["marker name","faction",op([skillmin,skillmax(/10)],["speed",dist],spawn area,number of times)] spawn spawner;
*/

//could this be causing issues?  should handle groups in their own scripts tighter
{if (count units _x == 0) then {deleteGroup _x}} forEach allGroups; //clean up empty groups; 

//-------------------------------------------------------------------------------args
_orig = _this select 0;
_faction = _this select 1;
_patrol = _this select 2;

_skill = if (count _this > 3) then {_this select 3} else {[0,10]};
_spRadius = if (count _this > 4) then {_this select 4} else {50};
_times = if (count _this > 5) then {_this select 5} else {1};

while {_times > 0} do {
  _times = _times - 1;
  sleep (random 3);

  //-------------------------------------------------------------------------------sides and faction
  _list = call compile format["%1list",_faction];
  _pick = _list select (floor random (count _list));
  _side = if (_pick select 0 == "Guerrila") then {Resistance} else {
    call compile format ["%1",_pick select 0];
  };

  //-------------------------------------------------------------------------------spawn group
  _spawn = (configFile >> "CfgGroups" >> _pick select 0 >> _pick select 1 >> "Infantry" >> _pick select 2);
  _rand = ((2 * random _spRadius) - (2 * random _spRadius));
  _rndx = (_orig select 0) + _rand;
  _rndy = (_orig select 1) + _rand;
  _group = [[_rndx,_rndy,0], _side, _spawn] call BIS_fnc_spawnGroup;

//-------------------------------------------------------------------------------set skill
  _skmin = _skill select 0;
  _diff = (_skill select 1) - _skmin;
  _skrand = compile format ["(random %1 + %2)/10",_diff,_skmin];
  {_x setskill ["aimingAccuracy",(call _skrand *.5)];
    _x setskill ["spotDistance",(call _skrand *.6)];
    _x setskill ["spotTime",(call _skrand *1)];
    _x setskill ["courage",(call _skrand *.1)]; 
    _x setskill ["commanding",(call _skrand *.1)]; 
    _x setskill ["aimingShake",(call _skrand *.5)];
    _x setskill ["aimingSpeed",(call _skrand *.9)];
  } foreach units _group ;
  
  //-------------------------------------------------------------------------------pass to troops script
  [leader _group,_patrol,"track"] spawn ups;
  if (rossco_debug) then {[_group] execVM "tracker.sqf"};
  if (side _group != Civilian) then {[_group] spawn rangemonitor};
};

