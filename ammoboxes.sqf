
_box = _this select 0;
hint "ammoboxes running";
_amount = 5;
clearWeaponCargo _box; 
clearMagazineCargo _box;

_sidearms = [["makarov","8rnd_9x18_makarov"],
  ["colt1911","7rnd_45acp_1911"],
  ["glock17_ep1","17rnd_9x19_glock17"],
  ["m9","15rnd_9x19_m9"],
  ["m9sd","15rnd_9x19_m9sd"],
  ["revolver_ep1","6Rnd_45ACP"],
  ["revolver_gold_ep1","6Rnd_45ACP"],
  ["Cobalt_File","Pipebomb"]
];

for "_i" from 0 to (count _sidearms - 1) do {
  _box addWeaponCargo [(_sidearms select _i) select 0, _amount];
  _box addMagazineCargo [(_sidearms select _i) select 1, _amount * 10];
};