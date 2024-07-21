local script_path = mod_loader.mods[modApi.currentMod].scriptPath
local resource_path = mod_loader.mods[modApi.currentMod].resourcePath
local trait = require(script_path .."libs/trait")
local customAnim = require(script_path .."libs/customAnim")

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

-- hook for onMissionUpdate
--[[
local function RepairRadiation(mission)
	if Game:GetEventCount(32) > 0 then
		LOG("MECH REPAIR!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	end
end
]]--
local function CountIrradiatedTargets()
    local targets_count = 0
    if GetCurrentMission() then
        if GetCurrentMission().irradiated_targets then
            for k, v in pairs(GetCurrentMission().irradiated_targets) do
                targets_count = targets_count + 1
            end
        end
    end
    return targets_count
end

-- hook for the post-environment phase
local function DoRadiationDamage(mission)

    local targets_count = CountIrradiatedTargets()
    local damage_amount = math.floor(targets_count / 2)

    if targets_count > 0 and damage_amount > 0 then

        local irradiated_targets = GetCurrentMission().irradiated_targets
        local effect = SkillEffect()
        effect:AddDamage(SpaceDamage(Point(0,0))) -- make sure effect isn't empty

        for k, v in pairs(irradiated_targets) do
            local pawn = Board:GetPawn(k)
            if pawn then
                if IsPassiveSkill("Radiation_Immunity") and pawn:IsMech() and not pawn:IsEnemy() then
                    -- pawn is immune to radiation
                    effect:AddAnimation(pawn:GetSpace(), "radiation_boom", ANIM_NO_DELAY)
                    effect:AddSound("/ui/battle/resisted")
                    effect:AddScript([[
                        local p = Board:GetPawn(]] ..k.. [[)
                        Board:AddAlert(p:GetSpace(), "Immune")
                    ]])
                    effect:AddDelay(1.2)
                else
                    -- deal radiation damage as normal
                    local health = pawn:GetHealth()
                    effect:AddBoardShake(0.3)
                    effect:AddAnimation(pawn:GetSpace(), "radiation_boom", ANIM_NO_DELAY)

                    if (health - damage_amount <= 0) then
                        -- death sound
                        effect:AddSound((_G[pawn:GetType()].SoundLocation).."death")
                    else
                        -- hurt sound
                        effect:AddSound((_G[pawn:GetType()].SoundLocation).."hurt")
                    end
                    
                    effect:AddScript([[
                        local p = Board:GetPawn(]] ..k.. [[)
                        p:SetHealth(]] ..(health - damage_amount).. [[)
                        Board:AddAlert(p:GetSpace(), "Radiation Damage")
                    ]])
                    effect:AddDelay(1.2)
                end
            end
        end

        Board:AddEffect(effect)
        
        LOG("Radiation targets: "..targets_count.." Radiation level: "..damage_amount)

    end
end

-- hook for pawnHealedHook
local function RepairRadiation(mission, pawn, healingTaken)
    if pawn:IsMech() and not pawn:IsEnemy() then
        if GetCurrentMission() then
            if GetCurrentMission().irradiated_targets then
                if GetCurrentMission().irradiated_targets[pawn:GetId()] then
                    -- remove radiation
                    GetCurrentMission().irradiated_targets[pawn:GetId()] = nil
                    trait:update(pawn:GetSpace())
                    customAnim:rem(pawn:GetId(), "irradiated_loop", "")
                end
            end
        end
    end
end

-- hook for pawnKilledHook
local function RemoveRadiation(mission, pawn)
    if GetCurrentMission() then
        if GetCurrentMission().irradiated_targets then
            GetCurrentMission().irradiated_targets[pawn:GetId()] = nil
        end
    end
end

return {
    CountIrradiatedTargets = CountIrradiatedTargets,
    DoRadiationDamage = DoRadiationDamage,
    RepairRadiation = RepairRadiation,
    IsIrradiated = IsIrradiated,
    RemoveRadiation = RemoveRadiation
}