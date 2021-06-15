--[[
	Plague doctor cl_init.lua
	--Add manual blinking for time syncing
]]--
CLASS = CLASS or {};


function CLASS:DrawVictimMenu( client )
	local pos = ( client:EyePos() - Vector( 0, 0, 15 ) ):ToScreen();
	if( self.VictimMenu == nil ) then
		self.VictimMenu = vgui.Create( "SCP_Notice" );
		self.VictimMenu:SetText( "Press Use." );
		self.VictimMenu:SetPos( pos.x, pos.y - self.VictimMenu:GetTall() / 2 );
	else
		self.VictimMenu:SetPos( pos.x, pos.y - self.VictimMenu:GetTall() / 2 );
	end;
end;


function CLASS:DrawPortalMenu()
	local trace = LocalPlayer():GetEyeTrace();
	local pos = trace.HitPos:ToScreen();
	if( self.PortalMenu == nil ) then
		self.PortalMenu = vgui.Create( "SCP_Notice" );
		self.PortalMenu:SetText( "Press Use to create portal." );
		self.PortalMenu:SetPos( pos.x, pos.y - self.PortalMenu:GetTall() / 2 );
	else
		self.PortalMenu:SetPos( pos.x, pos.y - self.PortalMenu:GetTall() / 2 );
	end;
end;


function CLASS:CreateScreamer()
	if( self.Frame ) then
		self.Frame:Remove();
		self.Frame = nil;
	end;
	self.Frame = vgui.Create( "DHTML", self.Frame );
	self.Frame:SetVisible( false );
	self.Frame:SetSize( ScrW(), ScrH() );
	self.Frame:Center();
	self.Frame:SetHTML( [[
		<iframe width="]] .. ScrW() .. [[" height="]] .. ScrH() .. [[" src="https://www.youtube.com/embed/5EimEFSWb3c/?start=80&autoplay=1" frameborder="0" allowfullscreen></iframe>
	]] );
	timer.Simple( 1.1, function()
		self.Frame:SetVisible( true );
	end );
end;


function CLASS:RemoveScreamer()
	if( self.Frame ) then
		self.Frame:Remove();
		self.Frame = nil;
	end;
end;


function CLASS:SetNoDraw( client, bool )
	client:SetNoDraw( bool );
	for _,wep in pairs( client:GetWeapons() ) do
		wep:SetNoDraw( bool );
	end;
end;


function CLASS:PlayDimensionSounds()
	if( LocalPlayer():InPocketDimension() ) then
		if( math.random( 1, 100 ) == 1 ) then
			if( !self.PlayingSound ) then
				sound.Play( "ambient/hallow0" .. math.random( 1, 7 ) .. ".wav", LocalPlayer():GetPos() + Vector( math.random( -100, 100 ), math.random( -100, 100 ), 0 ), 75, 100, 1 );
				self.PlayingSound = true;
				timer.Simple( 5, function()
					self.PlayingSound = nil;
				end );
			end;
		end;
		if( LocalPlayer():GetPos():Distance( self.ScreamerPos ) <= 100 ) then
			if( !self.Screamer ) then
				surface.PlaySound( "npc/stalker/go_alert2a.wav" );
				self.Screamer = true;
				timer.Simple( 3, function()
					self.Screamer = nil;
				end );
			end;
		end;
	end;
end;


function CLASS:HandleClientDrawing()
	for _,client in pairs( player.GetAll() ) do
		if( LocalPlayer():InPocketDimension() ) then
			if( !client:InPocketDimension() ) then
				self:SetNoDraw( client, true );
			else
				self:SetNoDraw( client, false );
			end;
			for _,ent in pairs( ents.FindByClass( "physgun_beam" ) ) do
				local parent = ent:GetParent();
				ent:SetNoDraw( true );
			end;
		elseif( client:InPocketDimension() ) then
			self:SetNoDraw( client, true );
		else
			self:SetNoDraw( client, false );
			for _,ent in pairs( ents.FindByClass( "physgun_beam" ) ) do
				ent:SetNoDraw( false );
			end;
		end;
	end;
	for _,ent in pairs( ents.FindByClass( "physgun_beam" ) ) do
		local parent = ent:GetParent();
		if( parent:IsValid() ) then
			if( parent:InPocketDimension() and !LocalPlayer():InPocketDimension() ) then
				ent:SetNoDraw( true );
			elseif( !parent:InPocketDimension() and LocalPlayer():InPocketDimension() ) then
				ent:SetNoDraw( true );
			else
				ent:SetNoDraw( false );
			end;
		end;
	end;
end;


function CLASS:HandlePropDrawing()
	for _,prop in pairs( ents.FindByClass( "prop_physics" ) ) do
		if( prop:InPocketDimension() ) then
			if( !LocalPlayer():InPocketDimension() ) then
				prop:SetNoDraw( true );
			else
				prop:SetNoDraw( false );
			end;
		else
			if( !LocalPlayer():InPocketDimension() ) then
				prop:SetNoDraw( false );
			else
				prop:SetNoDraw( true );
			end;
		end;
	end;
end;


function CLASS:DrawFemurBreaker()
	if( self.FemurBreaker ) then
		if( !self.FemurBreakerMenu ) then
			self.FemurBreakerMenu = vgui.Create( "SCP_Notice" );
			self.FemurBreakerMenu:SetFont( "Researcher_AreaText" );
			self.FemurBreakerMenu:SetText( "Femur Breaker Active!" );
		end;
		if( !self.FemurBreakerCooldown ) then
			self.FemurBreakerCooldown = vgui.Create( "SCP_Notice" );
			self.FemurBreakerCooldown:SetFont( "Researcher_DClass" );
		end;
		local scrPos = self.CellPos:ToScreen();
		self.FemurBreakerMenu:SetPos( scrPos.x - self.FemurBreakerMenu:GetWide() / 2, scrPos.y - self.FemurBreakerMenu:GetTall() / 2 );
		self.FemurBreakerCooldown:SetPos( scrPos.x - self.FemurBreakerCooldown:GetWide() / 2, scrPos.y + self.FemurBreakerCooldown:GetTall() );
		self.FemurBreakerCooldown:SetText( "Turning off in: " .. math.Round( self.FemurBreakerCooldownTime - CurTime() ) );
	else
		if( self.FemurBreakerMenu ) then
			self.FemurBreakerMenu:Remove();
			self.FemurBreakerMenu = nil;
		end;
		if( self.FemurBreakerCooldown ) then
			self.FemurBreakerCooldown:Remove();
			self.FemurBreakerCooldown = nil;
		end;
	end;
end;




/*
	HOOKS:
*/
function CLASS.Hooks:HUDPaint()
	local client = LocalPlayer();
	if( client:Team() == self.Team ) then
		local trace = client:GetEyeTrace();
		if( trace.Entity and trace.Entity:IsValid() ) then
			if( trace.Entity:IsPlayer() ) then
				local victim = trace.Entity;
				if( victim:Health() <= self.HealthReq and !victim:InPocketDimension() ) then
					self:DrawVictimMenu( victim );
				else
					if( self.VictimMenu ) then
						self.VictimMenu:Remove();
						self.VictimMenu = nil;
					end;
				end;
			else
				if( self.VictimMenu ) then
					self.VictimMenu:Remove();
					self.VictimMenu = nil;
				end;
			end;
		else
			if( self.VictimMenu ) then
				self.VictimMenu:Remove();
				self.VictimMenu = nil;
			end;
		end;
		if( trace.HitPos:Distance( client:EyePos() ) <= 40 ) then
			local canTeleport = self:CanTeleport( client, 40 );
			if( canTeleport ) then
				self:DrawPortalMenu();
			else
				if( self.PortalMenu ) then
					self.PortalMenu:Remove();
					self.PortalMenu = nil;
				end;
			end;
		else
			if( self.PortalMenu ) then
				self.PortalMenu:Remove();
				self.PortalMenu = nil;
			end;
		end;
	else
		if( self.PortalMenu ) then
			self.PortalMenu:Remove();
			self.PortalMenu = nil;
		end;
	end;
	if( client:Team() == self.Team or client:IsSecurity() ) then
		self:DrawFemurBreaker();
	else
		if( self.FemurBreakerMenu ) then
			self.FemurBreakerMenu:Remove();
			self.FemurBreakerMenu = nil;
		end;
		if( self.FemurBreakerCooldown ) then
			self.FemurBreakerCooldown:Remove();
			self.FemurBreakerCooldown = nil;
		end;
	end;
end;


function CLASS.Hooks:Think()
	self:HandleClientDrawing();
	self:HandlePropDrawing();
	self:PlayDimensionSounds();
end;


function CLASS.Hooks:RenderScreenspaceEffects()
	if( LocalPlayer():InPocketDimension() ) then
		local tab = {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = -0.2,
			[ "$pp_colour_contrast" ] = 1.0,
			[ "$pp_colour_colour" ] = 0.25,
			[ "$pp_colour_mulr" ] = 0,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		}
		if( LocalPlayer():Team() == self.Team ) then
			tab[ "$pp_colour_brightness" ] = 0.0;
		end;
		DrawColorModify( tab );
		local distort = math.sin( CurTime() * 2 ) * 0.02;
		DrawMaterialOverlay( "effects/water_warp01", 0.04 );
		DrawMaterialOverlay( "effects/bombinomicon_distortion", distort );
	end;
end;


function CLASS.Hooks:PreDrawHalos()
	local clients = team.GetPlayers( self.Team );
	if( LocalPlayer():InPocketDimension() and LocalPlayer():Team() ~= self.Team ) then
		if( clients ) then
			if( clients[1] ) then
				if( clients[1]:IsValid() ) then
					if( clients[1]:InPocketDimension() ) then
						halo.Add( clients, Color( 150, 150, 255 ), 2, 2, 2 );
					end;
				end;
			end;
		end;
	else
		if( LocalPlayer():InPocketDimension() ) then
			local clients = {};
			for _,client in pairs( player.GetAll() ) do
				if( client:InPocketDimension() ) then
					halo.Add( { client }, team.GetColor( client:Team() ), 2, 2, 2 );
				end;
			end;
		end;
	end;
end;


function CLASS.Hooks:HUDShouldDraw( element )
	--if( LocalPlayer():InPocketDimension() ) then
		--return false;
	--end;
end;



/*
	Nets:
*/

function CLASS.Nets:FemurBreaker()
	self.FemurBreaker = net.ReadBool();
	if( self.FemurBreaker ) then
		self.FemurBreakerCooldownTime = CurTime() + 120;
	else
		self.FemurBreakerCooldownTime = nil;
		self.FemurBreakerCooldown:Remoev();
		self.FemurBreakerCooldown = nil;
	end;
end;