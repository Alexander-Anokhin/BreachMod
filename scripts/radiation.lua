local script_path = mod_loader.mods[modApi.currentMod].scriptPath
local resource_path = mod_loader.mods[modApi.currentMod].resourcePath
local trait = require(script_path .."libs/trait")
local customAnim = require(script_path .."libs/customAnim")

trait:add {
    func = traitfunc_radiation,
    icon = resource_path.."img/effects/icon_radiation.png",
    icon_glow = resource_path.."img/effects/icon_radiation.png",
    desc_title = "Radiation",
    desc_text = "This unit will take 1 damage for every other 2 irradiated units at the start of next turn."
}

local traitfunc_radiation = function(trait, pawn)
	return IsIrradiated(pawn:GetSpace())
end

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

local function AttachIrradiatedAnimation(id)
	customAnim:add(id, "irradiated_loop")
end

-- hook for the pre-environment phase
local function DoRadiationDamage(mission)
    if GetCurrentMission() then
        local irradiated_targets = GetCurrentMission().irradiated_targets
        if irradiated_targets then

            local targets_count = 0
            for k, v in pairs(irradiated_targets) do
                targets_count = targets_count + 1
            end

            damage_amount = 0--math.floor(targets_count / 2)
            
            for k, v in pairs(irradiated_targets) do
                local pawn = Board:GetPawn(k)
                if pawn then
                    
                    local effect = SkillEffect()
                    local health = pawn:GetHealth()
                    effect:AddScript([[
                        local p = Board:GetPawn(]] ..k.. [[)
                        p:SetHealth(]] ..(health - 1).. [[)
                    ]])
                    effect:AddSound((_G[pawn:GetType()].SoundLocation).."hurt")
					--effect:AddBoardShake(0.3)
                    Board:AddEffect(effect)
                    Board:AddAlert(pawn:GetSpace(), "Radiation Damage")
                    Board:AddAnimation(pawn:GetSpace(), "radiation_boom", ANIM_NO_DELAY)
                end
            end

            LOG("Radiation targets: "..targets_count.." Radiation level: "..damage_amount)
        end
    end
end