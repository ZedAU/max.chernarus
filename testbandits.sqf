hint "This is a test.\nAll hell might break loose.";
if (!IsServer) exitwith{};

//pole vehicle is "FlagPole_EP1"

_pole = _this select 0;
_name = typeOf _pole;

_pole setflagtexture "flags\skull.jpg";

hint "--Testing Bandits--";
  
sleep 3;
["testzone",true] spawn banditspawner;
//sleep 40;
//hint "spawning foot bandits";
//["testzone",false] spawn banditspawner;