local mod = {
    id = "Cyber_test",
    name = "Cyber test mod",
    version = "1.2",
    modApiVersion = "2.9.2",
    gameVersion = "1.2.88",
    icon = "img/mod_icon.png",
    description = "CyberKn1ght test mod",
}

function mod:init()
    require(self.scriptPath.."weapons")
    require(self.scriptPath.."pawns")
    require(self.scriptPath.."radiation")
    require(self.scriptPath.."animations")

    modApi:appendAsset("img/combat/icon_bishop_move.png", self.resourcePath.."img/combat/icon_bishop_move.png")
    modApi:appendAsset("img/effects/icon_radiation.png", self.resourcePath.."img/effects/icon_radiation.png")
    Location["effects/icon_radiation.png"] = Point(0,0)
    modApi:appendAsset("img/effects/icon_radiation_glow.png", self.resourcePath.."img/effects/icon_radiation_glow.png")
    Location["effects/icon_radiation_glow.png"] = Point(0,0)
    modApi:appendAsset("img/weapons/tosx_weapon_needle.png", self.resourcePath.."img/weapons/tosx_weapon_needle.png")
    modApi:appendAsset("img/effects/tosx_loop2.png", self.resourcePath.."img/effects/tosx_loop2.png")
    modApi:appendAsset("img/effects/tosx_loop2a.png", self.resourcePath.."img/effects/tosx_loop2a.png")
    modApi:appendAsset("img/effects/explo_radpulse1.png", self.resourcePath.."img/effects/explo_radpulse1.png")

    modApi:appendAsset("img/effects/explo_radpush_D.png", self.resourcePath.."img/effects/explo_radpush_D.png")
    modApi:appendAsset("img/effects/explo_radpush_L.png", self.resourcePath.."img/effects/explo_radpush_L.png")
    modApi:appendAsset("img/effects/explo_radpush_R.png", self.resourcePath.."img/effects/explo_radpush_R.png")
    modApi:appendAsset("img/effects/explo_radpush_U.png", self.resourcePath.."img/effects/explo_radpush_U.png")

end

function mod:load(options, version)
    local radiation = require(self.scriptPath.."radiation")
    modApi:addPostEnvironmentHook(radiation.DoRadiationDamage)
    modapiext:addPawnHealedHook(radiation.RepairRadiation)

    modApi:addSquad(
		{
			"Atomic Desolators",
			"Reactor_Mech",
			"Radiation_Mech",
			"Contamination_Mech"
		},
		"Atomic Desolators",
		"A squad focused around spreading radiation to their enemies.",
		self.resourcePath .."img/mod_icon.png"
	)
end

return mod
