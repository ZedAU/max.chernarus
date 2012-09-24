
_box = _this select 0;
_guns = 5;
_mags = 1000;
clearWeaponCargo _box;
clearMagazineCargo _box;

_weapons = ["colt1911","glock17_ep1","Binocular","Pipebomb","EvMoney","ItemMap","ItemGPS"];
_magazines = ["7rnd_45acp_1911","17rnd_9x19_glock17"];

{_box addWeaponCargo [_x, _guns]} foreach _weapons;
{_box addMagazineCargo [_x, _mags]} foreach _magazines;