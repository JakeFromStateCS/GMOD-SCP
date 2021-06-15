surface.CreateFont( "squad_status_display_name", {
	font = "Tahoma",
	size = 16,
	weight = 300
} );

surface.CreateFont( "squad_status_display_label", {
	font = "Tahoma",
	size = 12,
	weight = 300
} );

surface.CreateFont( "squad_status_display_job", {
	font = "Tahoma",
	size = 12,
	weight = 300
} );


local PANEL = {};


function PANEL:Init()
	self:SetSize( 200, ScrH() - 95 );
	self:SetPos( ScrW() - self:GetWide(), 32 );
	self.list = vgui.Create( "DPanelList", self );
	self.list:SetSize( self:GetWide() - 2, self:GetTall() - 40 );
	self.list:SetPos( 1, 40 );
	self.list:SetDrawBackground( false );
	self.clients = {};
end;


function PANEL:AddClient( client )
	local panel = vgui.Create( "squad_status_display" );
	panel:SetClient( client );
	self.list:AddItem( panel );
	self.clients[client] = panel;
end;


function PANEL:RemoveClient( client )
	local panel = self.clients[client];
	self.list:RemoveItem( panel );
	self.clients[client] = nil;
end;


function PANEL:Paint( w, h )
	--surface.SetDrawColor( Color( 250, 250, 250, 100 ) );
	--surface.DrawRect( 0, 0, w, h );
	surface.SetDrawColor( Color( 50, 50, 50 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
	surface.DrawRect( 0, 0, w, 40 );
	surface.SetFont( "flatUI TitleText medium" );
	local textW, textH = surface.GetTextSize( "Squad:" );
	draw.SimpleText( "Squad:", "flatUI TitleText medium", textW / 2 + 10, 20, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
end;
vgui.Register( "squad_status_container", PANEL, "DPanel" );


local PANEL = {};

function PANEL:Init()
	self:SetSize( 200, 60 );
	self.playerIcon = vgui.Create( "DModelPanel", self );
	self.playerIcon:SetPos( 4, 2 );
	self.playerIcon:SetSize( self:GetTall() - 4, self:GetTall() - 4 );
	function self.playerIcon:PaintOver( w, h )
		local parent = self:GetParent();
		if( parent.client ) then
			if( parent.client:IsValid() ) then
				local col = team.GetColor( parent.client:Team() );
				if( parent.client:GetNWBool( "Disguise" ) == true ) then
					local strCol = self.client:GetDisTeamColour();
					local split = string.Split( strCol, "," );
					col = Color( split[1], split[2], split[3], split[4] );
				end;
				--Team text
				surface.SetFont( "squad_status_display_job" );
				local jobW, jobH = surface.GetTextSize( team.GetName( parent.client:Team() ) );
				draw.SimpleTextOutlined( team.GetName( parent.client:Team() ), "squad_status_display_job", w / 2 - jobW / 2, h - jobH - 2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0 ) );
				if( jobW > 60 - 4 ) then
					local difference = jobW - w;
					parent:SetWide( parent:GetWide() + difference + 16 );
					parent:SetTall( parent:GetTall() + difference + 16 );
					self:SetWide( jobW + 16 );
					self:SetTall( self:GetWide() );
					local dList = parent:GetParent():GetParent();
					dList:Rebuild();
				else
					if( jobW < 60 - 4 ) then
						if( self:GetWide() > 54 ) then
							parent:SetSize( 200, 60 );
							self:SetSize( parent:GetTall() - 4, parent:GetTall() - 4 );
							local dList = parent:GetParent():GetParent();
							dList:Rebuild();
						end;
					end;
				end;
			end;	
		end;
		surface.SetDrawColor( Color( 50, 50, 50 ) );
		surface.DrawOutlinedRect( 0, 0, w, h );
		if( parent.client ) then
			if( parent.client:IsValid() ) then
				if( parent.client:IsSpeaking() ) then
					surface.SetDrawColor( Color( 50, 200, 50 ) );
					surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 );	
				end;
			end;	
		end;
	end;
end;

function PANEL:SetClient( client )
	self.client = client;
	self.model = client:GetModel();
	self.playerIcon:SetModel( client:GetModel() );
	self.playerIcon:SetCamPos( Vector( 15, 0, 63 ) );
	self.playerIcon:SetLookAt( Vector( 0, 0, 63 ) );
end;

function PANEL:Paint( w, h )
	surface.SetDrawColor( Color( 250, 250, 250 ) );
	surface.DrawRect( 0, 0, w, h );
	surface.SetDrawColor( Color( 50, 50, 50 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
	
	local col = Color( 50, 50, 50 );
	--Bar
	if( self.client ) then
		if( self.client:IsValid() ) then
			if( self.client:Alive() ) then
				if( self.client:GetNWBool( "Disguised" ) == true ) then
					local strCol = self.client:GetDisTeamColour();
					local split = string.Split( strCol, "," );
					col = Color( split[1], split[2], split[3], split[4] );
				else
					col = team.GetColor( self.client:Team() );
				end;
			end;
			
			--Name text
			surface.SetFont( "squad_status_display_name" );
			local nickW, nickH = surface.GetTextSize( self.client:Nick() );
			local textX = ( self.playerIcon:GetWide() + 4 ) + ( w - self.playerIcon:GetWide() - 4 ) / 2 - nickW / 2;
			draw.SimpleTextOutlined( self.client:Nick(), "squad_status_display_name", textX, 0, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color( 0, 0, 0 ) );
			
			--Health bar
			local health = self.client:Health();
			local maxWidth = w - ( self.playerIcon:GetWide() + 4 );
			local barX = self.playerIcon:GetWide() + 4;
			local barH = h / 6;
			local healthW = math.Clamp( maxWidth / self.client:GetMaxHealth() * health, 0, maxWidth );
			surface.SetDrawColor( Color( 255, 100, 100 ) );
			surface.DrawRect( barX + 1, h - barH - 2, healthW - 3, barH );
			surface.SetDrawColor( Color( 50, 50, 50 ) );
			surface.DrawOutlinedRect( barX + 1, h - barH - 2, maxWidth - 3, barH );
			
			surface.SetFont( "squad_status_display_label" );
			local hLabelW, hLabelH = surface.GetTextSize( "Health:" );
			draw.SimpleText( "Health:", "squad_status_display_label", barX + 2, h - h / 6 - 1 - hLabelH, Color( 50, 50, 50 ) );
		
			--Ammo bar
			local weapon = self.client:GetActiveWeapon();
			if( weapon ) then
				if( weapon:IsValid() ) then
					if( weapon.Primary ) then
						if( weapon.Primary.ClipSize ) then
							local name = weapon.PrintName or "";
							local maxClip = weapon.Primary.ClipSize;
							local ammo = weapon:Clip1();
							if( maxClip ~= 0 and maxClip ~= -1 ) then
								local ammoW = maxWidth / maxClip * ammo;
								surface.SetDrawColor( Color( 250, 200, 100 ) );
								surface.DrawRect( barX + 1, h - barH * 2 - hLabelH, ammoW - 3, barH );
								surface.SetDrawColor( Color( 50, 50, 50 ) );
								surface.DrawOutlinedRect( barX + 1, h - barH * 2 - hLabelH, maxWidth - 3, barH );
							
								surface.SetFont( "squad_status_display_label" );
								local aLabelW, aLabelH = surface.GetTextSize( "Ammo: " .. name );
								draw.SimpleText( "Ammo: " .. name, "squad_status_display_label", barX + 2, h - barH * 2 - hLabelH - aLabelH, Color( 50, 50, 50 ) );
		
							end;	
						end;
					end;
				end;
			end;
		end;
	end;
	surface.SetDrawColor( col );
	surface.DrawRect( 0, 1, 4, h - 2 );
end;

function PANEL:Think()
	if( self.client ) then
		if( self.client:IsValid() ) then
			if( self.client:GetModel() ~= self.playerIcon:GetModel() ) then
				self.playerIcon:SetModel( self.client:GetModel() );
				self.playerIcon:SetCamPos( Vector( 15, 0, 63 ) );
				self.playerIcon:SetLookAt( Vector( 0, 0, 63 ) );
			end;
		end;
	end;
end;

vgui.Register( "squad_status_display", PANEL, "DPanel" );