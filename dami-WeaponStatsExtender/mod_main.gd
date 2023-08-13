extends Node



const MOD_DIR = "dami-WeaponStatsExtender/"
const LOG_NAME = "dami-WeaponStatsExtender"

var dir = ""
var content_dir = ""
var content_data_dir = ""
var weapons_dir = ""
var ext_dir = ""
var trans_dir = ""

func _init(modLoader = ModLoader):
	ModLoaderLog.info("Init", LOG_NAME)
	dir = ModLoaderMod.get_unpacked_dir() + MOD_DIR
	ext_dir = dir + "extensions/"
	
	ModLoaderMod.install_script_extension(ext_dir + "singletons/weapon_service.gd")
	
	

func _ready():
	ModLoaderMod.install_script_extension(ext_dir + "weapons/weapon_stats/ranged_weapon_stats.gd")
	ModLoaderMod.install_script_extension(ext_dir + "weapons/weapon_stats/melee_weapon_stats.gd")
