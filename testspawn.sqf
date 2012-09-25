hint "This is a test.\nAll hell might break loose.";
if (!IsServer) exitwith{
  trigger = createTrigger["EmptyDetector", position player] 
};

//pole vehicle is "FlagPole_EP1"

_pole setflagtexture "flags\skull.jpg";

hint "--Testing spawner--";
  
sleep 3;
//["test","US",[1,10],["normal",50],100,10] spawn spawner;                  //troop spawn
["test","BAF",[1,10],["normal",50 + random 50],20,1] spawn spawner;