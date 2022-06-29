require('modifiers/modifier_base');

ModifierAncientStartItemBase = class({}, nil, ModifierBase);
setmetatable(ModifierAncientStartItemBase, { __index = ModifierBase });

function ModifierAncientStartItemBase:Init(keys)
    keys = keys or {};

    ModifierBase.Init(self, {
        isHidden = true,
    });
    inherit(self, ModifierAncientStartItemBase);

    self.bonusesOrder = keys.bonusesOrder;
end

function ModifierAncientStartItemBase:OnCreated(kv)
    self.bonuses = {
        self:GetItemSpecialValue('primary_attribute_bonus'),
        self:GetItemSpecialValue('secondary_attribute_bonus'),
        self:GetItemSpecialValue('tertiary_attribute_bonus'),
    };
    self.clockTime = self:GetItemSpecialValue('clock_time');
end

function ModifierAncientStartItemBase:GetTimeMultiplier()
    local minute = math.floor(GameRules:GetDOTATime(false, false) / 60);
    return minute >= self.clockTime and 2 or 1;
end

function ModifierAncientStartItemBase:GetModifierBonusStats_Strength()
    return self.bonuses[table.indexOf(self.bonusesOrder, 'strength')];
end

function ModifierAncientStartItemBase:GetModifierBonusStats_Agility()
    return self.bonuses[table.indexOf(self.bonusesOrder, 'agility')];
end

function ModifierAncientStartItemBase:GetModifierBonusStats_Intellect()
    return self.bonuses[table.indexOf(self.bonusesOrder, 'intellect')];
end

---------------------------------------------------------------------------------------------------

ModifierAncientStartItemActiveBase = class({}, nil, ModifierBase);
setmetatable(ModifierAncientStartItemActiveBase, { __index = ModifierBase });

function ModifierAncientStartItemActiveBase:Init(keys)
    keys = keys or {};

    ModifierBase.Init(self, {
        removeOnDeath = true,
        isHidden = false,
        isDebuff = false,
        isPurgable = false,
    });
    inherit(self, ModifierAncientStartItemActiveBase);
end

function ModifierAncientStartItemActiveBase:OnCreated(kv)
    self.clockTime = self:GetItemSpecialValue('clock_time');
end

function ModifierAncientStartItemActiveBase:GetTimeMultiplier()
    local minute = math.floor(GameRules:GetDOTATime(false, false) / 60);
    return minute >= self.clockTime and 2 or 1;
end
