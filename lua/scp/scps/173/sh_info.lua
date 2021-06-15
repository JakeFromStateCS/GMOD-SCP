/*
	Coded by Matt Anderson
	Hello moto
*/
CLASS = CLASS or {};
CLASS.Name = "The Statue";
CLASS.ID = 173;
CLASS.Color = Color( 255, 0, 0 );
CLASS.Team = TEAM_173;
CLASS.BlinkTime = 25;
CLASS.CloseTime = 2;
CLASS.RunSpeed = 500;
CLASS.WalkSpeed = 500;
CLASS.Health = 200;
CLASS.KillDistance = 200;
CLASS.DeathSounds = {
	"player/death1.wav",
	"player/death2.wav",
	"player/death3.wav",
	"player/death4.wav",
	"player/death5.wav",
	"player/death6.wav",
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav",
	"vo/npc/male01/pain04.wav",
	"vo/npc/Barney/ba_pain06.wav",
	"vo/npc/Barney/ba_pain07.wav",
	"vo/npc/Barney/ba_pain09.wav",
	"vo/npc/Barney/ba_ohshit03.wav", -- ;)
	"vo/npc/Barney/ba_no01.wav",
	"vo/npc/male01/no02.wav",
	"hostage/hpain/hpain1.wav",
	"hostage/hpain/hpain2.wav",
	"hostage/hpain/hpain3.wav",
	"hostage/hpain/hpain4.wav",
	"hostage/hpain/hpain5.wav",
	"hostage/hpain/hpain6.wav"
};
CLASS.BlackList = {
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
CLASS.CellPos = Vector( -13185, -2397, -855 );

/*
	Various reminders:
		Eyes open for 10 seconds
		Blinking for 2 seconds
*/
