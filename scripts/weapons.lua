local script_path = mod_loader.mods[modApi.currentMod].scriptPath
local radiation = require(script_path .."radiation")
local customAnim = require(script_path .."libs/customAnim")

function AttachIrradiatedAnimation(id)
	customAnim:add(id, "irradiated_loop")
end

Test_Punch = Skill:new {
    Name = "Test Punch",
    Description = "The testest of punches",
    Class = "",
    Icon = "combat/icon_bishop_move.png",
    Rarity = 1,
    Explosion = "",
    LaunchSound = "/weapons/titan_fist",
	Range = 1, -- Tooltip?
	PathSize = 1,
	Damage = 0,
	PushBack = false,
	Flip = true,
	Dash = false,
	Shield = false,
	Projectile = false,
	Push = 1, --Mostly for tooltip, but you could turn it off for some unknown reason
	PowerCost = 0, --AE Change
	Upgrades = 0,
	--UpgradeList = { "Dash",  "+2 Damage"  },
	--UpgradeCost = { 2 , 3 },
	TipImage = StandardTips.Melee
}

function Test_Punch:GetSkillEffect(p1, p2)
    local ret = SkillEffect()
    local direction = GetDirection(p2 - p1)
	local damage = SpaceDamage(p2, self.Damage, direction)

	if Board:IsPawnSpace(p2) then

		-- Apply radiation
		if not radiation.IsIrradiated(p2) then
			local target_id = Board:GetPawn(p2):GetId()
			ret:AddScript([[
				AttachIrradiatedAnimation(]] ..target_id.. [[)
				GetCurrentMission().irradiated_targets[]] ..target_id.. [[] = 10
			]])
		end

		-- Custom status preview icon
		damage.sImageMark = "effects/icon_radiation_glow.png"
	end

	ret:AddMelee(p1, damage)

    return ret
end

Toxic_Missile = TankDefault:new {
	Name = "Toxic Missile",
	Description = "Irradiate and push a target.",
	Class = "Brute",
	Damage = 0,
	Icon = "weapons/brute_tankmech.png",
	Explosion = "",
	Sound = "/general/combat/explode_small",
	Projectile = "effects/shot_mechtank",
	PowerCost = 0,
	Upgrades = 1,
	UpgradeCost = {2},
	LaunchSound = "/weapons/modified_cannons",
	ImpactSound = "/impact/generic/explosion",
	TipImage = StandardTips.Ranged,
	ZoneTargeting = ZONE_DIR
}

Weapon_Texts.Toxic_Missile_Upgrade1 = "+1 Damage"

Toxic_Missile_A = Toxic_Missile:new {
	UpgradeDescription = "Increases damage by 1.",
	Damage = 1
}

function Toxic_Missile:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)

	local target = GetProjectileEnd(p1,p2)

	local damage = SpaceDamage(target, self.Damage, dir)
	damage.sAnimation = "airpush_"..dir

	local smoke = SpaceDamage(p1 - DIR_VECTORS[dir], 0)
	smoke.iSmoke = 1
	smoke.sAnimation = "exploout0_"..GetDirection(p1 - p2)
	ret:AddDamage(smoke)

	ret:AddProjectile(damage, self.Projectile)

	return ret
end

Smoke_Grenade = LineArtillery:new {
    Name = "Smoke Grenade",
    Description = "Damage a target, creating a smoke cloud on kill.",
    Class = "Ranged",
	Damage = 1,
	Push = 0,
	PowerCost = 0, --AE Change
	LaunchSound = "/weapons/artillery_volley",
	ImpactSound = "/impact/generic/explosion",
	KOSound = "/weapons/rocket_launcher",
	Icon = "weapons/ranged_rocket.png",
	UpShot = "effects/shotup_smokeblast_missile.png",
	Explosion = "",
	BounceAmount = 2,
	Upgrades = 2,
	UpgradeCost = {1,2},
	TipImage = StandardTips.Ranged
}

Smoke_Grenade_A = Smoke_Grenade:new {
	Name = "Push target",
	Push = 1
}

Smoke_Grenade_B = Smoke_Grenade:new {
	Name = "+1 Damage",
	Damage = 2
}

Smoke_Grenade_AB = Smoke_Grenade:new {
	Damage = 2,
	Push = 1
}

function Smoke_Grenade:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	ret:AddBounce(p1, 1)

	local damage = SpaceDamage(p2, self.Damage)
	
	if self.Push == 0 then
		damage.sAnimation = "ExploArt1"
	else
		damage = SpaceDamage(p2, self.Damage, dir)
		damage.sAnimation = "airpush_"..dir
	end
	

	ret:AddArtillery(damage, self.UpShot)
    ret:AddBounce(p2, self.BounceAmount)

	if Board:IsDeadly(damage, Pawn) then
		local smoke = SpaceDamage(p2)
		smoke.iSmoke = 1
		ret:AddDamage(smoke)
		ret:AddSound(self.KOSound)
	end

	return ret
end		