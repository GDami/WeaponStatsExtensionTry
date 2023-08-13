extends "res://singletons/weapon_service.gd"


var MeleeWeaponStats
var RangedWeaponStats

func _ready():
	MeleeWeaponStats = load("res://weapons/weapon_stats/melee_weapon_stats.gd")
	RangedWeaponStats = load("res://weapons/weapon_stats/ranged_weapon_stats.gd")
	
	
func init_new_stats(new_stats, from_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->WeaponStats:
	if "attack_type" in from_stats:
		return MeleeWeaponStats.new()
	else :
		return RangedWeaponStats.new()
