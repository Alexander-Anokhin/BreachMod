
-- test palette
modApi:addPalette({
	ID = "AtomicDesolatorPalette",
	Name = "Radioactive Green",
	Image = "MechPulse",
	PlateHighlight = {255,226,171},
	PlateLight     = {139,121,164},
	PlateMid       = {85,88,112},
	PlateDark      = {36,41,65},
	PlateOutline   = {12,19,31},
	PlateShadow    = {60,87,89},
	BodyColor      = {69,116,98},
	BodyHighlight  = {79,146,107},
	}
)

Radiation_Mech = Pawn:new {
    Name = "Radiation Mech",
    Class = "Science",
    Health = 2,
    MoveSpeed = 4,
    Massive = true,
    Flying = true,
    Image = "MechNano",
    ImageOffset = modApi:getPaletteImageOffset("AtomicDesolatorPalette"),
    SkillList = {"Radiation_Flash"},
    SoundLocation = "/mech/science/science_mech/",
    DefaultTeam = TEAM_PLAYER,
    ImpactMaterial = IMPACT_METAL
}

Reactor_Mech = Pawn:new {
    Name = "Reactor Mech",
    Class = "Science",
    Health = 4,
    MoveSpeed = 4,
    Massive = true,
    Image = "MechPulse",
    ImageOffset = modApi:getPaletteImageOffset("AtomicDesolatorPalette"),
    SkillList = {"Nuclear_Pulse"},
    SoundLocation = "/mech/science/pulse_mech/",
    DefaultTeam = TEAM_PLAYER,
    ImpactMaterial = IMPACT_METAL,
}

Contamination_Mech = Pawn:new {
    Name = "Contamination Mech",
    Class = "Brute",
    Health = 3,
    MoveSpeed = 3,
    Massive = true,
    Image = "MechUnstable",
    ImageOffset = modApi:getPaletteImageOffset("AtomicDesolatorPalette"),
    SkillList = {"Toxic_Missile"},
    SoundLocation = "/mech/brute/tank/",
    DefaultTeam = TEAM_PLAYER,
    ImpactMaterial = IMPACT_METAL,
}