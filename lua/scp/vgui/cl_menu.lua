SCP.Menu = {};
--Create a base menu
--Allow any plugin to parent a panel to it

function SCP.Menu:OnLoad()
	local menu = self:GetMenu();
	if( menu ) then
		menu:Remove();
	end;
end;

function SCP.Menu:GetMenu()
	return LocalPlayer().SCPMenu;
end;

function SCP.Menu:CreateMenu()
	if( LocalPlayer().SCPMenu ) then
		LocalPlayer().SCPMenu:Remove();
	end;

	local menu =  vgui.Create( "flatUI_Frame" );
	menu:SetTitle( "TimeOfEve SCP" );
	menu:MenuButtonVisible( false );
	menu:SetDraggable( false );
	menu:SetThemeColor( Color( 96, 0, 0 ) );
	menu:SetSize( 400, 400 );
	menu:Center();
	menu:Hide();

	LocalPlayer().SCPMenu = menu;
end;

function SCP.Menu:HideMenu()
	local menu = self:GetMenu();
	if( menu and menu:IsValid() ) then
		menu:Hide();
	end;
end;

function SCP.Menu:ShowMenu()
	local menu = self:GetMenu();
	if( menu and menu:IsValid() ) then
		menu:Show();
	else
		self:CreateMenu();
		menu:Show();
	end;
end;

function SCP.Menu:ShowLibraryMenu( library )
	local library = SCP[library];
	if( library ~= nil ) then
		--
	end;
end;

function SCP.Menu:ShowClassMenu( id )
	self:HideMenu();
	local menu = self:GetMenu();
	if( menu.Panel ) then
		menu.Panel:Remove();
	end;
	local panel = vgui.Create( "SCP_" .. id .. "_Menu", menu );
	panel:SetSize( menu:GetWide(), menu:GetTall() - 32 );
	panel:Center();
	menu.Panel = panel;
	self:ShowMenu();
end;
