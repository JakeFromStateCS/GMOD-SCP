local PANEL = {}

function PANEL:Init()
	self:SetSize( 440, 225 );
	local xPos, yPos = ScrW() - self:GetWide() - 15, ScrH() - self:GetTall() - 15;
	self:SetPos( xPos, yPos );
	self.Texture = Material( "keycard/keycard.png" );
	self.playerIcon = vgui.Create( "DModelPanel", self );
	self.playerIcon:SetPos( 14, 48 );
	self.playerIcon:SetSize( 140, 148 );
	self.Number = math.Round( math.random( 1000000, 5000000 ) );
	self.Clearance = 0;
	gui.EnableScreenClicker( true );
end;



function PANEL:SetClient( client )
	self.playerIcon:SetModel( client:GetModel() );
	self.playerIcon:SetCamPos( Vector( 15, 0, 69 ) );
	self.playerIcon:SetLookAt( Vector( 0, 0, 69 ) );
	function self.playerIcon:LayoutEntity( ent )
		local sequence = ent:LookupSequence( "idle" );
		ent:ResetSequence( sequence );
	end;
	self.client = client;
	self.Clearance = self.client:GetClearance();
end;



function PANEL:Paint( w, h )
	surface.SetMaterial( self.Texture );
	surface.SetDrawColor( Color( 255, 255, 255 ) );
	surface.DrawTexturedRect( 0, 0, w, h );

	if( self.client ) then
		draw.SimpleText( string.upper( self.client:Nick() ), "KeycardHUDFont", 190, 103, Color( 41, 58, 116, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );

		draw.SimpleText( self.Clearance, "KeycardHUDFont2", 220, 135, Color( 41, 58, 116, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );

		draw.SimpleText( self.Number, "KeycardHUDFont2", 315, 135, Color( 41, 58, 116, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
	end;
	draw.SimpleText( "Click to close", "KeycardHUDFont", w / 2, 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT );
end;



function PANEL:OnMousePressed()
	self:Remove();
	gui.EnableScreenClicker( false );
end;
vgui.Register( "Keycard_ID", PANEL, "DPanel" );



local PANEL = {};



function PANEL:Init()
	self.allowedTeams = {};
	self:SetSize( 180, 200 );
	self.list = vgui.Create( "DPanelList", self );
	self.list:SetSize( self:GetWide() - 2, self:GetTall() - 40 );
	self.list:SetPos( 1, 40 );
	self.list:SetDrawBackground( false );
end;



function PANEL:ClearList()
	for _,child in pairs( self.list:GetItems() ) do
		child:Remove();
	end;
end;



function PANEL:SetAllowedTeams( teams )
	self.allowedTeams = teams;
	local maxHeight = 0;
	for _,teamID in pairs( teams ) do
		local label = vgui.Create( "DLabel" );
		label:SetFont( "flatUI TitleText small" );
		label:SetText( "  " .. team.GetName( teamID ) );
		label:SizeToContents();
		label:SetTextColor( Color( 50, 50, 50 ) );
		function label:Paint( w, h )
			surface.SetDrawColor( Color( 250, 250, 250, 255 ) );
			surface.DrawRect( 0, 0, w, h );
			surface.SetDrawColor( Color( 50, 50, 50 ) );
			surface.DrawOutlinedRect( 0, 0, w, h );
			surface.SetDrawColor( team.GetColor( teamID ) );
			surface.DrawRect( 1, 1, 4, h - 2 );
		end;
		maxHeight = maxHeight + label:GetTall();
		self.list:AddItem( label );
	end;
	if( self:GetTall() - 40 < maxHeight ) then
		self:SetTall( maxHeight + 40 );
		self.list:SetTall( maxHeight );
	end;
end;



function PANEL:Paint( w, h )
	surface.SetDrawColor( Color( 250, 250, 250, 255 ) );
	surface.DrawRect( 0, 0, w, h );
	surface.SetDrawColor( Color( 50, 50, 50 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
	surface.DrawRect( 0, 0, w, 40 );
	draw.SimpleText( "Allowed Teams:", "flatUI TitleText medium", w / 2, 20, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
	surface.DrawLine( 5, 32, w - 10, 32 );
end;
vgui.Register( "Keycard_AllowedTeams", PANEL, "DPanel" );



function SCP.Hooks:HUDPaint()
	if( !LocalPlayer().IsSecurity ) then
		return;
	end;
	if( LocalPlayer():IsSecurity() or LocalPlayer():IsAdmin() ) then
		local trace = LocalPlayer():GetEyeTrace();
		if( trace.Entity and trace.Entity:IsValid() ) then
			if( trace.Entity:IsPlayer() ) then
				local weapon = trace.Entity:GetActiveWeapon();
				if( weapon:IsValid() ) then
					if( weapon:GetClass() == "weapon_keycard" or weapon:GetClass() == "weapon_admin_keycard" or weapon:GetClass() == "weapon_hacking_keycard" ) then
						local pos = ( trace.Entity:EyePos() - Vector( 0, 0, 15 ) ):ToScreen()
						draw.SimpleText( "Press Use to check ID", "flatUI TitleText medium", pos.x, pos.y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
					end;
				end;
			elseif( trace.Entity:GetClass() == "ent_keycardscanner" and SCP.ClearanceMenu == nil ) then
				if( SCP.ScannerMenu == nil ) then
					local scrPos = trace.Entity:GetPos():ToScreen();
					local level = trace.Entity:GetNWInt( "ClearanceLevel" );
					local allowedTeams = {};
					for _,teamID in pairs( SCP.SecurityClasses ) do
						local clearanceSet = trace.Entity:GetNWBool( "Clearance_Set_" .. teamID );
						local clearance = trace.Entity:GetNWBool( "Clearance_Allowed_" .. teamID );
						if( clearanceSet and clearance or SCP.Clearances[teamID] >= level and !clearanceSet ) then
							table.insert( allowedTeams, teamID );
						end;
					end;
					SCP.ScannerMenu = vgui.Create( "Keycard_AllowedTeams" );
					SCP.ScannerMenu:SetPos( scrPos.x + SCP.ScannerMenu:GetWide() / 2, scrPos.y );
					SCP.ScannerMenu:SetAllowedTeams( allowedTeams );
				else
					local scrPos = trace.Entity:GetPos():ToScreen();
					SCP.ScannerMenu:SetPos( scrPos.x + SCP.ScannerMenu:GetWide() / 2, scrPos.y - SCP.ScannerMenu:GetTall() / 2 );
				end;
			else
				if( SCP.ScannerMenu and SCP.ScannerMenu:IsValid() ) then
					SCP.ScannerMenu:Remove();
					SCP.ScannerMenu = nil;
				end;
			end;
		else
			if( SCP.ScannerMenu and SCP.ScannerMenu:IsValid() ) then
				SCP.ScannerMenu:Remove();
				SCP.ScannerMenu = nil;
			end;
		end;	
	end;
end;



function SCP.Nets:ShowID()
	local client = net.ReadEntity();
	if( client ) then
		if( SCP.ID == nil ) then
			SCP.ID = vgui.Create( "Keycard_ID" );
			SCP.ID:SetClient( client );
		else
			SCP.ID:Remove();
			SCP.ID = nil;
			SCP.ID = vgui.Create( "Keycard_ID" );
			SCP.ID:SetClient( client );
		end;
	end;
end;


function SCP.Nets:ShowFakeID()
	local client = net.ReadEntity();
	if( client ) then
		if( SCP.ID == nil ) then
			SCP.ID = vgui.Create( "Keycard_ID" );
			SCP.ID:SetClient( client );
			SCP.ID.Clearance = math.random( 1, 10 );
		else
			SCP.ID:Remove();
			SCP.ID = nil;
			SCP.ID = vgui.Create( "Keycard_ID" );
			SCP.ID:SetClient( client );
			SCP.ID.Clearance = math.random( 1, 10 );
		end;
	end;
end;



function SCP.Nets:DefineSecurity()
	SCP:DefineSecurity();
end;