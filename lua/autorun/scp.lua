/*
	Coded by Matt Anderson
	Hello moto
*/
if( SERVER ) then
	AddCSLuaFile( "scp/cl_init.lua" );
	include( "scp/sv_init.lua" );
else
	include( "scp/cl_init.lua" );
end;
