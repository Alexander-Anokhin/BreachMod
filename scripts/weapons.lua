Test_Punch = Skill:new {
    Name = "Test Punch",
    Description = "The testest of punches",
    Class = "",
    Icon = "weapons/prime_punchmech.png",
    Rarity = 1,
    Explosion = "",
    LaunchSound = "/weapons/titan_fist",
	Range = 1, -- Tooltip?
	PathSize = 1,
	Damage = 10,
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
    ret:AddMelee(p1, SpaceDamage(p2, self.Damage, direction))
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