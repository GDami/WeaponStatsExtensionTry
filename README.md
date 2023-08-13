Little try at the weapon_stats.gd thing

I had to make a WeaponServiceBreakdown to more finely modify the init_base_stats() func while offering as much compatibility as possible. Ideally this mod would be used by any mod modifying weapon_service.gd (a man can dream)
Anyway, with WSB I can change lines 52-55 to a different check so vanilla and modded types don't conflict. That allows me to init ingame and indescription stats as the extended script rather than vanilla during the init_base_stats. It seems that all stats resource go through this so no need to preemptively touch stuff inside item_service

Current issue i'm facing is the fact that WSE's extension (that changes the checks) is loaded before WSB's extension (that breaks the func into manies). That means it doesn't overwrite its init_new_stats() func and can't take effect despite the dependency chain.
This is due to the modloader's sorting algorithm (line 124 in script_extension.gd) but I can't remember why it's a push_front there. Should most likely be a push_back
