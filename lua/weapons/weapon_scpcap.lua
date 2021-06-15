if( SERVER ) then
	AddCSLuaFile();
end;

SWEP.PrintName = "SCP Capture";
SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Freeze all the SCPs."
SWEP.Category = "SCP"

SWEP.Spawnable = true;
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_superphyscannon.mdl";
SWEP.WorldModel = "models/weapons/w_Physics.mdl";

SWEP.HoldType = "physgun";

SWEP.UseHands = true;

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ChargeDuration = 5;
SWEP.FireDuration = 2;

function SWEP:SetTarget( target )
	self:SetNetworkedEntity( "Target", target );
	target:SetNetworkedBool( "SCP_Captured", true );
	target:SetNetworkedEntity( "SCP_Captured_Owner", self.Owner );
	target:Lock();
	target:GodEnable();
end;

function SWEP:ClearTarget()
	local target = self:GetNetworkedEntity( "Target" );
	target:SetNetworkedBool( "SCP_Captured", false );
	target:SetNetworkedEntity( "SCP_Captured_Owner", nil );
	if( SERVER ) then
		target:GodDisable();
		target:UnLock();
	end;
	self:SetNetworkedEntity( "Target", nil );
end;

function SWEP:Holster()
	self:ClearTarget();
	self:StopSounds();
	return true;
end;

function SWEP:Deploy()
	--Game starts charging 
	self.Path = "ambient/energy/";
	self.SoundFiles = {
		FireSequence = {
			"ambient/energy/Zap2.wav",
			"ambient/energy/Zap3.wav",
			"ambient/energy/Zap7.wav"
		},
		LaserSequence = {
			"ambient/energy/weld1.wav",
			"ambient/energy/weld2.wav"
		}
	};
	self.SoundFiles.ChargeSequence = {
		"ambient/energy/force_field_loop1.wav"
	};
	for i=1,6 do
		self.SoundFiles.ChargeSequence[i+ 1] = self.Path .. "spark" .. ( i ) .. ".wav";
	end;
	self:SetNetworkedBool( "FiringLaser", false );
	self:SetNetworkedBool( "Sparks", false );
	self:SetNetworkedEntity( "Target", nil );
	self.TargetDist = 200;
end;

function SWEP:PrimaryAttack()
	if( SERVER ) then
		self.ChargeTime = CurTime();
		self.SparksTime = CurTime() + self.ChargeDuration + self.FireDuration;
		self:SetNextPrimaryFire( self.ChargeTime + self.FireDuration );
		self.ChargeSound = CreateSound( self.Owner, self.SoundFiles.ChargeSequence[1] );
		self.ChargeSound:ChangeVolume( 100 );
		self.ChargeSound:Play();
		timer.Simple( self.ChargeDuration, function()
			self:SetNetworkedBool( "Sparks", true );
			timer.Simple( self.FireDuration, function()
				self:SetNetworkedBool( "Sparks", false );
				local trace = self.Owner:GetEyeTrace();
				if( trace.Entity ) then
					if( trace.Entity:IsValid() ) then
						if( trace.Entity:IsPlayer() ) then
							local fireSound = CreateSound( self.Owner, self.SoundFiles.LaserSequence[math.random( 1, 2 )] );
							fireSound:ChangePitch( math.random( 200, 255 ) );
							fireSound:Play();
							self:SetNetworkedBool( "FiringLaser", true );
							self:SetTarget( trace.Entity );
							self.ChargeTime = nil;
							self.SparksTime = nil;
						else
							timer.Simple( 0.5, function()
								self:SetNetworkedBool( "FiringLaser", false );
							end );
						end;
					end;
				end;
			end );
		end );
	else

	end;
end;

function SWEP:Think()
	if( SERVER ) then
		if( self.ChargeTime ) then
			if( self.ChargeSound ) then
				local time = CurTime();
				local future = self.ChargeTime + self.ChargeDuration;
				if( self.ChargeTime + self.ChargeDuration < CurTime() ) then
					self.ChargeSound:Stop();
					if( self.SparksTime > CurTime() ) then
						local sparkSound = CreateSound( self.Owner, self.SoundFiles.ChargeSequence[1 + math.random( 1, 6 )] );
						sparkSound:ChangePitch( math.random( 200, 255 ) );
						sparkSound:Play();
					end;
				elseif( future == CurTime() ) then

				else
					local difference = ( future - time );
					local pitch = 255 - ( 200 / self.ChargeDuration ) * difference;
					self.ChargeSound:ChangePitch( pitch );
				end;
			end;
		else
			local client = self:GetNetworkedEntity( "Target" );
			if( client and client:IsValid() ) then
				client:SetPos( self.Owner:GetPos() + self.Owner:OBBCenter() + self.Owner:GetForward() * self.TargetDist );
			end;
		end;
	else

	end;
end;

function SWEP:StopSounds()
	if( self.ChargeSound ) then
		self.ChargeSound:Stop();
	end;
end;

local function DrawBeam( self )
	local firing = self:GetNetworkedBool( "FiringLaser" );
	local sparks = self:GetNetworkedBool( "Sparks" );
	local entity = self:GetNetworkedEntity( "Target" );
	if( firing == true or sparks == true ) then
		local viewModel = self.Owner:GetViewModel();
		local muzzle;
		if( self.Owner == LocalPlayer() ) then
			muzzle = viewModel:GetAttachment( 1 );
		else
			viewModel = self;
			muzzle = self:GetAttachment( 1 );
		end;
		local startPos = muzzle.Pos;
		local endPos = startPos + viewModel:GetForward() * 100;
		if( firing ) then
			if( !entity:IsValid() ) then
				return;
			end;
			endPos = entity:GetPos() + entity:OBBCenter();
		end;
		if( endPos ) then
			local material = Material( "cable/XBeam" );
			local powerVar = 3;
			--Standard deviations
			local chaosVar = 4;
			if( sparks ) then
				chaosVar = 20;
			end;
			render.SetMaterial( material );
			local segments = {
				{ startPos, endPos }
			}
			for i=0, powerVar do
				local newsegs = {}
				for id, seg in pairs( segments ) do
					local mid = Vector( (seg[1].x + seg[2].x) / 2, (seg[1].y + seg[2].y) / 2, (seg[1].z + seg[2].z) / 2 );
					local right = (startPos - endPos):Angle():Right();
					local up = (startPos - endPos):Angle():Up();
					local offsetpos = mid + right * math.random( -chaosVar, chaosVar ) + up * math.random( -chaosVar, chaosVar );
					table.insert( newsegs, {seg[1], offsetpos} );
					table.insert( newsegs, {offsetpos, seg[2]} );
				end
				segments = newsegs
			end
			for id, seg in pairs( segments ) do
				render.DrawBeam( seg[1], seg[2], 3, 0, seg[1]:Distance(seg[2]) / 25, Color( 255, 255, 255 ) )
			end
		end;
	end;
end;

local function DrawPrison( self )
	local client = self:GetNetworkedEntity( "Target" );
	if( client:IsValid() ) then
		local pos = client:GetPos();
		local OBBMax = client:OBBMaxs();
		local OBBMin = client:OBBMins();
		local Dist = OBBMax - OBBMin;
		local midForward = pos + client:GetForward() * Dist / 2;
		--Bottom Left
		local point1 = midForward - client:GetRight() * Dist / 2;
		local point2 = midForward + client:GetRight() * Dist / 2;

		local material = Material( "cable/XBeam" );
		render.SetMaterial( material );
		local segments = {
			{ point1, point2 },
		}
		for id, seg in pairs( segments ) do
			render.DrawBeam( seg[1], seg[2], 3, 0, seg[1]:Distance(seg[2]) / 25, Color( 255, 255, 255 ) )
		end
	end;
end;

function Draw_Scp_Cap_Beams()
	for _,ent in pairs( ents.FindByClass( "weapon_scpcap" ) ) do
		DrawBeam( ent );
		DrawPrison( ent );
	end;
end;
hook.Add( "PostDrawOpaqueRenderables", "SCP_Cap_Beams", Draw_Scp_Cap_Beams );
/*
local ent = LocalPlayer()
local start = ent:GetPos()
local endpos = Vector( 0, 0, 0 );
local deviations = 10
local power = 3 -- (2 ^ power) segments

local m = Material( "cable/physbeam" );

hook.Add( "PostDrawOpaqueRenderables", "Test", function()
render.SetMaterial( m )

local segments = {
	{ start, endpos }
}
for i=0, power do
	local newsegs = {}
	for id, seg in pairs( segments ) do
		local mid = Vector( (seg[1].x + seg[2].x) / 2, (seg[1].y + seg[2].y) / 2, (seg[1].z + seg[2].z) / 2 );
		local right = (start - endpos):Angle():Right();
		local up = (start - endpos):Angle():Up();
		local offsetpos = mid + right * math.random( -deviations, deviations ) + up * math.random( -deviations, deviations );
		table.insert( newsegs, {seg[1], offsetpos} );
		table.insert( newsegs, {offsetpos, seg[2]} );
	end
	segments = newsegs
end
for id, seg in pairs( segments ) do
	render.DrawBeam( seg[1], seg[2], 5, 0, seg[1]:Distance(seg[2]) / 25, Color( 255, 255, 255 ) )
end
end );
*/
