hint "This is a test.\nAll hell might break loose.";
if (!IsServer) exitwith{};

//pole vehicle is "FlagPole_EP1"

_pole = _this select 0;
_name = typeOf _pole;

_pole setflagtexture "flags\skull.jpg";

hint format ["--Testing--\n
  bandits off\n
  %1\n
  in 3..2..1..",_name];
  
sleep 3;
//["testzone",true] spawn banditspawner;           //bandit spawn