require('internal/util');
require('util');
require('modifiers/declared_functions');

ModifierBase = class({});

function ModifierBase:Init(keys)
    keys = keys or {};
    inherit(self, ModifierBase);

    local function DeclareGetter(instance, getter, field)
        if keys[field] ~= nil then
            instance[field] = keys[field];
            instance[getter] = function()
                return instance[field];
            end
            return;
        end
        local func = getmetatable(instance).__index[getter];
        if type(func) == 'function' then
            instance[getter] = function()
                return func(instance);
            end;
        end
    end

    DeclareGetter(self, 'IsPermanent', 'isPermanent');
    DeclareGetter(self, 'RemoveOnDeath', 'removeOnDeath');
    DeclareGetter(self, 'IsHidden', 'isHidden');
    DeclareGetter(self, 'IsDebuff', 'isDebuff');
    DeclareGetter(self, 'IsPurgable', 'isPurgable');
    DeclareGetter(self, 'GetAttributes', 'attributes');
    DeclareGetter(self, 'GetTexture', 'texture');
end

function ModifierBase:GetItemSpecialValue(valueName)
    local item = self:GetAbility();
    local itemName = item:GetAbilityName();
    return GetItemSpecialValue(itemName, valueName);
end

function ModifierBase:DeclareFunctions()
    if self.declaredFunctions == nil then
        self.declaredFunctions = GetDeclaredFunctions(self);
    end
    return self.declaredFunctions;
end

function ModifierBase:OnTooltip()
    self.tooltipCounter = 1;
    return self:GetTooltip(1);
end

function ModifierBase:OnTooltip2()
    self.tooltipCounter = self.tooltipCounter + 1;
    return self:GetTooltip(self.tooltipCounter);
end

function ModifierBase:GetTooltips()
    return {};
end

function ModifierBase:GetTooltip(number)
    local tooltips = self:GetTooltips();
    if tooltips and tooltips[number] then
        return tooltips[number];
    end
    return nil;
end