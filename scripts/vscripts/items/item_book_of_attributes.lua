function ApplyBonusAttribute(keys)
    local caster = keys.caster;

    if caster:IsRealHero() then

        local ability = keys.ability;
        local modifierName = keys.ModifierName;
        local bonusAmount = keys.BonusAmount;
        local charges = ability:GetCurrentCharges();
        local playerEntity = Players:GetPlayerEntity(caster:GetPlayerID());

        AddBonusAttribute(caster, ability, modifierName, bonusAmount);

        if charges > 1 then
            ability:SetCurrentCharges(charges - 1);
        else
            ability:RemoveSelf();
        end

        EmitSoundOnClient('Item.TomeOfKnowledge', playerEntity);
    end
end