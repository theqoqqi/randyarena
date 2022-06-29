if IsServer() then

    function CDOTA_BaseNPC:GetStatusResistanceMultiplier()
        local reduction = self:GetStatusResistance();
        return math.max(1 - reduction, 0);
    end
end