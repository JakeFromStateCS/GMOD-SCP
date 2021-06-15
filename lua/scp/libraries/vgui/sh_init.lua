--[[
	sh_vgui.lua
]]--
SCP.vgui = {};

function SCP.vgui:Load()
	local vguiPath = "SCP/vgui/";
	local files, folders = file.Find( vguiPath .. "*.lua", "LUA" );
	for _,fileName in pairs( files ) do
		local path = vguiPath .. fileName;
		if( SERVER ) then
			AddCSLuaFile( path );
		elseif( CLIENT ) then
			include( path );
		end;
	end;
end;

SCP.vgui:Load();