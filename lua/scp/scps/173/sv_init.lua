--[[
	Plague doctor sv_init.lua
	Coded by Matt Anderson
	hello moto
]]--
CLASS = CLASS or {};
CLASS.BlinkTimers = {};

function CLASS:OnLoad()
	for _,client in pairs( player.GetAll() ) do
		self:Blink( client );
		if( client:Team() == self.Team ) then
			client:SetCanFreeze( true );
		end;
	end;
end;



function CLASS:UpdateStats( client )
	if( client:Team() == self.Team ) then
		--DarkRP set their stats after this function is called
		--So we add a delay cause fuck em.
		timer.Simple( 0.1, function()
			if( client:IsValid() ) then
				client:SetHealth( self.Health );
				client:SetWalkSpeed( self.WalkSpeed );
				client:SetRunSpeed( self.RunSpeed );
			end;
		end );
	end;
end;



function CLASS:Blink( client )
	self.BlinkTimers[client] = CurTime() + self.BlinkTime;
	SCP:NetMessage( client, "BlinkTime" );
	client.blinking = true;
	if( client.statue ) then
		if( client.statue:IsValid() ) then
			client.statue:UnLock();
			client.statue:SetFrozen( false );
		end;
	end;
	client.statue = nil;
	timer.Simple( self.CloseTime, function()
		if( client:IsValid() ) then
			client.blinking = false;
		end;
	end );
end;



function CLASS:CheckStatueMovement( client )
	if( client:Alive() ) then
		if( !client.blinking ) then
			if( SCP.Lights:IsOn() ) then
				local trace = client:GetEyeTrace();
				local ent = trace.Entity;
				if( ent and ent:IsValid() and ent:IsPlayer() ) then
					if( ent:IsStatue() ) then
						if( client:InPocketDimension() and !ent:InPocketDimension() ) then
							return;
						end;
						if( !client:InPocketDimension() and ent:InPocketDimension() ) then
							return;
						end;
						local weapon = ent:GetActiveWeapon();
						local class;
						if( weapon and weapon:IsValid() ) then
							class = weapon:GetClass();
						end;
						if( ent:CanFreeze() and !ent:GetFrozen() or !class or class and class ~= "weapon_handcuffed" ) then
							ent:Lock();
							ent:SetFrozen( true );
							client.statue = ent;
							return false;
						end;
					end;
				end;
			end;
		end;
	end;
end;



function CLASS:StatueKill( client )
	if( !client:GetFrozen() ) then
		if( client:CanFreeze() ) then
			local trace = client:GetEyeTrace();
			local victim = trace.Entity;
			if( victim and victim:IsPlayer() ) then
				if( trace.HitPos:Distance( client:EyePos() ) <= self.KillDistance ) then
					local deathSound = table.Random( self.DeathSounds );
					local dmgInfo = DamageInfo();
					dmgInfo:SetAttacker( client );
					dmgInfo:SetDamage( 500 );
					victim:TakeDamageInfo( dmgInfo );
					victim:EmitSound( "physics/body/body_medium_break" .. math.random( 2, 3 ) .. ".wav" )
					if( !victim:Alive() ) then
						victim:EmitSound( deathSound );
					end;
				end;
			end;
		end;
	end;
end;



/*
	HOOKS:
*/
function CLASS.Hooks:OnPlayerChangedTeam( client, oldTeam, newTeam )
	if( newTeam == self.Team ) then
		--DarkRP workaround, they set the run speeds and whatnot
		--After this hook, fuck em.
		self:UpdateStats( client );
		client:SetCanFreeze( true );
	elseif( oldTeam == self.Team ) then
		client:SetCanFreeze( false );
		client:SetFrozen( false );
	end;
end;



function CLASS.Hooks:PlayerInitialSpawn( client )
	self:Blink( client );
end;



function CLASS.Hooks:PlayerSpawn( client )
	if( self.BlinkTimers[client] == nil ) then
		self:Blink( client );
	end;
	if( client:Team() == self.Team ) then
		client:SetCanFreeze( true );
	end;
	self:UpdateStats( client );
end;



function CLASS.Hooks:KeyPress( client, key )
	if( client:Team() == self.Team ) then
		if( key == IN_USE ) then
			self:StatueKill( client );
		end;
	end;
end;



function CLASS.Hooks:Think()
	for client,time in pairs( self.BlinkTimers ) do
		if( !client:IsValid() ) then
			self.BlinkTimers[client] = nil;
			return;
		end;
		local curTime = CurTime();
		self:CheckStatueMovement( client );
		if( curTime > time ) then
			self:Blink( client );
		end;
	end;
end;



--Unfreeze the SCP when they're handcuffed
function CLASS.Hooks:OnHandcuffed( cuffer, target, ent )
	if( target:Team() == self.Team ) then
		target:UnLock();
		target:SetCanFreeze( false );
	end;
end;



--Allow them to be frozen once the cuffs are broken
function CLASS.Hooks:OnHandcuffBreak( client, cuffs, breaker )
	if( client:Team() == self.Team ) then
		client:SetCanFreeze( true );
	end;
end;