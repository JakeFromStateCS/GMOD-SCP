SCP.Nets = {};
local meta = {};
function meta:__newindex( key, value )
	SCP:RegisterNet( key, value );
end;
setmetatable( meta, SCP.Nets );


if( SERVER ) then
	util.AddNetworkString( "SCP_NetMsg" );
end;

function SCP:RegisterNet( netName, func )
	if( SCP.Debug ) then
		if( SCP.Debug.Enabled ) then
			SCP.Debug:Print( "Registering net: " .. netName );
		end;
	else
		print( "SCP | Registering Net:" .. netName );
	end;
end;

function SCP:NetMessage( client, netMsg, ... )
	local tab = { ... }
	local clients = {};
	if( type( client ) == "string" ) then
		table.insert( tab, 1, netMsg );
		netMsg = client;
		client = nil;
		clients = player.GetAll();
	elseif( type( client ) == "table" ) then
		for k,v in pairs( client ) do
			if( type( v ) == "Player" ) then
				table.insert( clients, v );
			end;
		end;
	elseif( type( client ) == "Player" ) then
		clients = client;
	end;

	if( SCP.Debug.Enabled ) then
		SCP.Debug:Print( "Starting Message " ..  netMsg .. "\n", Color( 255, 255, 255 ) );
	end;
		
	local types = {
		["Number"] = "Double",
		["NextBot"] = "Entity",
		["Player"] = "Entity",
		["NPC"] = "Entity",
		["Table"] = "Table",
		["Boolean"] = "Bool"
	}
	net.Start( "SCP_NetMsg" );
		if( CLIENT ) then
			net.WriteEntity( LocalPlayer() );
		end;
		net.WriteString( netMsg );
		for k,v in pairs( tab ) do
			local typeName = type( v ):gsub("^%l", string.upper);
			if( types[typeName] ) then
				typeName = types[typeName];
			end;
			local func = net["Write" .. typeName];
			if( func ) then
				func( v );
			end;
		end;
	if( CLIENT ) then
		net.SendToServer();
	else
		net.Send( clients );
	end;
end;

function SCP.NetReceive()
	local client;
	if( SERVER ) then
		client = net.ReadEntity();
	end;
	local netMsg = net.ReadString();
	if( netMsg ) then
		local func = SCP.Nets[netMsg];
		if( func ) then
			if( SCP.Debug.Enabled ) then
				SCP.Debug:Print( "Receiving Message " ..  netMsg .. "\n", Color( 255, 255, 255 ) );
			end;
			if( SERVER ) then
				func( client );
			else
				func();
			end;
		end;
	end;
end;
net.Receive( "SCP_NetMsg", SCP.NetReceive );

if( SCP.Debug ) then
	if( SCP.Debug.Enabled ) then
		SCP.Debug:Print( "Nets Loaded!" );
	end;
end;