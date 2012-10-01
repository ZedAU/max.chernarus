

if (!IsServer) exitwith{};


  _trig = _this select 0;
  _statements = triggerStatements _trig;
  _statements set [0,"true"];
  _trig setTriggerStatements _statements;
  
  _isGone = {
    _gone = true;  //if not reset bellow
    _intrig = getposATL _trig nearEntities [["man"],triggerArea _trig select 0];
    for "_i" from 0 to (count playableUnits) - 1 do {
      if ((playableUnits select _i) in _intrig) exitWith{_gone = false};
    };
    _gone
  };
  
  while {true} do {
    sleep 1;  //remove
    hint "triggered delay";
    waitUntil {sleep 2; call _isGone}; //checks if out of trig every 2 secs
    hint "out of trigger";
    sleep 5; //change this to 30
    hint "rechecking";
    if (call _isGone) exitWith{}; //checks if still out of trig
  };
  hint "reactivating";
  _statements set [0,"this"];
  _trig setTriggerStatements _statements;
  