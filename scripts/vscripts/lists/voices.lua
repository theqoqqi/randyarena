function ReorganiseTable()

    local ReorganiseList = function(heroSounds, ...)
        local soundListPath = { ... };
        local fullHeroName = heroSounds.fullName;
        local shortHeroName = heroSounds.shortName;
        local sounds = heroSounds;

        while #soundListPath > 1 do
            sounds = sounds[table.remove(soundListPath, 1)];
            if sounds == nil then
                return;
            end
        end
        local soundType = soundListPath[1];

        local soundNames = string.split(sounds[soundType], ' ');
        sounds[soundType] = {};
        for _, soundName in pairs(soundNames) do
            soundName = fullHeroName .. '_' .. shortHeroName .. '_' .. soundName;
            table.insert(sounds[soundType], soundName);
        end
    end;

    for heroName, heroSounds in pairs(HERO_SOUND_NAMES) do
        if heroSounds ~= nil then
            ReorganiseList(heroSounds, 'ability_courier', 'spawn');
            ReorganiseList(heroSounds, 'ability_courier', 'chest_pickup');
            ReorganiseList(heroSounds, 'ability_courier', 'chest_deny');
            ReorganiseList(heroSounds, 'hero_events', 'default_greeting');
        end
    end

    -- PrintTable(HERO_SOUND_NAMES);
end

HERO_SOUND_NAMES = {
    abaddon = nil,
    abyssal_underlord = nil,
    alchemist = nil,
    ancient_apparition = nil,
    antimage = nil,
    arc_warden = nil,
    axe = nil,
    bane = nil,
    batrider = nil,
    beastmaster = nil,
    bloodseeker = nil,
    bounty_hunter = nil,
    brewmaster = nil,
    bristleback = nil,
    broodmother = nil,
    centaur = nil,
    chaos_knight = nil,
    chen = nil,
    clinkz = nil,
    crystal_maiden = {
        fullName = 'crystalmaiden',
        shortName = 'cm',
        ability_courier = {
            spawn           = 'spawn_01 spawn_02 spawn_03',
            chest_pickup    = 'lose_02 lose_03 lose_04',
            chest_deny      = 'deny_02 deny_07 deny_17',
        },
        hero_events = {
            default_greeting    = 'spawn_08 levelup_03 fastres_01',
        },
    },
    dark_seer = nil,
    dark_willow = nil,
    dazzle = nil,
    death_prophet = nil,
    disruptor = nil,
    doom_bringer = nil,
    dragon_knight = nil,
    drow_ranger = nil,
    earth_spirit = nil,
    earthshaker = nil,
    elder_titan = nil,
    ember_spirit = nil,
    enchantress = nil,
    enigma = nil,
    faceless_void = nil,
    furion = nil,
    grimstroke = nil,
    gyrocopter = nil,
    huskar = nil,
    invoker = nil,
    jakiro = nil,
    juggernaut = nil,
    keeper_of_the_light = nil,
    kunkka = nil,
    legion_commander = nil,
    leshrac = nil,
    lich = nil,
    life_stealer = nil,
    lina = {
        fullName = 'lina',
        shortName = 'lina',
        ability_courier = {
            spawn           = 'spawn_02 spawn_07 spawn_08',
            chest_pickup    = 'anger_06 death_01 lose_03',
            chest_deny      = 'deny_06 deny_11 deny_14',
        },
        hero_events = {
            default_greeting    = 'rival_16 rare_01 rare_02 rare_03 rare_04',
        },
    },
    lion = nil,
    lone_druid = nil,
    luna = nil,
    lycan = nil,
    magnataur = nil,
    medusa = nil,
    meepo = nil,
    mirana = nil,
    monkey_king = nil,
    morphling = nil,
    naga_siren = nil,
    necrolyte = nil,
    nevermore = nil,
    night_stalker = nil,
    nyx_assassin = nil,
    obsidian_destroyer = nil,
    ogre_magi = nil,
    omniknight = nil,
    oracle = {
        fullName = 'oracle',
        shortName = 'orac',
        ability_courier = {
            spawn           = 'spawn_01 spawn_02 spawn_03',
            chest_pickup    = 'lose_01 lose_02 lose_03',
            chest_deny      = 'deny_01 deny_02 deny_03',
        },
        hero_events = {
            default_greeting    = 'spawn_11 spawn_13 spawn_18',
        },
    },
    pangolier = nil,
    phantom_assassin = {
        fullName = 'phantom_assassin',
        shortName = 'phass',
        ability_courier = {
            spawn           = 'spawn_03 respawn_03 respawn_07',
            chest_pickup    = 'lose_01 lose_02 death_01',
            chest_deny      = 'deny_01 deny_07 deny_09',
        },
        hero_events = {
            default_greeting    = 'cast_03 spawn_05 respawn_08',
        },
    },
    phantom_lancer = nil,
    phoenix = nil,
    puck = nil,
    pudge = nil,
    pugna = nil,
    queenofpain = nil,
    rattletrap = nil,
    razor = nil,
    riki = nil,
    rubick = nil,
    sand_king = nil,
    shadow_demon = nil,
    shadow_shaman = nil,
    shredder = nil,
    silencer = nil,
    skeleton_king = nil,
    skywrath_mage = nil,
    slardar = nil,
    slark = nil,
    sniper = {
        fullName = 'sniper',
        shortName = 'snip',
        ability_courier = {
            spawn           = 'spawn_02 spawn_06 spawn_07',
            chest_pickup    = 'lose_01 lose_02 lose_03',
            chest_deny      = 'deny_01 deny_02 deny_03',
        },
        hero_events = {
            default_greeting    = 'tf2_08',
        },
    },
    spectre = nil,
    spirit_breaker = nil,
    storm_spirit = nil,
    sven = nil,
    techies = nil,
    templar_assassin = nil,
    terrorblade = nil,
    tidehunter = nil,
    tinker = nil,
    tiny = nil,
    treant = nil,
    troll_warlord = nil,
    tusk = nil,
    undying = nil,
    ursa = nil,
    vengefulspirit = nil,
    venomancer = nil,
    viper = nil,
    visage = nil,
    warlock = nil,
    weaver = nil,
    windrunner = nil,
    winter_wyvern = nil,
    wisp = nil,
    witch_doctor = nil,
    zuus = nil,
}

ReorganiseTable();
ReorganiseTable = nil;