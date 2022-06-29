require('modifiers/modifier_base');

LinkLuaModifier('modifier_holy_shining', 'modifiers/holy_shining.lua', LUA_MODIFIER_MOTION_NONE);

modifier_holy_shining = class({}, nil, ModifierBase);

modifier_holy_shining:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = false,
    texture = 'item_holy_locket',
});

function modifier_holy_shining:OnCreated(kv)
    self.healIncrease = GetItemSpecialValue('item_holy_locket', 'heal_increase');
    self.maxCharges = GetItemSpecialValue('item_holy_locket', 'max_charges');
    self.chargeRadius = GetItemSpecialValue('item_holy_locket', 'charge_radius');
    self.restorePerCharge = GetItemSpecialValue('item_holy_locket', 'restore_per_charge');
    self.healthThreshold = 25;
    self.rechargeDuration = 13;

    self.magicStickMaxCharges = GetItemSpecialValue('item_magic_stick', 'max_charges');
    self.magicWandMaxCharges = GetItemSpecialValue('item_magic_wand', 'max_charges');

    if IsServer() and kv then
        self:SetStackCount(kv.charges or 0);
    end
end

function modifier_holy_shining:OnDestroy()
    if not IsServer() then
        return;
    end

    local parent = self:GetParent();
    local kv = {
        charges = self:GetStackCount(),
    };

    if parent:IsAlive() then
        parent:AddNewModifier(parent, nil, 'modifier_holy_shining', kv);
    else
        local respawnListener;
        respawnListener = ListenToGameEvent('npc_spawned', function (event)
            local unit = EntIndexToHScript(event.entindex);
            if unit == parent then
                parent:AddNewModifier(parent, nil, 'modifier_holy_shining', kv);
                StopListeningToGameEvent(respawnListener);
            end
        end, nil);
    end
end

function modifier_holy_shining:IsDebuff()
    return self:GetParent():HasModifier('modifier_item_holy_locket');
end

function modifier_holy_shining:OnAbilityFullyCast(event)
    local parent = self:GetParent();
    local ability = event.ability;
    local caster = event.unit;

    -- хз как проверить, были ли потрачены заряды стиков или они были прожаты без зарядов.
    -- ability:GetCurrentCharges() возвращает 0 в любом случае

    if caster == parent and self:IsMagicStickItem(ability) then
        self:SetDuration(self.rechargeDuration, true);
    end
end

function modifier_holy_shining:OnAbilityStart(event)
    if not IsServer() then
        return;
    end

    local parent = self:GetParent();
    local ability = event.ability;
    local caster = event.unit;

    if self:HasChargeableMagicStick() then
        return;
    end

    local charges = self:GetStackCount();
    local procsCharge = charges < self.maxCharges
        and ability:ProcsMagicStick()
        and caster:IsRealHero()
        and not caster:IsTempestDouble()
        and parent:GetTeamNumber() ~= caster:GetTeamNumber()
        and (parent:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() <= self.chargeRadius
        and parent:CanEntityBeSeenByMyTeam(caster);

    if procsCharge then
        self:SetStackCount(charges + 1);
    end
end

function modifier_holy_shining:IsMagicStickItem(item)
    if item == nil then
        return false;
    end
    local itemName = item:GetAbilityName();
    return self:IsMagicStickItemName(itemName);
end

function modifier_holy_shining:IsMagicStickItemName(itemName)
    return itemName == 'item_magic_stick'
        or itemName == 'item_magic_wand'
        or itemName == 'item_holy_locket';
end

function modifier_holy_shining:HasChargeableMagicStick()
    local parent = self:GetParent();
    for i=0,5 do
        local item = parent:GetItemInSlot(i);
        if self:IsChargeableMagicStickItem(item) then
            return true;
        end
    end
    return false;
end

function modifier_holy_shining:IsChargeableMagicStickItem(item)
    local parent = self:GetParent();

    if not parent:HasModifier('modifier_item_holy_locket')
            and not parent:HasModifier('modifier_item_magic_stick')
            and not parent:HasModifier('modifier_item_magic_wand') then
        return false;
    end

    if item == nil then
        return false;
    end

    local charges = item:GetCurrentCharges();
    local itemName = item:GetAbilityName();

    if itemName == 'item_magic_stick' and charges < self.magicStickMaxCharges then
        return true;
    end
    if itemName == 'item_magic_wand' and charges < self.magicWandMaxCharges then
        return true;
    end
    if itemName == 'item_holy_locket' and charges < self.maxCharges then
        return true;
    end

    return false;
end

function modifier_holy_shining:OnTakeDamage(event)
    if not IsServer() then
        return;
    end

    local parent = self:GetParent();
    local charges = self:GetStackCount();

    local useCharges = charges > 0
        and self:GetDuration() == -1
        and event.unit == parent
        and parent:IsAlive()
        and parent:GetHealth() <= parent:GetMaxHealth() * self.healthThreshold / 100;

    if useCharges then
        local restore = charges * self.restorePerCharge;
        local playerEntity = parent:GetPlayerOwner();

        parent:Heal(restore, self:GetAbility());
        parent:GiveMana(restore);

        SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, parent, restore, playerEntity);
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, restore, playerEntity);

        self:SetParentStickItemsToCooldown();

        self:SetStackCount(0);
        self:SetDuration(self.rechargeDuration, true);
        self:PlayEffects(parent);
    end
end

function modifier_holy_shining:SetParentStickItemsToCooldown()
    local parent = self:GetParent();
    local item = parent:FindItemInInventory('item_magic_stick');
    if item then
        item:StartCooldown(self.rechargeDuration);
        return;
    end

    item = parent:FindItemInInventory('item_magic_wand');
    if item then
        item:StartCooldown(self.rechargeDuration);
        return;
    end

    item = parent:FindItemInInventory('item_holy_locket');
    if item then
        item:StartCooldown(self.rechargeDuration);
        return;
    end
end

function modifier_holy_shining:GetModifierHPRegenAmplify_Percentage()
    local parent = self:GetParent();
    if parent:HasModifier('modifier_item_holy_locket') then
        return;
    end
    return self.healIncrease;
end

function modifier_holy_shining:GetModifierHealAmplify_PercentageTarget()
    local parent = self:GetParent();
    if parent:HasModifier('modifier_item_holy_locket') then
        return;
    end
    return self.healIncrease;
end

function modifier_holy_shining:PlayEffects(target)
    local particleName = 'particles/items_fx/year_beast_refresher.vpcf';

    local particleId = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target);
    ParticleManager:SetParticleControl(particleId, 1, target:GetOrigin());
    ParticleManager:ReleaseParticleIndex(particleId);

    EmitSoundOn('DOTA_Item.MagicWand.Activate', target);
end

function modifier_holy_shining:GetTooltips()
    return {
        self.healthThreshold,
        self.restorePerCharge,
        self.maxCharges,
        self.chargeRadius,
    };
end