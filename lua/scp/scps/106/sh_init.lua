--[[
	Plague doctor sh_init.lua
]]--

local pMeta = FindMetaTable( "Entity" );

CLASS = CLASS or {};
CLASS.Hooks = CLASS.Hooks or {};


function CLASS:CanTeleport( client, maxDist )
	local trace = client:GetEyeTrace();
	if( trace.HitNormal.z ~= 0 ) then
		return false;
	end;
	if( trace.HitPos:Distance( client:EyePos() ) > maxDist + 10 ) then
		return false;
	end;
	local point = trace.HitPos + client:GetForward() * maxDist;
	local contents = util.PointContents( point );
	if( contents == CONTENTS_SOLID ) then
		return false;
	end;
	return true;
end;


function pMeta:InPocketDimension()
	return self:GetNWBool( "PocketDimension" );
end;


function pMeta:SetPocketDimension( bool )
	self:SetNWBool( "PocketDimension", bool );
	if( SERVER ) then
		if( bool ) then
			self:SetCustomCollisionCheck( true );
			if( self:IsPlayer() ) then
				self.Ambience = CreateSound( self, "ambient/hallowloop.wav" );
				self.Ambience:ChangeVolume( 100 );
				self.Ambience:Play();
			end;
			self:CollisionRulesChanged();
		else
			self:SetCustomCollisionCheck( false );
			if( self:IsPlayer() ) then
				self.Ambience:Stop();
				self:ConCommand( "stopsound" );
			end;
			self:CollisionRulesChanged();
		end;
	end;
end;


function pMeta:CollisionRulesChanged()
	if not self.m_OldCollisionGroup then self.m_OldCollisionGroup = self:GetCollisionGroup() end
	self:SetCollisionGroup(self.m_OldCollisionGroup == COLLISION_GROUP_DEBRIS and COLLISION_GROUP_WORLD or COLLISION_GROUP_DEBRIS)
	self:SetCollisionGroup(self.m_OldCollisionGroup)
	self.m_OldCollisionGroup = nil;
end;


function CLASS.Hooks:ShouldCollide( ent1, ent2 )
	local ValidClasses = {
		"prop_physics",
		"player",
		"func_door"
	};
	if( ent1:IsValid() and ent2:IsValid() ) then
		if( ent1:InPocketDimension() and !ent2:InPocketDimension() ) then
			if( table.HasValue( ValidClasses, ent1:GetClass() ) ) then
				if( table.HasValue( ValidClasses, ent2:GetClass() ) ) then
					return false;
				end;
			end;
		elseif( ent2:InPocketDimension() and !ent1:InPocketDimension() ) then
			if( table.HasValue( ValidClasses, ent1:GetClass() ) ) then
				if( table.HasValue( ValidClasses, ent2:GetClass() ) ) then
					return false;
				end;
			end;
		end;
	end;
end;


function CLASS.Hooks:EntityCreated( ent )
	if( ent:IsPlayer() ) then
		ent:CollisionRulesChanged();
	end;
end;