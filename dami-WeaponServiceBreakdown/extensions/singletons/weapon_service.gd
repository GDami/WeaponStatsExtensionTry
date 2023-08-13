extends "res://singletons/weapon_service.gd"


func init_melee_stats(from_stats = MeleeWeaponStats.new(), weapon_id:String = "", sets:Array = [], effects:Array = [], is_structure:bool = false)->MeleeWeaponStats:
	var new_stats = init_base_stats(from_stats, weapon_id, sets, effects, is_structure) as MeleeWeaponStats

	set_alternate_attack_type(new_stats, from_stats, weapon_id, sets, effects, is_structure)
	set_melee_max_range(new_stats, from_stats, weapon_id, sets, effects, is_structure)

	return new_stats


func init_ranged_stats(from_stats:RangedWeaponStats = RangedWeaponStats.new(), weapon_id:String = "", sets:Array = [], effects:Array = [], is_structure:bool = false)->RangedWeaponStats:
	var new_stats = init_base_stats(from_stats, weapon_id, sets, effects, is_structure) as RangedWeaponStats
	
	set_ranged_max_range(new_stats, from_stats, weapon_id, sets, effects, is_structure)
	set_projectile_spread(new_stats, from_stats, weapon_id, sets, effects, is_structure)
	set_nb_projectiles(new_stats, from_stats, weapon_id, sets, effects, is_structure)
	set_pierce_and_bounce(new_stats, from_stats, weapon_id, sets, effects, is_structure)
	set_projectile_scene(new_stats, from_stats, weapon_id, sets, effects, is_structure)
	set_projectile_speed(new_stats, from_stats, weapon_id, sets, effects, is_structure)

	
	return new_stats


func init_base_stats(from_stats:WeaponStats, weapon_id:String = "", sets:Array = [], effects:Array = [], is_structure:bool = false)->WeaponStats:
	
	var base_stats = from_stats.duplicate()
	var new_stats:WeaponStats
	var is_exploding = false
	
	
	new_stats = init_new_stats(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_weapon_bonus(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_class_bonus(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_effects(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	is_exploding = set_exploding(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_scaling_stats(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_attack_speed(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_burning_data(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_min_range(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_effect_scale(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_attack_speed_mod(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_max_range(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_damage(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	var percent_dmg_bonus = set_percent_damage(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	var exploding_dmg_bonus = set_exploding_dmg_bonus(new_stats, base_stats, weapon_id, sets, effects, is_structure, is_exploding)
	apply_percent_damage(new_stats, base_stats, weapon_id, sets, effects, is_structure, percent_dmg_bonus, exploding_dmg_bonus)
	set_crit_damage(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_crit_chance(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_accuracy(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_healing(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_lifesteal(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_knockback(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_sound(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	set_additional_cooldown(new_stats, base_stats, weapon_id, sets, effects, is_structure)
	
	return new_stats



### MELEE ###

func set_alternate_attack_type(new_stats, from_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.alternate_attack_type = from_stats.alternate_attack_type

func set_melee_max_range(new_stats, from_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	if not is_structure:
		new_stats.max_range = max(MIN_RANGE, new_stats.max_range + (Utils.get_stat("stat_range") / 2.0)) as int



### RANGED ###

func set_ranged_max_range(new_stats, from_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	if not is_structure:
		new_stats.max_range = max(MIN_RANGE, new_stats.max_range + Utils.get_stat("stat_range")) as int

func set_projectile_spread(new_stats, from_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.projectile_spread = from_stats.projectile_spread + (RunData.effects["projectiles"] * 0.1)

func set_nb_projectiles(new_stats, from_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	if from_stats.nb_projectiles > 0:
		new_stats.nb_projectiles = from_stats.nb_projectiles + RunData.effects["projectiles"]

func set_pierce_and_bounce(new_stats, from_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	var piercing_dmg_bonus = (Utils.get_stat("piercing_damage") / 100.0)
	var bounce_dmg_bonus = (Utils.get_stat("bounce_damage") / 100.0)
	
	new_stats.piercing = from_stats.piercing + RunData.effects["piercing"]
	new_stats.piercing_dmg_reduction = clamp(from_stats.piercing_dmg_reduction - piercing_dmg_bonus, 0, 1)
	new_stats.bounce = from_stats.bounce + RunData.effects["bounce"]
	new_stats.bounce_dmg_reduction = clamp(from_stats.bounce_dmg_reduction - bounce_dmg_bonus, 0, 1)

func set_projectile_scene(new_stats, from_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.projectile_scene = from_stats.projectile_scene

func set_projectile_speed(new_stats, from_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	if from_stats.increase_projectile_speed_with_range:
		new_stats.projectile_speed = clamp(from_stats.projectile_speed + (from_stats.projectile_speed / 300.0) * Utils.get_stat("stat_range"), 50, 6000) as int
	else :
		new_stats.projectile_speed = from_stats.projectile_speed



### BASE ###

func init_new_stats(new_stats, from_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->WeaponStats:
	if from_stats is MeleeWeaponStats:
		return MeleeWeaponStats.new()
	else :
		return RangedWeaponStats.new()

func set_weapon_bonus(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	for weapon_bonus in RunData.effects["weapon_bonus"]:
		if weapon_id == weapon_bonus[0]:
			base_stats.set(weapon_bonus[1], base_stats.get(weapon_bonus[1]) + weapon_bonus[2])

func set_class_bonus(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	for class_bonus in RunData.effects["weapon_class_bonus"]:
		for set in sets:
			if set.my_id == class_bonus[0]:
				var value = base_stats.get(class_bonus[1]) + class_bonus[2]
				
				if class_bonus[1] == "lifesteal":
					value = base_stats.get(class_bonus[1]) + (class_bonus[2] / 100.0)
				base_stats.set(class_bonus[1], value)

func set_effects(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	for effect in effects:
		if effect is BurningEffect:
			base_stats.burning_data = BurningData.new(effect.burning_data.chance, effect.burning_data.damage, effect.burning_data.duration, 0)
		elif effect is WeaponStackEffect:
			var nb_same_weapon = 0
			
			for checked_weapon in RunData.weapons:
				if checked_weapon.weapon_id == effect.weapon_stacked_id:
					nb_same_weapon += 1
			
			base_stats.set(effect.stat_name, base_stats.get(effect.stat_name) + (effect.value * max(0.0, nb_same_weapon - 1)))

func set_exploding(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->bool:
	for effect in effects:
		if effect is ExplodingEffect:
			return true
	return false

func set_scaling_stats(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.scaling_stats = base_stats.scaling_stats

func set_attack_speed(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	var atk_spd = (Utils.get_stat("stat_attack_speed") + base_stats.attack_speed_mod) / 100.0
	
	if is_structure:
		atk_spd = 0
	
	if atk_spd > 0:
		new_stats.cooldown = max(2, base_stats.cooldown * (1 / (1 + atk_spd))) as int
		new_stats.recoil = base_stats.recoil / (1 + atk_spd)
		new_stats.recoil_duration = base_stats.recoil_duration / (1 + atk_spd)
	else :
		new_stats.cooldown = max(2, base_stats.cooldown * (1 + abs(atk_spd))) as int
		new_stats.recoil = base_stats.recoil
		new_stats.recoil_duration = base_stats.recoil_duration

func set_burning_data(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.burning_data = init_burning_data(base_stats.burning_data, false, is_structure)

func set_min_range(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.min_range = base_stats.min_range if not RunData.effects["no_min_range"] else 0

func set_effect_scale(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.effect_scale = base_stats.effect_scale

func set_attack_speed_mod(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.attack_speed_mod = base_stats.attack_speed_mod

func set_max_range(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.max_range = base_stats.max_range
	
	if is_structure:
		new_stats.max_range = base_stats.max_range

func set_damage(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.damage = base_stats.damage
	new_stats.damage = max(1.0, new_stats.damage + get_scaling_stats_value(base_stats.scaling_stats)) as int

func set_percent_damage(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->float:
	if is_structure:
		return 1.0
	return (1 + (Utils.get_stat("stat_percent_damage") / 100.0))

func set_exploding_dmg_bonus(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false, is_exploding = false)->float:
	if is_exploding:
		return (Utils.get_stat("explosion_damage") / 100.0)
	return 0.0

func apply_percent_damage(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false, percent_dmg_bonus = 0.0, exploding_dmg_bonus = 0.0)->void:
	new_stats.damage = max(1, round(new_stats.damage * (percent_dmg_bonus + exploding_dmg_bonus))) as int

func set_crit_damage(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.crit_damage = base_stats.crit_damage

func set_crit_chance(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.crit_chance = base_stats.crit_chance + (Utils.get_stat("stat_crit_chance") / 100.0)
	
	if is_structure:
		new_stats.crit_chance = base_stats.crit_chance

func set_accuracy(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.accuracy = (base_stats.accuracy + (RunData.effects["accuracy"] / 100.0))

func set_healing(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.is_healing = base_stats.is_healing

func set_lifesteal(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.lifesteal = ((Utils.get_stat("stat_lifesteal") / 100.0) + base_stats.lifesteal)
	
	if is_structure:
		new_stats.lifesteal = base_stats.lifesteal

func set_knockback(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.knockback = max(0.0, base_stats.knockback + RunData.effects["knockback"]) as int

func set_sound(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.shooting_sounds = base_stats.shooting_sounds
	new_stats.sound_db_mod = base_stats.sound_db_mod

func set_additional_cooldown(new_stats, base_stats, weapon_id = "", sets = [], effects = [], is_structure = false)->void:
	new_stats.additional_cooldown_every_x_shots = base_stats.additional_cooldown_every_x_shots
	new_stats.additional_cooldown_multiplier = base_stats.additional_cooldown_multiplier

