require('util');
require('modifiers/declared_functions');

ItemBase = class({});

function ItemBase:Init(keys)
    keys = keys or {};
    inherit(self, ItemBase);

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

    DeclareGetter(self, 'IsStealable', 'isStealable');
    DeclareGetter(self, 'IsRefreshable', 'isRefreshable');
    DeclareGetter(self, 'GetBehavior', 'behavior');
    DeclareGetter(self, 'GetChannelTime', 'channelTime');
    DeclareGetter(self, 'GetAOERadius', 'aoeRadius');
    DeclareGetter(self, 'GetIntrinsicModifierName', 'intrinsicModifierName');
    DeclareGetter(self, 'GetPlaybackRateOverride', 'playbackRateOverride');
    DeclareGetter(self, 'ProcsMagicStick', 'procsMagicStick');
end

function ItemBase:GetAbilityTextureName(brokenAPI)
    return self.BaseClass.GetAbilityTextureName(self);
end

function ItemBase:GetCooldown(nLevel)
    return self.BaseClass.GetCooldown(self, nLevel);
end