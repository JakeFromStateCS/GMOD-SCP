--[[
	Plague doctor cl_init.lua
	https://www.youtube.com/watch?v=G5HQvzQlkho - Rob Zombie instrumental
]]--
surface.CreateFont( "Researcher_AreaText", {
	font = "Roboto",
	size = 38
} );

surface.CreateFont( "Researcher_DClass", {
	font = "Roboto",
	size = 30
} );

surface.CreateFont( "Researcher_Follow", {
	font = "Roboto",
	size = 24
} );


CLASS = CLASS or {};

function CLASS:DrawUseNotify()
	local client = LocalPlayer();
	local trace = client:GetEyeTrace();
	if( trace.Entity and trace.Entity:IsValid() ) then
		if( trace.Entity:IsPlayer() ) then
			local dClass = trace.Entity;
			if( dClass:Team() == TEAM_DCLASS or dClass:Team() == TEAM_BUBBA ) then
				local researcher = dClass:GetResearcher();
				if( !researcher:IsValid() ) then
					if( self.Menu == nil ) then
						self.Menu = vgui.Create( "SCP_Notice" );
						self.Menu:SetText( "Press Use." );
					end;
					local pos = ( dClass:EyePos() - Vector( 0, 0, 10 ) ):ToScreen();
					self.Menu:SetPos( pos.x - self.Menu:GetWide() / 2, pos.y );
				end;
			end;
		else
			if( self.Menu ) then
				self.Menu:Remove();
				self.Menu = nil;
			end;
		end;
	else
		if( self.Menu ) then
			self.Menu:Remove();
			self.Menu = nil;
		end;
	end;
end;


function CLASS:DrawDClass()
	local dClass = LocalPlayer():GetDClass();
	if( dClass:InPocketDimension() ) then
		return;
	end;
	local pos = ( dClass:EyePos() + Vector( 0, 0, 8 ) ):ToScreen();
	local triSize = 30;
	surface.SetDrawColor( Color( 0, 0, 0 ) );
	surface.DrawTriangle( pos.x, pos.y + 3, 34 );
	surface.SetDrawColor( Color( 200, 200, 200 ) );
	surface.DrawTriangle( pos.x, pos.y, 30 );

	surface.SetFont( "Researcher_Follow" );
	local w, h = surface.GetTextSize( "DClass" );
	surface.SetDrawColor( Color( 200, 200, 200 ) );
	surface.DrawRect( pos.x - w / 2 - 2, pos.y - h / 2 - 2 - 30, w + 4, h + 4 );
	surface.SetDrawColor( Color( 50, 50, 50 ) );
	surface.DrawOutlinedRect( pos.x - w / 2 - 2, pos.y - h / 2 - 2 - 30, w + 4, h + 4 );
	draw.SimpleTextOutlined( "DClass", "Researcher_Follow", pos.x, pos.y - 30, Color( 250, 250, 250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) );
end;


function CLASS:DrawResearcher()
	local client = LocalPlayer();
	if( client:InPocketDimension() ) then
		return;
	end;
	if( client:Team() == TEAM_DCLASS or client:Team() == TEAM_BUBBA ) then
		local researcher = client:GetResearcher();
		if( researcher:IsValid() ) then
			local pos = ( researcher:EyePos() + Vector( 0, 0, 8 ) ):ToScreen();
			local triSize = 30;
			surface.SetDrawColor( Color( 0, 0, 0 ) );
			surface.DrawTriangle( pos.x, pos.y + 3, 34 );
			surface.SetDrawColor( Color( 200, 200, 200 ) );
			surface.DrawTriangle( pos.x, pos.y, 30 );

			surface.SetFont( "Researcher_Follow" );
			local w, h = surface.GetTextSize( "Follow." );
			surface.SetDrawColor( Color( 200, 200, 200 ) );
			surface.DrawRect( pos.x - w / 2 - 2, pos.y - h / 2 - 2 - 30, w + 4, h + 4 );
			surface.SetDrawColor( Color( 50, 50, 50 ) );
			surface.DrawOutlinedRect( pos.x - w / 2 - 2, pos.y - h / 2 - 2 - 30, w + 4, h + 4 );
			draw.SimpleTextOutlined( "Follow.", "Researcher_Follow", pos.x, pos.y - 30, Color( 250, 250, 250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) );
		end;
	end;
end;


function CLASS:DrawResearcherNotify()
	local pos = self.DClassSpawn;
	local scrPos = pos:ToScreen();
	local dist = math.sqrt( ( scrPos.x - ScrW() / 2 ) ^2 + ( scrPos.y - ScrH() / 2 ) ^2 );
	local maxDist = 300;
	local alpha = 255 - math.Clamp( 255 / maxDist * dist, 0, 255 );

	if( self.AreaNotify == nil ) then
		self.AreaNotify = vgui.Create( "SCP_Notice" );
		self.AreaNotify:SetFont( "Researcher_AreaText" );
		self.AreaNotify:SetText( "Get a Class-D for research." );
	end;
	self.AreaNotify:SetPos( scrPos.x - self.AreaNotify:GetWide() / 2, scrPos.y );
	self.AreaNotify:SetAlpha( alpha );
end;


function CLASS:DrawResearcherInfo()
	local client = LocalPlayer();
	local trace = client:GetEyeTrace();
	if( trace.Entity:IsValid() and trace.Entity:IsPlayer() ) then
		local dClass = trace.Entity;
		if( dClass:Team() == TEAM_DCLASS or dClass:Team() == TEAM_BUBBA ) then
			local researcher = dClass:GetResearcher();
			if( researcher:IsValid() ) then
				if( self.ResearcherInfo == nil ) then
					self.ResearcherInfo = vgui.Create( "SCP_Notice" );
					self.ResearcherInfo:SetText( "Escorted by: " .. researcher:Nick() );
				end
				local pos = dClass:EyePos():ToScreen();
				pos.x = pos.x - self.ResearcherInfo:GetWide() / 2;
				pos.y = pos.y + self.ResearcherInfo:GetTall() / 2;
				self.ResearcherInfo:SetPos( pos.x, pos.y );
			else
				if( self.ResearcherInfo ) then
					if( self.ResearcherInfo:IsValid() ) then
						self.ResearcherInfo:Remove();
						self.ResearcherInfo = nil;
					end;
				end;
			end;
		else
			if( self.ResearcherInfo ) then
				if( self.ResearcherInfo:IsValid() ) then
					self.ResearcherInfo:Remove();
					self.ResearcherInfo = nil;
				end;
			end;
		end;
	else
		if( self.ResearcherInfo ) then
			if( self.ResearcherInfo:IsValid() ) then
				self.ResearcherInfo:Remove();
				self.ResearcherInfo = nil;
			end;
		end;
	end;
end;


function CLASS:DrawSCPInfo( client )
	local SCPID = client:GetSCP();
	if( SCPID ~= 0 ) then
		local SCP = SCP.Classes[SCPID];
		if( self.SCPInfo == nil ) then
			self.SCPInfo = vgui.Create( "SCP_Notice" );
		end;
		local scrPos = SCP.CellPos:ToScreen();
		self.SCPInfo:SetPos( scrPos.x - self.SCPInfo:GetWide() / 2, scrPos.y - self.SCPInfo:GetTall() / 2 );
		self.SCPInfo:SetText( "Take D-Class to SCP " .. SCPID .. " for testing." );
	else
		if( self.SCPInfo ) then
			self.SCPInfo:Remove();
			self.SCPInfo = nil;
		end;
	end;
end;


/*
	HOOKS:
*/

function CLASS.Hooks:HUDPaint()
	local client = LocalPlayer();
	if( table.HasValue( self.Teams, client:Team() ) ) then
		local dClass = client:GetDClass();
		local SCPID = client:GetSCP();
		if( !dClass or !dClass:IsValid() ) then
			self:DrawResearcherNotify();
			self:DrawUseNotify();
		else
			if( self.AreaNotify ) then
				self.AreaNotify:Remove();
				self.AreaNotify = nil;
			end;
			if( self.Menu ) then
				self.Menu:Remove();
				self.Menu = nil;
			end;
			self:DrawDClass();
		end;
		self:DrawSCPInfo( client );
	elseif( client:Team() == TEAM_DCLASS ) then
		local researcher = client:GetResearcher();
		if( researcher and researcher:IsValid() ) then
			self:DrawResearcher();
		end;
	elseif( client:IsSecurity() ) then
		self:DrawResearcherInfo();
	end;
	if( !table.HasValue( self.Teams, client:Team() ) ) then
		if( self.AreaNotify ) then
			self.AreaNotify:Remove();
			self.AreaNotify = nil;
		end;
		if( self.Menu ) then
			self.Menu:Remove();
			self.Menu = nil;
		end;
		if( self.SCPInfo ) then
			self.SCPInfo:Remove();
			self.SCPInfo = nil;
		end;
	end;
end;