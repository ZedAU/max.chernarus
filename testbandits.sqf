hint "This is a test.\nAll hell might break loose.";
if (!IsServer) exitwith{};

_pole = _this select 0;
_name = typeOf _pole;

hint "--Testing Bandits--";
  
sleep 3;
["testzone",true] spawn banditspawner;
//sleep 40;
//hint "spawning foot bandits";
//["testzone",false] spawn banditspawner;