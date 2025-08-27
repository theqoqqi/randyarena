function ReorganiseTable()
	
	local kvHeroes = LoadKeyValues('scripts/npc/npc_heroes.txt');

	local logTotal = 0;
	local logSwappable = 0;
	local logDiscardable = 0;
	local logDeliverable = 0;

	for heroName, abilityList in pairs(ABILITIES) do
		local npcName = 'npc_dota_hero_' .. heroName;
		local kvHero = kvHeroes[npcName];
		local heroAbilities = {
			swappable = {},
			discardable = {},
			deliverable = {},
		};

		for ordinal = 1, 24 do
			local index = ordinal - 1;
			local abilityName = kvHero['Ability' .. ordinal];

			if abilityName ~= nil then

				local bits = abilityList[abilityName];
				if bits ~= nil then

					logTotal = logTotal + 1;

					if bit.band(bits, SWAPPABLE) == SWAPPABLE then
						heroAbilities.swappable[index] = abilityName;
						logSwappable = logSwappable + 1;
					end

					if bit.band(bits, DISCARDABLE) == DISCARDABLE then
						heroAbilities.discardable[index] = abilityName;
						logDiscardable = logDiscardable + 1;
					end

					if bit.band(bits, DELIVERABLE) == DELIVERABLE then
						heroAbilities.deliverable[index] = abilityName;
						logDeliverable = logDeliverable + 1;
					end

					ABILITY_NAMES_TO_HERO_NAMES[abilityName] = heroName;
				end
			end
		end

		ABILITIES[heroName] = heroAbilities;
	end

	print('Abilities total: ' .. logTotal);
	print('Swappable: ' .. logSwappable);
	print('Discardable: ' .. logDiscardable);
	print('Deliverable: ' .. logDeliverable);
end

DISCARDABLE = 1;
DELIVERABLE = 2;
SWAPPABLE = 4;

SWAP_BUTTON_ABILITIES = {
    {
        abilityList = {'abyssal_underlord_dark_rift','abyssal_underlord_cancel_dark_rift'},
        resetOnCooldown = false, -- reset to first ability at its cooldown (or in N seconds)
		resetOnInactive = true, -- reset to first if another is inactive
		swapOnUse = {}, -- swap forward on use any of these abilities
    },
    {
        abilityList = {'alchemist_unstable_concoction','alchemist_unstable_concoction_throw'},
        resetOnCooldown = false,
        resetOnInactive = true,
		swapOnUse = {},
    },
    {
        abilityList = {'ancient_apparition_ice_blast','ancient_apparition_ice_blast_release'},
        resetOnCooldown = false,
        resetOnInactive = true,
		swapOnUse = {},
    },
    {
        abilityList = {'bane_nightmare','bane_nightmare_end'},
        resetOnCooldown = false,
        resetOnInactive = true,
		swapOnUse = {},
    },
	{
		abilityList = {'crystal_maiden_freezing_field','crystal_maiden_freezing_field_stop'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
	{
		abilityList = {'dawnbreaker_celestial_hammer','dawnbreaker_converge'},
		resetOnCooldown = false,
		resetOnInactive = false,
		swapOnUse = {},
	},
	{
		abilityList = {'dawnbreaker_solar_guardian','dawnbreaker_land'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
    {
        abilityList = {'elder_titan_ancestral_spirit','elder_titan_return_spirit'},
        resetOnCooldown = false,
        resetOnInactive = false,
		swapOnUse = {'elder_titan_return_spirit'},
    },
	{
		abilityList = {'hoodwink_sharpshooter','hoodwink_sharpshooter_release'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
    {
        abilityList = {'kunkka_x_marks_the_spot','kunkka_return'},
        resetOnCooldown = false,
        resetOnInactive = true,
		swapOnUse = {},
    },
	{
		abilityList = {'pangolier_gyroshell','pangolier_gyroshell_stop'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
	{
		abilityList = {'phoenix_icarus_dive','phoenix_icarus_dive_stop'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
	{
		abilityList = {'phoenix_fire_spirits','phoenix_launch_fire_spirit'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
	{
		abilityList = {'phoenix_sun_ray','phoenix_sun_ray_stop'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
	{
		abilityList = {'primal_beast_onslaught','primal_beast_onslaught_release'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
	{
		abilityList = {'puck_illusory_orb','puck_ethereal_jaunt'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {'puck_illusory_orb','puck_ethereal_jaunt'},
	},
	{
		abilityList = {'rubick_telekinesis','rubick_telekinesis_land'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
	{
		abilityList = {'shredder_chakram','shredder_return_chakram'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
	{
		abilityList = {'spectre_haunt','spectre_reality'},
		resetOnCooldown = function(heroEntity)
			local ability = heroEntity:FindAbilityByName('spectre_haunt');
			local level = ability:GetLevel();
			return GetAbilitySpecialValueForLevel('spectre_haunt', 'duration', level);
		end,
		resetOnInactive = true,
		swapOnUse = {'spectre_haunt'},
	},
	{
		abilityList = {'tiny_tree_grab','tiny_toss_tree'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
	{
		abilityList = {'tusk_snowball','tusk_launch_snowball'},
		resetOnCooldown = false,
		resetOnInactive = true,
		swapOnUse = {},
	},
};

ABILITIES = {
	abaddon = {
		['abaddon_death_coil']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['abaddon_aphotic_shield']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['abaddon_frostmourne']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['abaddon_borrowed_time']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	abyssal_underlord = {
		['abyssal_underlord_firestorm']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['abyssal_underlord_pit_of_malice']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['abyssal_underlord_atrophy_aura']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['abyssal_underlord_dark_portal']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['abyssal_underlord_dark_rift']						= DELIVERABLE,
		['abyssal_underlord_cancel_dark_rift']				= 0, -- internal
	},
	alchemist = {
		['alchemist_acid_spray']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['alchemist_unstable_concoction']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['alchemist_goblins_greed']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['alchemist_berserk_potion']						= 0, -- shard
		['alchemist_chemical_rage']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['alchemist_unstable_concoction_throw']				= 0, -- internal
	},
	ancient_apparition = {
		['ancient_apparition_cold_feet']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ancient_apparition_ice_vortex']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ancient_apparition_chilling_touch']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ancient_apparition_ice_blast']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ancient_apparition_ice_blast_release']			= 0, -- internal
	},
	antimage = {
		['antimage_mana_break']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['antimage_blink']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['antimage_counterspell']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['antimage_mana_overload']							= 0, -- shard
		['antimage_mana_void']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['antimage_spell_shield']							= DELIVERABLE,
	},
	arc_warden = {
		['arc_warden_flux']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['arc_warden_magnetic_field']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['arc_warden_spark_wraith']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['arc_warden_tempest_double']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	axe = {
		['axe_berserkers_call']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['axe_battle_hunger']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['axe_counter_helix']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['axe_culling_blade']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	bane = {
		['bane_enfeeble']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bane_brain_sap']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bane_nightmare']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bane_fiends_grip']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bane_nightmare_end']								= 0, -- internal
	},
	batrider = {
		['batrider_sticky_napalm']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['batrider_flamebreak']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['batrider_firefly']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['batrider_flaming_lasso']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	beastmaster = {
		['beastmaster_wild_axes']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['beastmaster_call_of_the_wild_boar']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['beastmaster_call_of_the_wild_hawk']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['beastmaster_inner_beast']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['beastmaster_primal_roar']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['beastmaster_mark_of_the_beast']					= 0, -- unfinished
	},
	bloodseeker = {
		['bloodseeker_bloodrage']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bloodseeker_blood_bath']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bloodseeker_thirst']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bloodseeker_blood_mist']							= 0, -- shard
		['bloodseeker_rupture']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	bounty_hunter = {
		['bounty_hunter_shuriken_toss']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bounty_hunter_jinada']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bounty_hunter_wind_walk']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bounty_hunter_track']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	brewmaster = {
		['brewmaster_thunder_clap']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['brewmaster_cinder_brew']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['brewmaster_drunken_brawler']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['brewmaster_primal_split']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	bristleback = {
		['bristleback_viscous_nasal_goo']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bristleback_quill_spray']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['bristleback_bristleback']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['bristleback_hairball']							= 0, -- shard
		['bristleback_warpath']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	broodmother = {
		['broodmother_insatiable_hunger']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['broodmother_spin_web']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['broodmother_silken_bola']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['broodmother_sticky_snare']						= 0, -- scepter
		['broodmother_spawn_spiderlings']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['broodmother_incapacitating_bite']					= DELIVERABLE,
	},
	centaur = {
		['centaur_hoof_stomp']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['centaur_double_edge']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['centaur_return']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['centaur_stampede']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	chaos_knight = {
		['chaos_knight_chaos_bolt']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['chaos_knight_reality_rift']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['chaos_knight_chaos_strike']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['chaos_knight_phantasm']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	chen = {
		['chen_penitence']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['chen_holy_persuasion']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['chen_divine_favor']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['chen_hand_of_god']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	clinkz = {
		['clinkz_strafe']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['clinkz_searing_arrows']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['clinkz_wind_walk']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['clinkz_burning_army']								= 0, -- shard
		['clinkz_death_pact']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	crystal_maiden = {
		['crystal_maiden_crystal_nova']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['crystal_maiden_frostbite']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['crystal_maiden_brilliance_aura']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['crystal_maiden_freezing_field']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['crystal_maiden_freezing_field_stop']				= 0, -- internal
	},
	dark_seer = {
		['dark_seer_vacuum']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dark_seer_ion_shell']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dark_seer_surge']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['dark_seer_normal_punch']							= 0, -- shard
		['dark_seer_wall_of_replica']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	dark_willow = {
		['dark_willow_bramble_maze']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dark_willow_shadow_realm']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dark_willow_cursed_crown']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dark_willow_bedlam']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dark_willow_terrorize']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	dawnbreaker = {
		['dawnbreaker_fire_wreath']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dawnbreaker_celestial_hammer']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dawnbreaker_luminosity']							= DISCARDABLE,
		['dawnbreaker_solar_guardian']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dawnbreaker_converge']							= 0, -- internal
		['dawnbreaker_land']								= 0, -- internal
	},
	dazzle = {
		['dazzle_poison_touch']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dazzle_shallow_grave']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dazzle_shadow_wave']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dazzle_good_juju']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dazzle_bad_juju']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['dazzle_rain_of_vermin']							= 0, -- old scepter
		['dazzle_weave']									= DELIVERABLE,
	},
	death_prophet = {
		['death_prophet_carrion_swarm']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['death_prophet_silence']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['death_prophet_spirit_siphon']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['death_prophet_exorcism']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	disruptor = {
		['disruptor_thunder_strike']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['disruptor_glimpse']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['disruptor_kinetic_field']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['disruptor_static_storm']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	doom_bringer = {
		['doom_bringer_devour']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['doom_bringer_scorched_earth']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['doom_bringer_infernal_blade']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['doom_bringer_empty1']								= DISCARDABLE,
		['doom_bringer_empty2']								= DISCARDABLE,
		['doom_bringer_doom']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	dragon_knight = {
		['dragon_knight_breathe_fire']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dragon_knight_dragon_tail']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['dragon_knight_dragon_blood']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['dragon_knight_fireball']							= 0, -- shard
		['dragon_knight_elder_dragon_form']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	drow_ranger = {
		['drow_ranger_frost_arrows']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['drow_ranger_wave_of_silence']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['drow_ranger_multishot']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['drow_ranger_marksmanship']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	earth_spirit = {
		['earth_spirit_boulder_smash']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['earth_spirit_rolling_boulder']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['earth_spirit_geomagnetic_grip']					= DISCARDABLE,
		['earth_spirit_stone_caller']						= DISCARDABLE,
		['earth_spirit_petrify']							= 0, -- scepter
		['earth_spirit_magnetize']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	earthshaker = {
		['earthshaker_fissure']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['earthshaker_enchant_totem']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['earthshaker_aftershock']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['earthshaker_echo_slam']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	elder_titan = {
		['elder_titan_echo_stomp']							= DISCARDABLE,
		['elder_titan_ancestral_spirit']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['elder_titan_natural_order']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['elder_titan_move_spirit']							= 0, -- internal
		['elder_titan_return_spirit']						= 0, -- internal
		['elder_titan_earth_splitter']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	ember_spirit = {
		['ember_spirit_searing_chains']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ember_spirit_sleight_of_fist']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ember_spirit_flame_guard']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ember_spirit_activate_fire_remnant']				= DISCARDABLE,
		['ember_spirit_fire_remnant']						= DISCARDABLE,
	},
	enchantress = {
		['enchantress_untouchable']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['enchantress_enchant']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['enchantress_natures_attendants']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['enchantress_bunny_hop']							= 0, -- scepter
		['enchantress_impetus']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	enigma = {
		['enigma_malefice']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['enigma_demonic_conversion']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['enigma_midnight_pulse']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['enigma_black_hole']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	faceless_void = {
		['faceless_void_time_walk']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['faceless_void_time_dilation']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['faceless_void_time_lock']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['faceless_void_time_walk_reverse']					= 0, -- shard
		['faceless_void_chronosphere']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	furion = {
		['furion_sprout']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['furion_teleportation']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['furion_force_of_nature']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['furion_wrath_of_nature']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	grimstroke = {
		['grimstroke_dark_artistry']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['grimstroke_ink_creature']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['grimstroke_spirit_walk']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['grimstroke_dark_portrait']						= 0, -- scepter
		['grimstroke_soul_chain']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['grimstroke_ink_over']								= 0, -- old shard
	},
	gyrocopter = {
		['gyrocopter_rocket_barrage']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['gyrocopter_homing_missile']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['gyrocopter_flak_cannon']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['gyrocopter_call_down']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	hoodwink = {
		['hoodwink_acorn_shot']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['hoodwink_bushwhack']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['hoodwink_scurry']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['hoodwink_sharpshooter']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['hoodwink_sharpshooter_release']					= 0, -- internal
		['hoodwink_hunters_boomerang']						= 0, -- scepter
		['hoodwink_decoy']									= 0, -- shard
	},
	huskar = {
		['huskar_inner_fire']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['huskar_burning_spear']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['huskar_berserkers_blood']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['huskar_life_break']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['huskar_inner_vitality']							= DELIVERABLE,
	},
	invoker = {
		['invoker_quas']									= 0,
		['invoker_wex']										= 0,
		['invoker_exort']									= 0,
		['invoker_empty1']									= 0,
		['invoker_empty2']									= 0,
		['invoker_invoke']									= 0,
		['invoker_cold_snap']								= 0,
		['invoker_ghost_walk']								= 0,
		['invoker_tornado']									= 0,
		['invoker_emp']										= 0,
		['invoker_alacrity']								= 0,
		['invoker_chaos_meteor']							= 0,
		['invoker_sun_strike']								= 0,
		['invoker_forge_spirit']							= 0,
		['invoker_ice_wall']								= 0,
		['invoker_deafening_blast']							= 0,
		-- ability draft skills
		['invoker_cold_snap_ad']							= DELIVERABLE,
		['invoker_ghost_walk_ad']							= DELIVERABLE,
		['invoker_tornado_ad']								= DELIVERABLE,
		['invoker_emp_ad']									= DELIVERABLE,
		['invoker_alacrity_ad']								= DELIVERABLE,
		['invoker_chaos_meteor_ad']							= DELIVERABLE,
		['invoker_sun_strike_ad']							= DELIVERABLE,
		['invoker_forge_spirit_ad']							= DELIVERABLE,
		['invoker_ice_wall_ad']								= DELIVERABLE,
		['invoker_deafening_blast_ad']						= DELIVERABLE,
	},
	jakiro = {
		['jakiro_dual_breath']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['jakiro_ice_path']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['jakiro_liquid_fire']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['jakiro_liquid_ice']								= 0, -- shard
		['jakiro_macropyre']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	juggernaut = {
		['juggernaut_blade_fury']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['juggernaut_healing_ward']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['juggernaut_blade_dance']							= DISCARDABLE,
        ['juggernaut_swift_slash']							= 0, -- scepter
		['juggernaut_omni_slash']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	keeper_of_the_light = {
		['keeper_of_the_light_illuminate']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['keeper_of_the_light_radiant_bind']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['keeper_of_the_light_chakra_magic']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['keeper_of_the_light_will_o_wisp']				    = 0, -- scepter
		['keeper_of_the_light_spirit_form']					= DISCARDABLE, -- dangerous
		['keeper_of_the_light_spirit_form_illuminate']		= 0, -- internal
		['keeper_of_the_light_spirit_form_illuminate_end']	= 0, -- internal
		['keeper_of_the_light_illuminate_end']				= 0, -- internal
		['keeper_of_the_light_blinding_light']				= 0, -- internal
		['keeper_of_the_light_recall']						= 0, -- internal
		-- unused abilities
        ['keeper_of_the_light_mana_leak']					= DELIVERABLE,
	},
	kunkka = {
		['kunkka_torrent']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['kunkka_tidebringer']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['kunkka_x_marks_the_spot']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['kunkka_torrent_storm']							= 0, -- scepter
        ['kunkka_tidal_wave']								= 0, -- shard
		['kunkka_ghostship']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['kunkka_return']									= 0, -- internal
	},
	legion_commander = {
		['legion_commander_overwhelming_odds']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['legion_commander_press_the_attack']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['legion_commander_moment_of_courage']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['legion_commander_duel']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	leshrac = {
		['leshrac_split_earth']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['leshrac_diabolic_edict']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['leshrac_lightning_storm']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['leshrac_greater_lightning_storm']					= 0, -- scepter
		['leshrac_pulse_nova']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	lich = {
		['lich_frost_nova']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lich_frost_shield']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lich_sinister_gaze']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['lich_ice_spire']									= 0, -- shard
		['lich_chain_frost']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['lich_frost_armor']								= DELIVERABLE,
		['lich_dark_sorcery']								= DELIVERABLE,
		['lich_frost_aura']									= DELIVERABLE,
	},
	life_stealer = {
		['life_stealer_rage']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['life_stealer_feast']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['life_stealer_ghoul_frenzy']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['life_stealer_assimilate']							= 0, -- scepter
        ['life_stealer_open_wounds']						= 0, -- shard
		['life_stealer_infest']								= DISCARDABLE,
		['life_stealer_control']							= 0, -- internal
		['life_stealer_consume']							= 0, -- internal
		['life_stealer_assimilate_eject']					= 0, -- internal
	},
	lina = {
		['lina_dragon_slave']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lina_light_strike_array']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lina_fiery_soul']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lina_laguna_blade']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	lion = {
		['lion_impale']										= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lion_voodoo']										= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lion_mana_drain']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lion_finger_of_death']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	lone_druid = {
		['lone_druid_spirit_bear']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lone_druid_spirit_link']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lone_druid_savage_roar']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lone_druid_true_form_battle_cry']					= 0, -- druid form only
		['lone_druid_true_form']							= 0, -- crashes game
		['lone_druid_true_form_druid']						= 0, -- internal
	},
	luna = {
		['luna_lucent_beam']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['luna_moon_glaive']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['luna_lunar_blessing']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['luna_eclipse']									= DISCARDABLE,
	},
	lycan = {
		['lycan_summon_wolves']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lycan_howl']										= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['lycan_feral_impulse']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['lycan_wolf_bite']								    = 0, -- scepter
		['lycan_shapeshift']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	magnataur = {
		['magnataur_shockwave']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['magnataur_empower']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['magnataur_skewer']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['magnataur_horn_toss']								= 0, -- shard
		['magnataur_reverse_polarity']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	marci = {
		['marci_grapple']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['marci_companion_run']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['marci_guardian']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['marci_unleash']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	mars = {
		['mars_spear']										= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['mars_gods_rebuke']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['mars_bulwark']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['mars_arena_of_blood']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	medusa = {
		['medusa_split_shot']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['medusa_mystic_snake']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['medusa_mana_shield']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['medusa_cold_blooded']								= 0, -- shard
		['medusa_stone_gaze']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	meepo = {
		['meepo_earthbind']									= DELIVERABLE,
		['meepo_poof']										= DELIVERABLE,
		['meepo_ransack']									= DELIVERABLE,
        ['meepo_geostrike']									= DELIVERABLE,
        ['meepo_petrify']   						        = 0, -- scepter
		['meepo_divided_we_stand']							= 0, -- works wrong
	},
	mirana = {
		['mirana_starfall']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['mirana_arrow']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['mirana_leap']										= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['mirana_invis']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	monkey_king = {
		['monkey_king_boundless_strike']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['monkey_king_tree_dance']							= DISCARDABLE,
		['monkey_king_primal_spring']						= DISCARDABLE,
		['monkey_king_jingu_mastery']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['monkey_king_mischief']							= DISCARDABLE,
		['monkey_king_wukongs_command']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['monkey_king_primal_spring_early']					= 0, -- internal
		['monkey_king_untransform']							= 0, -- internal
	},
	morphling = {
		['morphling_waveform']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['morphling_adaptive_strike_agi']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['morphling_adaptive_strike_str']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['morphling_morph_agi']								= DISCARDABLE,
		['morphling_morph_str']								= DISCARDABLE,
		['morphling_replicate']								= DISCARDABLE,
		['morphling_morph_replicate']						= 0, -- internal
		['morphling_morph']									= 0, -- internal
	},
	muerta = {
		['muerta_dead_shot']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['muerta_the_calling']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['muerta_gunslinger']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['muerta_pierce_the_veil']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	naga_siren = {
		['naga_siren_mirror_image']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['naga_siren_ensnare']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['naga_siren_rip_tide']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['naga_siren_song_of_the_siren']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['naga_siren_song_of_the_siren_cancel']				= 0, -- internal
	},
	necrolyte = {
		['necrolyte_death_pulse']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['necrolyte_sadist']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['necrolyte_heartstopper_aura']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['necrolyte_death_seeker']						    = 0, -- shard
		['necrolyte_reapers_scythe']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	nevermore = { -- shadow fiend
		['nevermore_shadowraze1']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['nevermore_shadowraze2']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['nevermore_shadowraze3']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['nevermore_necromastery']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['nevermore_dark_lord']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['nevermore_requiem']								= DISCARDABLE,
	},
	night_stalker = {
		['night_stalker_void']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['night_stalker_crippling_fear']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['night_stalker_hunter_in_the_night']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['night_stalker_darkness']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	nyx_assassin = {
		['nyx_assassin_impale']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['nyx_assassin_mana_burn']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['nyx_assassin_spiked_carapace']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['nyx_assassin_burrow']								= 0, -- scepter
		['nyx_assassin_vendetta']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['nyx_assassin_unburrow']							= 0, -- internal
	},
	obsidian_destroyer = {
		['obsidian_destroyer_arcane_orb']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['obsidian_destroyer_astral_imprisonment']			= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['obsidian_destroyer_equilibrium']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['obsidian_destroyer_sanity_eclipse']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	ogre_magi = {
		['ogre_magi_fireblast']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ogre_magi_ignite']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ogre_magi_bloodlust']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ogre_magi_unrefined_fireblast']					= 0, -- scepter
        ['ogre_magi_smash']					                = 0, -- shard
		['ogre_magi_multicast']								= DISCARDABLE,
	},
	omniknight = {
		['omniknight_purification']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['omniknight_repel']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['omniknight_hammer_of_purity']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['omniknight_degen_aura']							= 0, -- shard
        ['omniknight_guardian_angel']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	oracle = {
		['oracle_fortunes_end']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['oracle_fates_edict']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['oracle_purifying_flames']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['oracle_rain_of_destiny']							= 0, -- scepter
		['oracle_false_promise']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	pangolier = {
		['pangolier_swashbuckle']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['pangolier_shield_crash']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['pangolier_lucky_shot']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['pangolier_rollup']							    = 0, -- shard
		['pangolier_gyroshell']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['pangolier_rollup_stop']							= 0, -- internal
		['pangolier_gyroshell_stop']						= 0, -- internal
        -- Unused abilities
        ['pangolier_heartpiercer']  						= DISCARDABLE,
	},
	phantom_assassin = {
		['phantom_assassin_stifling_dagger']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['phantom_assassin_phantom_strike']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['phantom_assassin_blur']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['phantom_assassin_fan_of_knives']					= 0, -- shard
		['phantom_assassin_coup_de_grace']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	phantom_lancer = {
		['phantom_lancer_spirit_lance']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['phantom_lancer_doppelwalk']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['phantom_lancer_phantom_edge']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['phantom_lancer_juxtapose']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	phoenix = {
		['phoenix_icarus_dive']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['phoenix_fire_spirits']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['phoenix_sun_ray']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['phoenix_sun_ray_toggle_move']						= DISCARDABLE,
		['phoenix_supernova']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['phoenix_launch_fire_spirit']						= 0, -- internal
		['phoenix_icarus_dive_stop']						= 0, -- internal
		['phoenix_sun_ray_stop']							= 0, -- internal
	},
	primal_beast = {
		['primal_beast_onslaught']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['primal_beast_trample']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['primal_beast_uproar']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['primal_beast_rock_throw']							= 0, -- shard
		['primal_beast_pulverize']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['primal_beast_onslaught_release']					= 0, -- internal
	},
	puck = {
		['puck_illusory_orb']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['puck_waning_rift']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['puck_phase_shift']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['puck_ethereal_jaunt']								= 0, -- internal
		['puck_dream_coil']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	pudge = {
		['pudge_meat_hook']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['pudge_rot']										= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['pudge_flesh_heap']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['pudge_dismember']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['pudge_eject']										= 0, -- internal
	},
	pugna = {
		['pugna_nether_blast']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['pugna_decrepify']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['pugna_nether_ward']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['pugna_life_drain']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	queenofpain = {
		['queenofpain_shadow_strike']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['queenofpain_blink']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['queenofpain_scream_of_pain']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['queenofpain_sonic_wave']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	rattletrap = { -- clockwerk
		['rattletrap_battery_assault']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['rattletrap_power_cogs']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['rattletrap_rocket_flare']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['rattletrap_hookshot']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['rattletrap_overclocking']							= 0, -- scepter
		['rattletrap_jetpack']								= 0, -- shard
	},
	razor = {
		['razor_plasma_field']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['razor_static_link']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['razor_unstable_current']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['razor_eye_of_the_storm']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	riki = {
		['riki_smoke_screen']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['riki_blink_strike']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['riki_tricks_of_the_trade']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['riki_poison_dart']						        = 0, -- shard
		['riki_backstab']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	rubick = {
		['rubick_telekinesis']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['rubick_fade_bolt']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['rubick_arcane_supremacy']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['rubick_empty1']									= DISCARDABLE,
		['rubick_empty2']									= DISCARDABLE,
		['rubick_spell_steal']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['rubick_telekinesis_land']							= 0, -- internal
		['rubick_telekinesis_land_self']					= 0, -- internal
		['rubick_hidden1']									= 0, -- internal
		['rubick_hidden2']									= 0, -- internal
		['rubick_hidden3']									= 0, -- internal
	},
	sand_king = {
		['sandking_burrowstrike']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['sandking_sand_storm']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['sandking_caustic_finale']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['sandking_epicenter']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	shadow_demon = {
		['shadow_demon_disruption']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['shadow_demon_soul_catcher']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['shadow_demon_shadow_poison']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['shadow_demon_shadow_poison_release']				= DISCARDABLE,
		['shadow_demon_demonic_cleanse']					= 0, -- shard
		['shadow_demon_demonic_purge']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	shadow_shaman = {
		['shadow_shaman_ether_shock']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['shadow_shaman_voodoo']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['shadow_shaman_shackles']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['shadow_shaman_mass_serpent_ward']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	shredder = { -- timbersaw
		['shredder_whirling_death']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['shredder_timber_chain']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['shredder_reactive_armor']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['shredder_chakram_2']								= 0, -- scepter
		['shredder_flamethrower']							= 0, -- shard
		['shredder_chakram']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['shredder_return_chakram']							= 0, -- internal
		['shredder_return_chakram_2']						= 0, -- internal
	},
	silencer = {
		['silencer_curse_of_the_silent']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['silencer_glaives_of_wisdom']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['silencer_last_word']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['silencer_global_silence']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	skeleton_king = { -- wraithking
		['skeleton_king_hellfire_blast']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['skeleton_king_vampiric_aura']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['skeleton_king_mortal_strike']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['skeleton_king_reincarnation']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	skywrath_mage = {
		['skywrath_mage_arcane_bolt']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['skywrath_mage_concussive_shot']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['skywrath_mage_ancient_seal']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['skywrath_mage_mystic_flare']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	slardar = {
		['slardar_sprint']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['slardar_slithereen_crush']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['slardar_bash']									= DISCARDABLE,
		['slardar_amplify_damage']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	slark = {
		['slark_dark_pact']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['slark_pounce']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['slark_essence_shift']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['slark_depth_shroud']								= 0, -- shard
		['slark_shadow_dance']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['slark_fish_bait']								    = 0, -- old shard
	},
	snapfire = {
		['snapfire_scatterblast']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['snapfire_firesnap_cookie']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['snapfire_lil_shredder']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['snapfire_mortimer_kisses']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['snapfire_gobble_up']								= 0, -- internal
        ['snapfire_spit_creep']								= 0, -- internal
	},
	sniper = {
		['sniper_shrapnel']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['sniper_headshot']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['sniper_take_aim']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['sniper_concussive_grenade']						= 0, -- shard
        ['sniper_assassinate']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	spectre = {
		['spectre_spectral_dagger']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['spectre_desolate']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['spectre_dispersion']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['spectre_reality']									= DISCARDABLE,
        ['spectre_haunt_single']							= 0, -- scepter
		['spectre_haunt']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	spirit_breaker = {
		['spirit_breaker_charge_of_darkness']				= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['spirit_breaker_bulldoze']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['spirit_breaker_greater_bash']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['spirit_breaker_nether_strike']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	storm_spirit = {
		['storm_spirit_static_remnant']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['storm_spirit_electric_vortex']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['storm_spirit_overload']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['storm_spirit_ball_lightning']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['storm_spirit_electric_rave']						= 0, -- old shard
	},
	sven = {
		['sven_storm_bolt']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['sven_great_cleave']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['sven_warcry']										= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['sven_gods_strength']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	techies = {
		['techies_sticky_bomb']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['techies_reactive_tazer']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['techies_suicide']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['techies_land_mines']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['techies_stasis_trap']								= DELIVERABLE,
		['techies_remote_mines']							= 0, -- not works (used in sticky bomb)
		['techies_focused_detonate']						= 0,
		['techies_minefield_sign']							= 0,
	},
	templar_assassin = {
		['templar_assassin_refraction']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['templar_assassin_meld']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['templar_assassin_psi_blades']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['templar_assassin_trap']							= DISCARDABLE,
        ['templar_assassin_trap_teleport']					= 0, -- scepter
		['templar_assassin_psionic_trap']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	terrorblade = {
		['terrorblade_reflection']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['terrorblade_conjure_image']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['terrorblade_metamorphosis']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['terrorblade_terror_wave']	    					= 0, -- scepter
        ['terrorblade_demon_zeal']  						= 0, -- shard
		['terrorblade_sunder']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	tidehunter = {
		['tidehunter_gush']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tidehunter_kraken_shell']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tidehunter_anchor_smash']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tidehunter_ravage']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	tinker = {
		['tinker_laser']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tinker_heat_seeking_missile']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tinker_defense_matrix']					        = DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tinker_keen_teleport']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tinker_warp_grenade']					        	= 0, -- shard
		['tinker_rearm']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		-- unused abilities
		['tinker_march_of_the_machines']					= 0, -- old shard
	},
	tiny = {
		['tiny_avalanche']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tiny_toss']										= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tiny_tree_grab']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['tiny_tree_channel']							    = 0, -- scepter
		['tiny_grow']										= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tiny_toss_tree']									= 0, -- internal
		-- unused abilities
		['tiny_craggy_exterior']							= 0, -- shard
	},
	treant = {
		['treant_natures_grasp']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['treant_leech_seed']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['treant_living_armor']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['treant_eyes_in_the_forest']						= 0, -- scepter
		['treant_natures_guise']							= DISCARDABLE,
		['treant_overgrowth']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	troll_warlord = {
		['troll_warlord_berserkers_rage']					= DISCARDABLE,
		['troll_warlord_whirling_axes_ranged']				= DISCARDABLE,
		['troll_warlord_whirling_axes_melee']				= DISCARDABLE,
		['troll_warlord_fervor']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['troll_warlord_rampage']							= 0, -- shard
		['troll_warlord_battle_trance']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	tusk = {
		['tusk_ice_shards']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tusk_snowball']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tusk_tag_team']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tusk_walrus_kick']								= 0, -- scepter
        ['tusk_frozen_sigil']								= 0, -- shard
		['tusk_walrus_punch']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['tusk_launch_snowball']							= 0, -- internal
	},
	undying = {
		['undying_decay']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['undying_soul_rip']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['undying_tombstone']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['undying_flesh_golem']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	ursa = {
		['ursa_earthshock']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ursa_overpower']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ursa_fury_swipes']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['ursa_enrage']										= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	vengefulspirit = {
		['vengefulspirit_magic_missile']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['vengefulspirit_wave_of_terror']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['vengefulspirit_command_aura']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['vengefulspirit_nether_swap']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	venomancer = {
		['venomancer_venomous_gale']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['venomancer_poison_sting']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['venomancer_plague_ward']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['venomancer_poison_nova']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	viper = {
		['viper_poison_attack']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['viper_nethertoxin']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['viper_corrosive_skin']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['viper_viper_strike']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	visage = {
		['visage_grave_chill']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['visage_soul_assumption']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['visage_gravekeepers_cloak']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['visage_stone_form_self_cast']						= 0, -- internal
        ['visage_silent_as_the_grave']						= 0, -- scepter
		['visage_summon_familiars_stone_form']				= 0, -- shard
		['visage_summon_familiars']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	void_spirit = {
		['void_spirit_aether_remnant']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['void_spirit_dissimilate']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['void_spirit_astral_step']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['void_spirit_resonant_pulse']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	warlock = {
		['warlock_fatal_bonds']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['warlock_shadow_word']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['warlock_upheaval']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['warlock_rain_of_chaos']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	weaver = {
		['weaver_the_swarm']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['weaver_shukuchi']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['weaver_geminate_attack']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['weaver_time_lapse']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	windrunner = {
		['windrunner_shackleshot']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['windrunner_powershot']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['windrunner_windrun']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['windrunner_gale_force']							= 0, -- shard
		['windrunner_focusfire']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	winter_wyvern = {
		['winter_wyvern_arctic_burn']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['winter_wyvern_splinter_blast']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['winter_wyvern_cold_embrace']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['winter_wyvern_winters_curse']						= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	wisp = {
		['wisp_tether']										= DISCARDABLE,
		['wisp_spirits']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['wisp_overcharge']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['wisp_relocate']									= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['wisp_tether_break']								= 0,
		['wisp_spirits_in']									= 0,
		['wisp_spirits_out']								= 0,
	},
	witch_doctor = {
		['witch_doctor_paralyzing_cask']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['witch_doctor_voodoo_restoration']					= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['witch_doctor_maledict']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
        ['witch_doctor_voodoo_switcheroo']					= 0, -- shard
		['witch_doctor_death_ward']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
	zuus = {
		['zuus_arc_lightning']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['zuus_lightning_bolt']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['zuus_heavenly_jump']								= DISCARDABLE + DELIVERABLE + SWAPPABLE,
		['zuus_cloud']										= 0, -- scepter
		['zuus_static_field']								= 0, -- scepter
		['zuus_thundergods_wrath']							= DISCARDABLE + DELIVERABLE + SWAPPABLE,
	},
};

ABILITY_NAMES_TO_HERO_NAMES = {};

ReorganiseTable();
ReorganiseTable = nil;