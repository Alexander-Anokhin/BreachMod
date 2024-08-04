
-- test palette
modApi:addPalette({
	ID = "AtomicDesolatorPalette",
	Name = "Radioactive Green",
	Image = "MechPulse",
	PlateHighlight = {35,248,255},
	PlateLight     = {171,241,87},
	PlateMid       = {73,190,57},
	PlateDark      = {57,149,45},
	PlateOutline   = {0,25,36},
	PlateShadow    = {41,54,58},
	BodyColor      = {0,46,66},
	BodyHighlight  = {62,82,87},
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
    SkillList = {"Nuclear_Pulse", "Radion_Siphon"},
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