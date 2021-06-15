/*
	Coded by Matt Anderson
	Hello moto
*/
CLASS = CLASS or {};
CLASS.Name = "Plague Doctor";
CLASS.ID = 049;
CLASS.Color = Color( 255, 0, 0 );
CLASS.Team = TEAM_049;
CLASS.Health = 200;
CLASS.ZombieSpeed = 280;
CLASS.ZombieHealth = 75;
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
CLASS.ZombieSounds = {
	Pain = "npc/zombie/zombie_pain",
	Death = "npc/zombie/zombie_die",
	Idle = "npc/zombie/zombie_voice_idle"
};
CLASS.Model = "models/player/zombie_classic.mdl";
CLASS.Weapon = "weapon_zfists";
CLASS.EnemyRadius = 500;
--10 minutes until the infection resets.
CLASS.InfectionReset = 10;
CLASS.CellPos = Vector( -10542, -3574, -855 );

/*
	Various reminders:
		Plague doctor infects people and turns them into rampaging zombies
		- Stop zombies from damaging 049
		- Stop zombies from infecting other SCPs
		Make sure the player cant change jobs while they are a zombie
		Stop the player from spawning ents and props while zombie
		Add a timer to stop disable the infection after a time
		Add a menu and option to disable the infection music

*/
