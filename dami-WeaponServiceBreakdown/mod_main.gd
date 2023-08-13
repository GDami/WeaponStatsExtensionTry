extends Node



const MOD_DIR = "dami-WeaponServiceBreakdown/"
const LOG_NAME = "dami-WeaponServiceBreakdown"

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

