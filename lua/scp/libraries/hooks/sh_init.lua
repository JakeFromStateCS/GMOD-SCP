SCP = SCP or {};
SCP.Hooks = {};
SCP.Hooks.Stored = {};
function SCP.Hooks:__newindex( hookType, func )
	/*
		SCP.Hooks[049] = {
			PlayerInitialSpawn = func,
			EntityTakeDamage = func
		}
	*/
	SCP:RegisterHook( hookType, func );
end;
setmetatable( SCP.Hooks, SCP.Hooks );


function SCP:RegisterHook( hookType, func )
	local name = "SCP_" .. hookType;
	hook.Add( hookType, name, function( ... )
		local retVal;
		for library,_ in pairs( self.Libraries ) do
			local library = self[library];
			if( library.Hooks ) then
				if( library.Hooks[hookType] ) then
					retVal = library.Hooks[hookType]( library, ... );
				end;
			end;
		end;
		retVal = func( self, ... );
		return retVal;
	end );
	SCP.Hooks.Stored[name] = func;
end;