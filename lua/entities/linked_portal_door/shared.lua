
ENT.Type				= "anim"
ENT.Spawnable			= false
ENT.AdminOnly			= false
ENT.Editable			= false


function ENT:Initialize()

	local mins = Vector( 0, -self:GetWidth() /2, -self:GetHeight() /2 )
	local maxs = Vector( 10, self:GetWidth() /2, self:GetHeight() /2)

	if CLIENT then

		self:SetTexture( GetRenderTarget("portal" .. self:EntIndex(),
			ScrW(),
			ScrH(),
			false
		) )

		self:SetRenderBounds( mins, maxs )

	else

		self:SetTrigger( true )

	end

	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_OBB )
	self:SetNotSolid( true )
	self:SetCollisionBounds( mins, maxs )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )

	self:DrawShadow( false )
	self:SetNWInt( "DrawHeight", 0 );
	self:SetNWInt( "DrawWidth", 0 );

end


function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "Exit" )
	self:NetworkVar( "Int", 1, "Width" )
	self:NetworkVar( "Int", 2, "Height" )
	self:NetworkVar( "Int", 3, "DisappearDist" )

end
