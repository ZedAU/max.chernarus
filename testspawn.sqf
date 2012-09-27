hint "This is a test.\nAll hell might break loose.";
if (!IsServer) exitwith{};

_pos = getposATL (_this select 0);

hint "--Testing spawner--";

sleep 3;
//[_pos,"US",[1,10],["normal",50],100,10] spawn spawner;                  //troop spawn
[_pos,"BAF",[1,10],["normal",50 + random 50],20,1] spawn spawner;