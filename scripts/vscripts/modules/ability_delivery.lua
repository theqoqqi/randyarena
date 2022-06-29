--
-- Created by IntelliJ IDEA.
-- User: Qoqqi
-- Date: 20.10.2018
-- Time: 18:17
-- To change this template use File | Settings | File Templates.
--

AbilityDelivery = class({});

function AbilityDelivery:Create(randyArena, options)

    local instance = AbilityDelivery();

    instance.randyArena = randyArena;

    instance.allAbilityDropsites = Entities:FindAllByName('ability_spawn_point');

    instance.lastAbilityInChest = nil;
    instance.abilityCourier = nil;
    instance.courierHeroName = nil;
    instance.courierAbilityChest = nil;
    instance.abilityInChest = nil;
    instance.droppedAbilityChest = nil;
    instance.dropsiteEntity = nil;
    instance.dropsitePosition = nil;
    instance.courierDespawnTimer = nil;
    instance.dropsiteFowRevealer = nil;
    instance.dropsiteParticleId = nil;

    RegisterCustomGameEventListener(instance, 'ability_swapped', 'OnAbilitySwapped');

    ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(instance, 'OnItemPickedUp'), instance);
    ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(instance, 'OnNonPlayerUsedAbility'), instance);

    return instance;
end

function AbilityDelivery:OnGameInProgress()

    Timers:CreateTimer({
        endTime = ABILITY_CHEST_SPAWN_TIME_FIRST - ABILITY_CHEST_SPAWN_WARN_OFFSET,
        callback = function()

            self:SelectRandomDropsite();
            self.dropsiteFowRevealer = CreateUnitByName(
                'npc_vision_revealer',
                self.dropsitePosition,
                false, nil, nil,
                DOTA_TEAM_GOODGUYS
            );
            self.dropsiteParticleId = ParticleManager:CreateParticle(
                PARTICLES_FOLDER .. '/chest_highlight.vpcf', PATTACH_CUSTOMORIGIN, nil
            );
            ParticleManager:SetParticleControl(self.dropsiteParticleId, 0, self.dropsitePosition);

            -- notify everyone
            CustomGameEventManager:Send_ServerToAllClients('item_will_spawn', {
                spawn_location = self.dropsitePosition
            });
            EmitGlobalSound('powerup_03');

            return ABILITY_CHEST_SPAWN_TIME_DELAY;
        end
    });

    Timers:CreateTimer({
        endTime = ABILITY_CHEST_SPAWN_TIME_FIRST - 3,
        callback = function()

            local abilityInfo;
            if DEBUG_ABILITY_CHEST and #FORCE_CHEST_ABILITY > 0 then
                abilityInfo = {
                    heroName = FORCE_ABILITY_COURIER,
                    abilityName = table.remove(FORCE_CHEST_ABILITY, 1),
                };
            elseif #self.randyArena.abilitiesToDelivery > 0 then
                abilityInfo = table.remove(self.randyArena.abilitiesToDelivery, 1);
            else
                abilityInfo = ConsumeRandomFromTable(self.randyArena.unusedAbilityPool);
            end

            self:SpawnAbilityCourier(abilityInfo.heroName, abilityInfo.abilityName);

            -- notify everyone
            CustomGameEventManager:Send_ServerToAllClients('item_has_spawned', {});
            EmitGlobalSound('powerup_05');

            return ABILITY_CHEST_SPAWN_TIME_DELAY;
        end
    });
end

function AbilityDelivery:SpawnAbilityCourier(heroName, abilityName)
    --print('SpawnAbilityCourier', heroName, abilityName);
    self.courierHeroName = heroName;
    self.abilityCourier = self:CreateAbilityCourier(heroName, abilityName);

    self:TeleportToPosition(self.abilityCourier, Vector(0, 0, 520), ABILITY_COURIER_TELEPORT_DURATION, function()
        self.abilityCourier:CastAbilityOnPosition(self.dropsitePosition, self.courierAbilityChest, -1);
    end);

    -- Give vision to the spawn area (unit is on goodguys, but shared vision)
    -- local visionRevealer = CreateUnitByName( "npc_vision_revealer", self.dropsitePosition, false, nil, nil, DOTA_TEAM_GOODGUYS )
    -- visionRevealer:SetContextThink( "KillVisionRevealer", function() return visionRevealer:RemoveSelf() end, 35 )
    -- local trueSight = ParticleManager:CreateParticle( "particles/econ/wards/f2p/f2p_ward/f2p_ward_true_sight_ambient.vpcf", PATTACH_ABSORIGIN, visionRevealer )
    -- ParticleManager:SetParticleControlEnt( trueSight, PATTACH_ABSORIGIN, visionRevealer, PATTACH_ABSORIGIN, "attach_origin", visionRevealer:GetAbsOrigin(), true )
    -- visionRevealer:SetContextThink( "KillVisionParticle", function() return trueSight:RemoveSelf() end, 35 )

    self:PlayRandomAbilityCourierSound(heroName, 'spawn');
end

function AbilityDelivery:CreateAbilityCourier(heroName, abilityName)
    local npcName = 'npc_dota_hero_' .. heroName;
    local position = Vector(-10000, 0, 1000);
    local courier = CreateUnitByName(npcName, position, true, nil, nil, DOTA_TEAM_NEUTRALS);

    courier:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK);
    courier:SetModelScale(0.7);
    courier:SetBaseMoveSpeed(500);
    courier:AddAbility('dota_ability_treasure_courier'):SetLevel(1);

    self.courierAbilityChest = courier:AddItemByName('item_ability_chest');
    self.abilityInChest = abilityName;

    return courier;
end

function AbilityDelivery:DespawnAbilityCourierNoDeny()
    Timers:RemoveTimer(self.courierDespawnTimer);
    self.courierDespawnTimer = nil;
    self:PlayRandomAbilityCourierSound(self.courierHeroName, 'chest_pickup');
    self:DespawnAbilityCourier();
end

function AbilityDelivery:DespawnAbilityCourier()
    local position = Vector(10000, 10000, 0);
    self:TeleportToPosition(self.abilityCourier, position, ABILITY_COURIER_TELEPORT_DURATION, function()
        UTIL_Remove(self.abilityCourier);
        UTIL_Remove(self.dropsiteFowRevealer);
        ParticleManager:DestroyParticle(self.dropsiteParticleId, false);
        ParticleManager:ReleaseParticleIndex(self.dropsiteParticleId);
        self.abilityCourier = nil;
        self.courierHeroName = nil;
        self.courierAbilityChest = nil;
        self.abilityInChest = nil;
        self.droppedAbilityChest = nil;
        self.dropsiteEntity = nil;
        self.dropsitePosition = nil;
        self.courierDespawnTimer = nil;
        self.dropsiteFowRevealer = nil;
        self.dropsiteParticleId = nil;
    end);
end

function AbilityDelivery:TeleportToPosition(unit, position, duration, onFinish)

    local endpointUnit = CreateUnitByName('npc_dummy', position, true, nil, nil, DOTA_TEAM_NOTEAM);

    self:RunTeleportParticlesAt(unit:GetAbsOrigin(), 'start', duration);
    StartSoundEvent('Portal.Loop_Disappear', unit);

    self:RunTeleportParticlesAt(position, 'end', duration);
    StartSoundEvent('Portal.Loop_Appear', endpointUnit);

    StartAnimation(unit, {
        duration = duration,
        activity = ACT_DOTA_TELEPORT,
        rate = 1
    });

    Timers:CreateTimer({
        endTime = duration,
        callback = function()
            StopSoundEvent('Portal.Loop_Disappear', unit);
            StopSoundEvent('Portal.Loop_Appear', endpointUnit);
            UTIL_Remove(endpointUnit);

            EmitSoundOn('Portal.Hero_Disappear', unit);
            unit:SetAbsOrigin(position);
            EmitSoundOn('Portal.Hero_Appear', unit);
            onFinish();
        end
    });
end

function AbilityDelivery:RunTeleportParticlesAt(position, particleName, duration)

    if not self:IsInWorldBounds(position) then
        return;
    end

    local tpInFxIndex = ParticleManager:CreateParticle('particles/items2_fx/teleport_' .. particleName .. '.vpcf', PATTACH_CUSTOMORIGIN, nil);
    ParticleManager:SetParticleControl(tpInFxIndex, 0, position);

    Timers:CreateTimer(duration, function()
        ParticleManager:DestroyParticle(tpInFxIndex, false);
        ParticleManager:ReleaseParticleIndex(tpInFxIndex);
    end);
end

function AbilityDelivery:IsInWorldBounds(position)
    return position.x >= GetWorldMinX() and position.x <= GetWorldMaxX()
       and position.y >= GetWorldMinY() and position.y <= GetWorldMaxY();
end

function AbilityDelivery:StartAbilityDespawnCountdown()
    self.courierDespawnTimer = Timers:CreateTimer({
        endTime = ABILITY_CHEST_DENY_DELAY,
        callback = function()
            local droppedItem = Entities:FindByModel(nil, 'models/props_gameplay/treasure_chest001.vmdl');
            self.abilityCourier:PickupDroppedItem(droppedItem);
            self:PlayRandomAbilityCourierSound(self.courierHeroName, 'chest_deny');
            Timers:CreateTimer({
                endTime = 1,
                callback = function()
                    self:DespawnAbilityCourier();
                end
            });
        end
    });
end

function AbilityDelivery:NotifyHeroPickedUpItem(npcHeroName)
    CustomGameEventManager:Send_ServerToAllClients('overthrow_item_drop', {
        hero_id = npcHeroName,
        dropped_ability = self.abilityInChest
    });
end

function AbilityDelivery:SelectRandomDropsite()
    self.dropsiteEntity = RandomFromTable(self.allAbilityDropsites);
    self.dropsitePosition = self.dropsiteEntity:GetAbsOrigin();
    if DEBUG_ABILITY_CHESTS then
        self.dropsitePosition = self.dropsitePosition * Vector(0.1, 0.1, 1);
    end
end

function AbilityDelivery:PlayRandomAbilityCourierSound(heroName, soundType)
    self:PlayRandomHeroSound(heroName, 'ability_courier', soundType);
end

function AbilityDelivery:PlayRandomHeroSound(heroName, ...)
    local soundList = self:GetHeroSounds(heroName, ...);
    if soundList ~= nil then
        local soundName = RandomFromTable(soundList);
        --print(heroName, table.concat({ ... }, '/'), soundName);
        EmitGlobalSound(soundName);
        return true;
    end
    return false;
end

function AbilityDelivery:GetHeroSounds(heroName, ...)
    local soundListPath = { ... };
    local sounds = HERO_SOUND_NAMES[heroName];

    if sounds == nil then
        --print('[ERROR] No sound list found for hero: ' .. heroName);
        return nil;
    end

    local soundList = sounds;
    while #soundListPath > 0 do
        soundList = soundList[table.remove(soundListPath, 1)];
        if soundList == nil then
            --print('[ERROR] No sound list found for hero ' .. heroName .. ' of sound type ' .. table.concat(soundListPath, '/'));
            return nil;
        end
    end

    if table.isEmpty(soundList) then
        --print('Sound list found for hero ' .. heroName .. ' of sound type ' .. table.concat(soundListPath, '/') .. ' is empty');
        return nil;
    end

    return soundList;
end

function AbilityDelivery:GetAllDeliverableAbilities()
    local list = {};
    for heroName, heroAbilities in pairs(ABILITIES) do
        for abilityIndex, abilityName in pairs(heroAbilities.deliverable) do
            table.insert(list, {
                heroName = heroName,
                abilityName = abilityName,
            });
        end
    end
    return list;
end

function AbilityDelivery:OnAbilitySwapped(event)
    local playerId = event.PlayerID;
    local abilityIndex = event.abilityIndex;

    local heroEntity = Players:GetHeroEntity(playerId);
    local heroName = ParseHeroName(heroEntity:GetClassname());

    if ABILITIES[heroName].discardable[abilityIndex] ~= nil then
        AbilityUtils:SetHeroAbilityByIndex(heroEntity, abilityIndex, self.lastAbilityInChest);
        AbilityUtils:RandomizeAbilityLevel(heroEntity, abilityIndex);
        Timers:RemoveTimer(self.replaceAbilityTimer);
        self.replaceAbilityTimer = nil;
    end
end

function AbilityDelivery:OnItemPickedUp(keys)

    local itemEntity = EntIndexToHScript(keys.ItemEntityIndex);
    local itemName = keys.itemname;

    if keys.HeroEntityIndex == nil then
        if keys.UnitEntityIndex ~= nil and itemName == 'item_ability_chest' then
            local unitEntity = EntIndexToHScript(keys.UnitEntityIndex);
            unitEntity:DropItemAtPositionImmediate(itemEntity, self.dropsitePosition);
        end
        return;
    end

    local heroEntity = EntIndexToHScript(keys.HeroEntityIndex);
    local playerEntity = PlayerResource:GetPlayer(keys.PlayerID);

    if keys.PlayerID == -1 then
        return;
    end

    if itemName == 'item_ability_chest' then

        local abilityCount = AbilityUtils:GetVisibleAbilityCount(heroEntity);
        local heroName = ParseHeroName(heroEntity:GetClassname());
        local selectableIndices = table.keys(ABILITIES[heroName].discardable);
        self.lastAbilityInChest = self.abilityInChest;
        CustomGameEventManager:Send_ServerToPlayer(playerEntity, 'ability_chest_used', {
            abilityCount = abilityCount,
            allowedAbilities = selectableIndices,
            timeToSelect = ABILITY_CHEST_THINKING_TIME
        });

        self.replaceAbilityTimer = Timers:CreateTimer({
            endTime = ABILITY_CHEST_THINKING_TIME,
            callback = function()
                self.replaceAbilityTimer = nil;
                local abilityIndex = RandomFromTable(selectableIndices);
                AbilityUtils:SetHeroAbilityByIndex(heroEntity, abilityIndex, self.lastAbilityInChest);
                AbilityUtils:RandomizeAbilityLevel(heroEntity, abilityIndex);
                CustomGameEventManager:Send_ServerToPlayer(playerEntity, 'ability_chest_timeout', { });
            end
        });

        UTIL_Remove(itemEntity);

        self:NotifyHeroPickedUpItem(heroEntity:GetClassname());
        self:DespawnAbilityCourierNoDeny();
    end
end

function AbilityDelivery:OnNonPlayerUsedAbility(keys)

    local abilityName = keys.abilityname;
    local caster = EntIndexToHScript(keys.caster_entindex);

    if abilityName == 'item_ability_chest' and caster == self.abilityCourier then
        caster:DropItemAtPosition(self.dropsitePosition, self.courierAbilityChest);
        self:StartAbilityDespawnCountdown();
    end
end