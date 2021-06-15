--[[
	Statue sh_init.lua
]]--

CLASS = CLASS or {};

local pMeta = FindMetaTable( "Player" );


--Is the player a statue
function pMeta:IsStatue()
	return ( self:Team() == SCP.Classes[173].Team );
end;



--Set whether or not the statue can be frozen
function pMeta:SetCanFreeze( bool )
	self:SetNWBool( "Freezable", bool );
end;



--Can we freeze this mofo
function pMeta:CanFreeze()
	return self:GetNWBool( "Freezable" );
end;



--Get frozen status
function pMeta:GetFrozen()
	return self:GetNWBool( "Frozen" );
end;

 

--Set frozen status
function pMeta:SetFrozen( bool )
	self:SetNWBool( "Frozen", bool );
	if( !bool ) then
		self:UnLock();
	end;
end;