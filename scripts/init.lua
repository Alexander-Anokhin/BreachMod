local description = "CyberKn1ght test mod"

local mod = {
    id = "Cyber_test",
    name = "Cyber test mod",
    version = "1.2",
    modApiVersion = "2.9.2",
    gameVersion = "1.2.88",
    icon = "img/mod_icon.png",
    description = description,
}

function mod:init()
    require(self.scriptPath.."weapons")

    modApi:appendAsset("img/combat/icon_bishop_move.png", self.resourcePath.."img/combat/icon_bishop_move.png")
    modApi:appendAsset("img/effects/icon_radiation.png", self.resourcePath.."img/effects/icon_radiation.png")
    modApi:appendAsset("img/effects/icon_radiation_glow.png", self.resourcePath.."img/effects/icon_radiation_glow.png")
    Location["effects/icon_radiation_glow.png"] = Point(0,0)
    modApi:appendAsset("img/weapons/tosx_weapon_needle.png", self.resourcePath.."img/weapons/tosx_weapon_needle.png")
    modApi:appendAsset("img/effects/tosx_loop2.png", self.resourcePath.."img/effects/tosx_loop2.png")
    modApi:appendAsset("img/effects/tosx_loop2a.png", self.resourcePath.."img/effects/tosx_loop2a.png")
end

ANIMS.irradiated_loop = Animation:new {
    Image = "effects/tosx_loop2.png",
    NumFrames = 8,
	Time = 0.08,
	PosX = -33,
	PosY = -14,
	Loop = true
}

local function radiationDamageHook(mission)
    LOG("Radiation!!!!")
    if GetCurrentMission() then
        local irradiated_targets = GetCurrentMission().irradiated_targets
        if irradiated_targets then

            targets_count = 0
            for k, v in pairs(irradiated_targets) do
                targets_count = targets_count + 1
            end

            damage_amount = math.floor(targets_count / 2)
            
            local effect = SkillEffect()
            effect:AddDamage(SpaceDamage(Point(0,0))) -- make sure effect isnt empty
            
            for k, v in pairs(irradiated_targets) do
                pawn = Board:GetPawn(k)
                if pawn then
                    local damage = SpaceDamage(pawn:GetSpace(), damage_amount)
                    damage.sSound = "/mech/science/mech/death"
                    effect:AddDamage(damage)
                end
            end

            Board:AddEffect(effect)

            LOG("Radiation targets: "..targets_count.." Radiation level: "..damage_amount)
        end
    end
end

function mod:load(options, version)
    modApi:addPreEnvironmentHook(radiationDamageHook)
end

return mod
