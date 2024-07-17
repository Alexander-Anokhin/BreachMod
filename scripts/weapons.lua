local script_path = mod_loader.mods[modApi.currentMod].scriptPath
local radiation = require(script_path .."radiation")
local customAnim = require(script_path .."libs/customAnim")
local trait = require(script_path .."libs/trait")

function ApplyRadiation(id)
	-- add to list
	GetCurrentMission().irradiated_targets[id] = 1

	-- attach animation
	customAnim:add(id, "irradiated_loop")

	-- manually update traitlib (without this doesn't work with failed pushes sometimes)
	trait:update(Board:GetPawn(id):GetSpace())
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
				ApplyRadiation(]] ..target_id.. [[)
			]])
		end

		-- Custom status preview icon
		damage.sImageMark = "effects/icon_radiation_glow.png"
	end

	ret:AddMelee(p1, damage)

    return ret
end

Nuclear_Pulse = Skill:new {
	Name = "Nuclear Pulse",
	Description = "Irradiate and push surrounding targets.",
	PathSize = 1,
	Class = "Science",
	Icon = "weapons/science_repulse.png",
	LaunchSound = "/weapons/science_repulse",
	Damage = 0,
	PowerCost = 0, --AE Change
	Upgrades = 0,
	ZoneTargeting = ZONE_ALL,
	TipImage = StandardTips.Surrounded
}

function Nuclear_Pulse:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point)
	for i = DIR_START, DIR_END do
		ret:push_back(point + DIR_VECTORS[i])
	end
	
	return ret
end

function Nuclear_Pulse:GetSkillEffect(p1, p2)
	local ret = SkillEffect()

	ret:AddBounce(p1,-2)

	for i = DIR_START,DIR_END do
		local target_pos = p1 + DIR_VECTORS[i]
		local damage = SpaceDamage(target_pos, 0, i)
		
		damage.sAnimation = "radiation_push_"..i

		local target_pawn = Board:GetPawn(target_pos)

		if target_pawn then
			-- Apply radiation
			if not radiation.IsIrradiated(target_pos) then
				local target_id = target_pawn:GetId()
				ret:AddScript([[
					ApplyRadiation(]] ..target_id.. [[)
				]])
			end

			-- Custom status preview icon
			damage.sImageMark = "effects/icon_radiation_glow.png"
		end

		ret:AddDamage(damage)
		ret:AddBounce(target_pos,-1)
	end

	local selfDamage = SpaceDamage(p1, 0)
	selfDamage.sAnimation = "radiation_boom"
	ret:AddDamage(selfDamage)

	return ret
end

Toxic_Missile = TankDefault:new {
	Name = "Toxic Missile",
	Description = "Irradiate and push a target.",
	Class = "Brute",
	Damage = 0,
	Smoke = 0,
	Icon = "weapons/brute_tankmech.png",
	Explosion = "",
	Sound = "/general/combat/explode_small",
	Projectile = "effects/shot_mechtank",
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {1,2},
	LaunchSound = "/weapons/modified_cannons",
	ImpactSound = "/impact/generic/explosion",
	TipImage = StandardTips.Ranged,
	ZoneTargeting = ZONE_DIR
}

Weapon_Texts.Toxic_Missile_Upgrade1 = "Vent Smoke"
Weapon_Texts.Toxic_Missile_Upgrade2 = "+1 Damage"

Toxic_Missile_A = Toxic_Missile:new {
	UpgradeDescription = "Vent smoke behind your mech.",
	Smoke = 1
}

Toxic_Missile_B = Toxic_Missile:new {
	UpgradeDescription = "Increases damage by 1.",
	Damage = 1
}

Toxic_Missile_AB = Toxic_Missile:new {
	Smoke = 1,
	Damage = 1
}

function Toxic_Missile:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)

	local target_pos = GetProjectileEnd(p1,p2)
	local target_pawn = Board:GetPawn(target_pos)

	local damage = SpaceDamage(target_pos, self.Damage, dir)
	damage.sAnimation = "airpush_"..dir

	if target_pawn then
		-- Apply radiation
		if not radiation.IsIrradiated(target_pos) then
			local target_id = target_pawn:GetId()
			ret:AddScript([[
				AddRadiationToTarget(]] ..target_id.. [[)
			]])
		end

		-- Custom status preview icon
		damage.sImageMark = "effects/icon_radiation_glow.png"
	end

	if self.Smoke > 0 then
		local smoke = SpaceDamage(p1 - DIR_VECTORS[dir], 0)
		smoke.iSmoke = 1
		smoke.sAnimation = "exploout0_"..GetDirection(p1 - p2)
		ret:AddDamage(smoke)
	end
	
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