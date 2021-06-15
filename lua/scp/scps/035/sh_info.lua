/*
	Coded by Matt Anderson
	Hello moto
*/
CLASS = CLASS or {};
CLASS.Name = "The Mask";
CLASS.ID = 035;
CLASS.Color = Color( 255, 0, 0 );
CLASS.Team = TEAM_035;
CLASS.InfluenceRadius = 150;
CLASS.DeathTime = 30;
CLASS.TickRate = 1;
CLASS.Binds = {
	Toggle = {
		[IN_USE] = "use",
		[IN_ATTACK] = "attack",
		[IN_ATTACK2] = "attack2",
		[IN_JUMP] = "jump",
		[IN_DUCK] = "duck",
		[IN_SPEED] = "speed"
	},
	Weapon = {
		[IN_WEAPON1] = "invprev",
		[IN_WEAPON2] = "invnext"
	}
};
CLASS.BlackList = {
	
}
CLASS.DeathTimeMods = {
	["supporter"] = CLASS.DeathTime + 5,
	["supporter+"] = CLASS.DeathTime + 10,
	["supporterator"] = CLASS.DeathTime + 15,
	["eliteadmin"] = CLASS.DeathTime + 20,
	["superadmin"] = CLASS.DeathTime + 25,
	["manager"] = CLASS.DeathTime + 30,
	["owner"] = CLASS.DeathTime + 35
};
CLASS.Blacklist = {
	TEAM_035,
	TEAM_049,
	TEAM_096,
	TEAM_106,
	TEAM_173,
	TEAM_429,
	TEAM_610,
	TEAM_999,
	TEAM_1370
};
CLASS.CellPos = Vector( -8075, -2222, -855 );

/*
	Various reminders:
		Place the mask where the player died.
		Radius around the mask showing his range of influence
		Press use on a client to possess them when they get within his range
		Cant move ever, only goes around facility with his host
		Talks to his host through private chat and voice
		All voice from the mask when possessing is output as the player?
*/
