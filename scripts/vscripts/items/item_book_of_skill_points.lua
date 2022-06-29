function ConsumeBook(keys)
    local caster = keys.caster;

    if caster:IsRealHero() and caster == PlayerResource:GetSelectedHeroEntity(caster:GetPlayerID()) then

        local ability = keys.ability;
        local charges = ability:GetCurrentCharges();
        local playerEntity = Players:GetPlayerEntity(caster:GetPlayerID());

        caster:SetAbilityPoints(caster:GetAbilityPoints() + 1);

        if charges > 1 then
            ability:SetCurrentCharges(charges - 1);
        else
            ability:RemoveSelf();
        end

        EmitSoundOnClient('Item.TomeOfKnowledge', playerEntity);
    end
end