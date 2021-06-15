SCP.Classes = {};
SCP.Classes.Stored = {};

local meta = FindMetaTable( "Player" );



function SCP.Classes:OnLoad()
	self:LoadClasses();
end;



function SCP.Classes:RegisterPanel( CLASS )
	local panel = CLASS.Panel;
	if( panel ) then
		vgui.Register( "SCP_" .. CLASS.ID .. "_Menu", panel, "flatUI_Panel" );
	end;
end;



function SCP.Classes:RegisterNets( CLASS )
	local nets = CLASS.Nets or {};
	for netMsg,func in pairs( nets ) do
		SCP.Nets[netMsg] = function( client )
			if( SERVER ) then
				func( CLASS, client );
			else
				func( CLASS );
			end;
		end;
	end;
end;



function SCP.Classes:RegisterHooks( CLASS )
	local hooks = CLASS.Hooks or {};
	for hookType,func in pairs( hooks ) do
		hook.Remove( hookType, "SCP_" .. CLASS.ID .. "_" .. hookType );
		hook.Add( hookType, "SCP_" .. CLASS.ID .. "_" .. hookType, function( ... )
			local CLASS = CLASS or SCP.Classes[CLASS.ID];
			if( CLASS == nil ) then
				return;
			end;
			return func( CLASS, ... );
		end );

		if( SCP.Debug.Enabled ) then
			SCP.Debug:Print( "Registered " .. CLASS.ID .. "-Hook: " .. hookType );
		end;
	end;
end;



function SCP.Classes:RegisterClass( CLASS )
	SCP.Classes[CLASS.ID] = CLASS;
	SCP.Classes.Stored[CLASS.ID] = CLASS;
	self:RegisterNets( CLASS );
	self:RegisterHooks( CLASS );
	self:RegisterPanel( CLASS );
	if( CLASS.OnLoad ) then
		CLASS:OnLoad();
	end;
	if( SCP.Debug.Enabled ) then
		SCP.Debug:Print( "Loaded Class: " .. CLASS.ID .. " - " .. CLASS.Name );
	end;
	CLASS = {};
end;



function SCP.Classes:LoadClasses()
	local loadOrder = {
		"sh",
		"sv",
		"cl"
	};


	local files, folders = file.Find( "scp/scps/*", "LUA" );
	
	for _,folder in pairs( folders ) do
		CLASS = {};
		CLASS.Hooks = {};
		CLASS.Nets = {};
		local path = "scp/SCPs/" .. folder .. "/";
		local info = path .. "sh_info.lua";
		--Skip this SCP if the info file doesn't exist;
		if( !file.Exists( info, "LUA" ) ) then
			continue;
		end;
		for _,prefix in pairs( loadOrder ) do
			local files = file.Find( path .. prefix .. "_*.lua", "LUA" );
			for _,fileName in pairs( files ) do
				--Defined in sh_init.lua;
				SCP:HandleFile( path, fileName );
			end;
		end;
		SCP.Classes:RegisterClass( CLASS );
	end;
end;