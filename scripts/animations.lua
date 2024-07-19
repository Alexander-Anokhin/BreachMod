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

ANIMS.radiation_push_0 = Animation:new{
	Image = "effects/explo_radpush_U.png",
	NumFrames = 9,
	Time = 0.06,
	PosX = -8,
	PosY = -12
}

ANIMS.radiation_push_1 = ANIMS.radiation_push_0:new{
	Image = "effects/explo_radpush_R.png",
	PosX = -8,
	PosY = 10
}

ANIMS.radiation_push_2 = ANIMS.radiation_push_0:new{
	Image = "effects/explo_radpush_D.png",
	PosX = -33,
	PosY = 10
}

ANIMS.radiation_push_3 = ANIMS.radiation_push_0:new{
	Image = "effects/explo_radpush_L.png",
	PosX = -33,
	PosY = -12
}