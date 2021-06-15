--[[
	sh_libraries.lua
]]--

function SCP:LoadLibraries()
	local libraryPath = "scp/libraries/";
	local files, folders = file.Find( libraryPath .. "*", "LUA" );
	local necessary = {
		"debug",
		"hooks",
		"netmsg"
	};
	local loadOrder = {
		"sh",
		"sv",
		"cl"	
	};
	for _,folder in pairs( necessary ) do
		print( "SCP | Loading Library: " .. folder );
		local path = libraryPath .. folder .. "/";
		for _,prefix in pairs( loadOrder ) do
			local subPath = path .. prefix .. "_*.lua";
			local files = file.Find( subPath, "LUA" );
			for _,file in pairs( files ) do
				if( SERVER ) then
					if( prefix ~= "sv" ) then
						AddCSLuaFile( path .. file );
					end;
					if( prefix ~= "cl" ) then
						include( path .. file );
					end;
				elseif( CLIENT ) then
					if( prefix ~= "sv" ) then
						include( path .. file );
					end;
				end;
			end;
		end;
	end;
	for _,folder in pairs( folders ) do
		if( table.HasValue( necessary, folder ) ) then
			continue;
		end;
		print( "SCP | Loading Library: " .. folder );
		local path = libraryPath .. folder .. "/";
		for _,prefix in pairs( loadOrder ) do
			local subPath = path .. prefix .. "_*.lua";
			local files = file.Find( subPath, "LUA" );
			for _,file in pairs( files ) do
				if( SERVER ) then
					if( prefix ~= "sv" ) then
						AddCSLuaFile( path .. file );
					end;
					if( prefix ~= "cl" ) then
						include( path .. file );
					end;
				elseif( CLIENT ) then
					if( prefix ~= "sv" ) then
						include( path .. file );
					end;
				end;
			end;
		end;
	end;
end;