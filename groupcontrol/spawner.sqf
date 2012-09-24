/*  Notes
usage: nul = ["marker name","faction",op([skillmin,skillmax(/10)],["speed",dist],spawn area,number of times)] spawn spawner;
*/

//could this be causing issues?  should handle groups in their own scripts tighter
{if (count units _x == 0) then {deleteGroup _x}} forEach allGroups; //clean up empty groups; 

//-------------------------------------------------------------------------------Settings
_combatmode = "red";

//-------------------------------------------------------------------------------args
_marker = _this select 0;
_faction = _this select 1;

_skill = if (count _this > 2) then {_this select 2} else {[0,4]};//or !isnull (_this select 2)??;
_trav = if (count _this > 3) then {_this select 3} else {["normal",50]};
_area = if (count _this > 4) then {_this select 4} else {50};
_times = if (count _this > 5) then {_this select 5} else {1};

_orig = getmarkerPos _marker;

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
  _rndx = (_orig select 0) + (2 * random _area - 2 * random _area);
  _rndy = (_orig select 1) + (2 * random _area - 2 * random _area);
  _group = [[_rndx,_rndy,0], _side, _spawn] call BIS_fnc_spawnGroup;
  _group setCombatMode _combatmode;

  //-------------------------------------------------------------------------------pass to troops script
  [_group,_skill,_trav] spawn troops;
};

