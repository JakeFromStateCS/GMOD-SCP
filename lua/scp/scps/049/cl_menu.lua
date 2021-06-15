--Create menu
--Position menu
--Set the visiblity on the main panel
--Each class menu is registered from the class library

CLASS = CLASS or {};

CLASS.Panel = {};

function CLASS.Panel:Init()
	self.Button = vgui.Create( "flatUI_Button", self );
	self.Button:SetSize( self:GetWide(), self:GetTall() );
	self.Button:SetText( "Hello" );
end;