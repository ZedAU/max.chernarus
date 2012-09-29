

if (!IsServer) exitwith{};
_pole = _this select 0;
_polepos = getposATL _pole;

_rand = [
  "flags\xds.jpg",
  "flags\australia.jpg",
  "flags\skull.jpg",
  "\ca\ca_e\data\flag_tka_co.paa",
  "\ca\data\Flag_chdkz_co.paa",
  "\ca\data\Flag_rus_co.paa",
  "\ca\data\Flag_usa_co.paa"
  ] select floor random 7;
  
_pole setflagtexture _rand;

/*
_flags = [
  "\ca\data\Flag_usmc_co.paa",
  "\ca\data\Flag_rus_co.paa",
  "\ca\data\Flag_usa_co.paa",
  "\ca\data\Flag_napa_co.paa",
  "\ca\data\Flag_chdkz_co.paa",
  "\ca\data\Flag_chernarus_co.paa",
  
  "\ca\ca_e\data\flag_bis_co.paa" ,
  "\ca\ca_e\data\flag_blufor_co.paa" ,
  "\ca\ca_e\data\flag_cdf_co.paa" ,
  "\ca\ca_e\data\flag_cr_co.paa" ,
  "\ca\ca_e\data\flag_cz_co.paa" ,
  "\ca\ca_e\data\flag_ger_co.paa" ,
  "\ca\ca_e\data\flag_indfor_co.paa" ,
  "\ca\ca_e\data\flag_knight_co.paa" ,
  "\ca\ca_e\data\flag_nato_co.paa" ,
  "\ca\ca_e\data\flag_opfor_co.paa" ,
  "\ca\ca_e\data\flag_pow_co.paa" ,
  "\ca\ca_e\data\flag_rcrescent_co.paa" ,
  "\ca\ca_e\data\flag_rcross_co.paa" ,
  "\ca\ca_e\data\flag_rcrystal_co.paa" ,
  "\ca\ca_e\data\flag_tka_co.paa" ,
  "\ca\ca_e\data\flag_tkg_co.paa" ,
  "\ca\ca_e\data\flag_tkm_co.paa" ,
  "\ca\ca_e\data\flag_uno_co.paa" ,
  "\ca\ca_e\data\flag_usarmy_co.paa" ,
  "\ca\ca_e\data\flag_us_co.paa" ,
  "\ca\ca_e\data\flag_white_co.paa"
];
{
  sleep 3;
  _pole setflagtexture _x;
  hint _x;
} foreach _flags;
*/

