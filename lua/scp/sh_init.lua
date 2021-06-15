--[[
	sh_init.lua
	Let them be
	Secured.
	Contained.
	and
	Protected.
]]--

SCP = {};
SCP.Libraries = {};
local _SCP = SCP;
SCP = {};
SCP.Libraries = _SCP.Libraries;
local _SCPMT = {
	__index = function( table, key )
		local tab = _SCP[key];
		if( type( tab ) == "table" ) then
			if( tab.OnLoad ) then
				_SCP.Libraries[key] = true;
			end;
		end;
		return tab;
	end,
	__newindex = function( table, key, value )
		_SCP[key] = value;
		if( key == "OnLoad" ) then
			_SCP[key]( _SCP );
		end;
		if( type( value ) == "table" ) then
			if( value.OnLoad ) then
				_SCP.Libraries[key] = true;
			else
				_SCP.Libraries[key] = false;
			end;
		end;
	end
};
setmetatable( SCP, _SCPMT );

function SCP:HandleFile( path, file )
	local prefix = string.sub( file, 1, 2 );
	local fullPath = path .. file;
	--TEMP PRINT
	if( SCP.Debug ) then
		if( SCP.Debug.Enabled ) then
			SCP.Debug:Print( "Handling File: " .. fullPath );
		end;
	else
		print( "SCP | Handling File: " .. fullPath );
	end;

	if( SERVER ) then
		if( prefix ~= "sv" ) then
			AddCSLuaFile( fullPath );
		end;
		if( prefix ~= "cl" ) then
			include( fullPath );
		end;
	elseif( CLIENT ) then
		if( prefix ~= "sv" ) then
			include( fullPath );
		end;
	end;
	if( _SCP.TempLoad ) then
		local library = SCP[_SCP.TempLoad];
		if( library ) then
			if( library.OnLoad ) then
				library:OnLoad();
				_SCP.TempLoad = nil;
			end;
		end;
	end;
end;


function SCP:CallOnLoads()
	for library,val in pairs( self.Libraries ) do
		if( val == true ) then
			local library = self[library];
			library:OnLoad();
		end;
	end;
end;

function SCP:OnLoad()
	SCP:HandleFile( "scp/", "sh_libraries.lua" );
	self:LoadLibraries();
	self:CallOnLoads();
end;

SCP.Loaded = true;

/*
	HOOKS:
*/

--Load all the shit yo;
--It's really sad that I have to do this
--But DarkRP really doesn't have a hook for when it's done loading the mods
--AKA the shit that's in the modifications folder
--So rather unneccessarily we have to load it on a delay, then on the client
--Add a fucking think hook to detect when they're valid.
function SCP.Hooks:DarkRPFinishedLoading()
	timer.Simple( 2, function()
		SCP:OnLoad()
		SCP:DefineSecurity();
	end );
end;