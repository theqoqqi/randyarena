IllusionFixer = class({});

function IllusionFixer:Create(randyArena, options)
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(IllusionFixer, 'OnNPCSpawned'), self);

    IllusionFixer.abilityException = {};
--    IllusionFixer.abilityException['arc_warden_tempest_double'] = true;
    IllusionFixer.abilityException['meepo_divided_we_stand'] = true;
    IllusionFixer.abilityException['monkey_king_wukongs_command'] = true;
    IllusionFixer.abilityException['morphling_morph_replicate'] = true;
    IllusionFixer.abilityException['morphling_replicate'] = true;
    IllusionFixer.abilityException['naga_siren_mirror_image'] = true;

    IllusionFixer.juxtaposeException = {};
    IllusionFixer.juxtaposeException['drow_ranger_marksmanship'] = true;
    IllusionFixer.juxtaposeException['medusa_split_shot'] = true;
end

function IllusionFixer:OnNPCSpawned(keys)
    local illusion = EntIndexToHScript(keys.entindex);

    if not illusion or illusion:IsNull() then
        return;
    end

    if not (illusion:IsIllusion() or illusion:IsTempestDouble()) then
        return;
    end

    Timers:CreateTimer(0.05, function()
        local illusionModifier = illusion:FindModifierByName('modifier_illusion')
                or illusion:FindModifierByName('modifier_arc_warden_tempest_double');

        PrintTable(illusionModifier);
        if not illusionModifier then
            return;
        end

        local heroEntity = illusionModifier:GetCaster();

        if not heroEntity then
            return;
        end

        IllusionFixer:InitIllusion(illusion, illusionModifier);
    end);
end

function IllusionFixer:InitIllusion(illusion, illusionModifier)

    local heroEntity = illusionModifier:GetCaster();

    for i = 0, 24 do
        local ability = illusion:GetAbilityByIndex(i);
        if ability and not string.find(ability:GetAbilityName(), 'special_bonus') then
            illusion:RemoveAbility(ability:GetAbilityName());
        end
    end

    for i = 0, 24 do
        local ability = heroEntity:GetAbilityByIndex(i);
        if ability then
            local abilityName = ability:GetAbilityName();
            local addAbility = not string.find(abilityName, 'special_bonus')
                and not IllusionFixer.abilityException[abilityName]
                and not (illusion:HasModifier('modifier_phantom_lancer_juxtapose_illusion')
                        and IllusionFixer.juxtaposeException[abilityName]);

            if addAbility then
                local newAbility = illusion:AddAbility(abilityName);
                local level = ability:GetLevel();

                AbilityUtils:FixAbility(illusion, abilityName);
                newAbility:SetHidden(ability:IsHidden());

                if level > 0 then
                    newAbility:SetLevel(level);
                end

                if abilityName == 'arc_warden_tempest_double' then
                    newAbility:SetActivated(false);
                end
            end
        end
    end

    if illusion.IsTempestDouble and illusion:IsTempestDouble() then
        while illusion:FindItemInInventory('item_manta') do
            local item = illusion:FindItemInInventory('item_manta');
            if item and not item:IsNull() then
                illusion:RemoveItem(item);
            end
        end
    end
end