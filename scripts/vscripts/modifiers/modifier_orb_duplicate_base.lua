require('modifiers/modifier_base');

ModifierOrbDuplicateBase = class({}, nil, ModifierBase);
setmetatable(ModifierOrbDuplicateBase, { __index = ModifierBase });

function ModifierOrbDuplicateBase:Init(keys)
    keys = keys or {};

    ModifierBase.Init(self, keys);
    inherit(self, ModifierOrbDuplicateBase);

    self.originalItemModifierName = keys.originalItemModifierName;
    self.originalEffectModifierName = keys.originalEffectModifierName;
    self.replacingEffectModifierName = keys.replacingEffectModifierName;
    self.attackLandedSoundName = keys.attackLandedSoundName;
end

function ModifierOrbDuplicateBase:OnCreated()
    self.attackRecords = {};
end

function ModifierOrbDuplicateBase:OnDestroy()
    if not IsServer() then
        return;
    end

    local parent = self:GetParent();
    local kv = {
        originalItemModifierName = self.originalItemModifierName,
        originalEffectModifierName = self.originalEffectModifierName,
        replacingEffectModifierName = self.replacingEffectModifierName,
        attackLandedSoundName = self.attackLandedSoundName,
    };

    parent:AddNewModifier(parent, nil, self:GetName(), kv);
end

function ModifierOrbDuplicateBase:IsDebuff()
    return self:GetParent():HasModifier(self.originalItemModifierName);
end

function ModifierOrbDuplicateBase:OnAttackRecord(keys)
    local parent = self:GetParent();
    if parent:HasModifier(self.originalItemModifierName) or keys.attacker ~= parent then
        return;
    end
    self.attackRecords[keys.record] = true;
end

function ModifierOrbDuplicateBase:OnAttackRecordDestroy(keys)
    self.attackRecords[keys.record] = nil;
end

function ModifierOrbDuplicateBase:OnAttackLanded(keys)
    if not IsServer() then
        return;
    end

    local parent = self:GetParent();
    local target = keys.target;

    if target == nil or target:GetTeamNumber() == parent:GetTeamNumber() then
        return;
    end

    if self:GetDuration() ~= -1 then
        return;
    end

    if not self.attackRecords[keys.record] or parent:IsIllusion() then
        return;
    end

    if target:HasModifier(self.originalEffectModifierName) then
        parent:RemoveModifierByName(self.originalEffectModifierName);
    end

    local duration = self:GetEffectDuration() * target:GetStatusResistanceMultiplier();
    local cooldown = self:GetCooldown() * parent:GetCooldownReduction();

    target:AddNewModifier(parent, nil, self.replacingEffectModifierName, {
        orbModifierName = self:GetName(),
        duration = duration,
    });

    if self.attackLandedSoundName then
        keys.target:EmitSound(self.attackLandedSoundName);
    end

    if cooldown > 0 then
        self:SetDuration(cooldown, true);
    end
end

function ModifierOrbDuplicateBase:OnModifierAdded(keys)
    if not IsServer() then
        return;
    end

    local target = keys.unit;

    if target == nil then
        return;
    end

    local originalModifier = target:FindModifierByName(self.originalEffectModifierName);
    local replacingModifier = target:FindModifierByName(self.replacingEffectModifierName);

    if originalModifier and replacingModifier then
        local originalDuration = originalModifier:GetRemainingTime();
        local replacingDuration = replacingModifier:GetRemainingTime();
        local durationToSet = math.max(originalDuration, replacingDuration);

        originalModifier:Destroy();
        replacingModifier:SetDuration(durationToSet, true);
    end
end

function ModifierOrbDuplicateBase:GetEffectDuration()
    return 0;
end

function ModifierOrbDuplicateBase:GetCooldown()
    return 0;
end



ModifierOrbDuplicateEffectBase = class({}, nil, ModifierBase);
setmetatable(ModifierOrbDuplicateEffectBase, { __index = ModifierBase });

function ModifierOrbDuplicateEffectBase:Init(keys)
    keys = keys or {};

    ModifierBase.Init(self, keys);
    inherit(self, ModifierOrbDuplicateEffectBase);
end

function ModifierOrbDuplicateEffectBase:OnCreated(kv)
    if IsServer() then
        print('OnCreated');
        PrintTable(kv);
        self.orbModifierName = kv.orbModifierName;
        self:StartIntervalThink(0.05);
    end
end

function ModifierOrbDuplicateEffectBase:OnIntervalThink()
    if not IsServer() then
        return;
    end

    local parent = self:GetParent();
    local caster = self:GetCaster();

    local orbModifier = caster:FindModifierByName(self.orbModifierName);

    if parent:HasModifier(orbModifier.originalEffectModifierName) then
        parent:RemoveModifierByName(orbModifier.originalEffectModifierName);
    end
end