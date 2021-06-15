--[[
	Plague doctor sh_init.lua
]]--

CLASS = CLASS or {};

local pMeta = FindMetaTable( "Player" );


function pMeta:IsChaos()
	if( table.HasValue( SCP.Classes[001].Teams, self:Team() ) ) then
		return true;
	end;
	return false;
end;