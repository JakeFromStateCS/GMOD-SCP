--[[
	sh_debug.lua
	For all intensive debugging and printing purposes
]]--
SCP = SCP;
SCP.Debug = {};
SCP.Debug.Enabled = true;
SCP.Debug.TagTitle = "SCP";
SCP.Debug.TagSeparator = "|";
SCP.Debug.Colors = {
	TagText = Color( 255, 50, 50 ),
	Separator = Color( 200, 200, 0 )
};

function SCP.Debug:Print( message, color )
	local realm = "SH";
	if( SERVER and not CLIENT ) then
		realm = "SV";
	end;
	if( CLIENT and not SERVER ) then
		realm = "CL";
	end;
	MsgC( self.Colors.TagText, self.TagTitle .. "-" .. realm .. " " );
	MsgC( self.Colors.Separator, self.TagSeparator .. " " );
	MsgC( ( color or Color( 255, 255, 255 ) ), message .. "\n" );
end;