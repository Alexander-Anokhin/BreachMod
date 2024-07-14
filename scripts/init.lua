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
    require(self.scriptPath.."radiation")

    modApi:appendAsset("img/combat/icon_bishop_move.png", self.resourcePath.."img/combat/icon_bishop_move.png")
    modApi:appendAsset("img/effects/icon_radiation.png", self.resourcePath.."img/effects/icon_radiation.png")
    modApi:appendAsset("img/effects/icon_radiation_glow.png", self.resourcePath.."img/effects/icon_radiation_glow.png")
    Location["effects/icon_radiation_glow.png"] = Point(0,0)
    modApi:appendAsset("img/weapons/tosx_weapon_needle.png", self.resourcePath.."img/weapons/tosx_weapon_needle.png")
    modApi:appendAsset("img/effects/tosx_loop2.png", self.resourcePath.."img/effects/tosx_loop2.png")
    modApi:appendAsset("img/effects/tosx_loop2a.png", self.resourcePath.."img/effects/tosx_loop2a.png")
    modApi:appendAsset("img/effects/explo_radpulse1.png", self.resourcePath.."img/effects/explo_radpulse1.png")
end

ANIMS.irradiated_loop = Animation:new {
    Image = "effects/tosx_loop2.png",
    NumFrames = 8,
	Time = 0.08,
	PosX = -33,
	PosY = -14,
	Loop = true
}

ANIMS.radiation_boom = Animation:new{
	Image = "effects/explo_radpulse1.png",
	NumFrames = 8,
	Time = 0.05,
	PosX = -33,
	PosY = -14
}

function mod:load(options, version)
    local radiation_controller = require(self.scriptPath.."radiation")
    modApi:addPostEnvironmentHook(radiation_controller.DoRadiationDamage)
end

return mod
