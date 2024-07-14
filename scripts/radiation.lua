local script_path = mod_loader.mods[modApi.currentMod].scriptPath
local resource_path = mod_loader.mods[modApi.currentMod].resourcePath
local trait = require(script_path .."libs/trait")

local function IsIrradiated(point)
	if not Board:IsPawnSpace(point) then return false end

	if GetCurrentMission() then
		if not GetCurrentMission().irradiated_targets then
			GetCurrentMission().irradiated_targets = {}
		end

		if GetCurrentMission().irradiated_targets[Board:GetPawn(point):GetId()] then return true end
	end

	return false
end

local traitfunc_radiation = function(trait, pawn)
	return IsIrradiated(pawn:GetSpace())
end

trait:add {
    func = traitfunc_radiation,
    icon = resource_path.."img/effects/icon_radiation.png",
    icon_glow = resource_path.."img/effects/icon_radiation.png",
    desc_title = "Radiation",
    desc_text = "This unit will take 1 damage for every other 2 irradiated units at the start of next turn."
}

-- hook for the post-environment phase
local function DoRadiationDamage(mission)
    if GetCurrentMission() then
        local irradiated_targets = GetCurrentMission().irradiated_targets
        if irradiated_targets then

            local targets_count = 0
            for k, v in pairs(irradiated_targets) do
                targets_count = targets_count + 1
            end

            local damage_amount = math.floor(targets_count / 2)
            
            local effect = SkillEffect()
            effect:AddDamage(SpaceDamage(Point(0,0))) -- make sure effect isn't empty

            for k, v in pairs(irradiated_targets) do
                local pawn = Board:GetPawn(k)
                if pawn then

                    local health = pawn:GetHealth()
                    effect:AddBoardShake(0.3)
                    effect:AddAnimation(pawn:GetSpace(), "radiation_boom", ANIM_NO_DELAY)
                    effect:AddSound((_G[pawn:GetType()].SoundLocation).."hurt")
                    effect:AddScript([[
                        local p = Board:GetPawn(]] ..k.. [[)
                        p:SetHealth(]] ..(health - damage_amount).. [[)
                        Board:AddAlert(p:GetSpace(), "Radiation Damage")
                    ]])
                    effect:AddDelay(1.2)
                end
            end

            Board:AddEffect(effect)
            
            LOG("Radiation targets: "..targets_count.." Radiation level: "..damage_amount)
        end
    end
end

return {
    DoRadiationDamage = DoRadiationDamage,
    IsIrradiated = IsIrradiated
}