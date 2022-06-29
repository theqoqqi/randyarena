require('modifiers/modifier_base');

LinkLuaModifier('modifier_bonus_strength', 'modifiers/bonus_stats.lua', LUA_MODIFIER_MOTION_NONE);

modifier_bonus_strength = class({}, nil, ModifierBase);
modifier_bonus_strength:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = false,
    isDebuff = false,
    texture = 'item_book_of_strength',
});

function modifier_bonus_strength:GetModifierBonusStats_Strength()
    return self:GetStackCount();
end

---------------------------------------------------------------------------------------------------

LinkLuaModifier('modifier_bonus_agility', 'modifiers/bonus_stats.lua', LUA_MODIFIER_MOTION_NONE);

modifier_bonus_agility = class({}, nil, ModifierBase);
modifier_bonus_agility:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = false,
    isDebuff = false,
    texture = 'item_book_of_agility',
});

function modifier_bonus_agility:GetModifierBonusStats_Agility()
    return self:GetStackCount();
end

---------------------------------------------------------------------------------------------------

LinkLuaModifier('modifier_bonus_intelligence', 'modifiers/bonus_stats.lua', LUA_MODIFIER_MOTION_NONE);

modifier_bonus_intelligence = class({}, nil, ModifierBase);
modifier_bonus_intelligence:Init({
    isPermanent = true,
    removeOnDeath = false,
    isHidden = false,
    isDebuff = false,
    texture = 'item_book_of_intelligence',
});

function modifier_bonus_intelligence:GetModifierBonusStats_Intellect()
    return self:GetStackCount();
end

---------------------------------------------------------------------------------------------------

LinkLuaModifier('modifier_dummy', 'modifiers/bonus_stats.lua', LUA_MODIFIER_MOTION_NONE);

modifier_dummy = class({});