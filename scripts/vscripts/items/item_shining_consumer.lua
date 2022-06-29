function ConsumeShining(keys)
    local caster = keys.caster;

    if caster:IsRealHero() then

        local ability = keys.ability;
        local modifierName = keys.ModifierName;
        local playerEntity = Players:GetPlayerEntity(caster:GetPlayerID());

        if not caster:HasModifier(modifierName) then
            ability:RemoveSelf();
            caster:AddNewModifier(caster, nil, modifierName, {});
            EmitSoundOnClient('Item.MoonShard.Consume', playerEntity);
        end
    end
end