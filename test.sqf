hint "This is a test.\nAll hell might break loose.";
if (!IsServer) exitwith{
  trigger = createTrigger["EmptyDetector", position player] 
};

//pole vehicle is "FlagPole_EP1"

_pole = _this select 0;
_name = typeOf _pole;

_pole setflagtexture "skull.jpg";

hint format ["--Testing--\n
  spawner\n
  %1\n
  in 3..2..1..",_name];
  
sleep 3;
["test","US",[1,10],["normal",50],100,10] spawn spawner;                  //troop spawn
["test","BAF",[1,10],["normal",50 + random 50],100,10] spawn spawner;