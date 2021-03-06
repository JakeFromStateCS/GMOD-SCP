
include( "shared.lua" )

AccessorFunc( ENT, "texture", "Texture" )
AccessorFunc( ENT, "shouldDrawaNextFrame", "ShouldDrawNextFrame" )


-- Draw world portals
function ENT:Draw()

	if wp.drawing then return end
	if not wp.shouldrender(self) then return end

	self:SetNWInt( "DrawHeight", math.Approach( self:GetNWInt( "DrawHeight" ), self:GetHeight(), 6 ) );
	self:SetNWInt( "DrawWidth", math.Approach( self:GetNWInt( "DrawWidth" ), self:GetWidth(), 3 ) );
	self:SetShouldDrawNextFrame( true )

	render.ClearStencil()
	render.SetStencilEnable( true )

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )

	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilReferenceValue( 1 )
	
	render.SetMaterial( wp.matDummy )
	render.SetColorModulation( 1, 1, 1 )

	render.DrawQuadEasy( self:GetPos() -( self:GetForward() *5), self:GetForward(), self:GetNWInt( "DrawWidth" ), self:GetNWInt( "DrawHeight" ), Color( 255, 255, 255, 255), self:GetAngles().roll )
	
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilReferenceValue( 1 )
	
	wp.matView:SetTexture( "$basetexture", self:GetTexture() )
	render.SetMaterial( wp.matView )
	render.DrawScreenQuad()
	
	render.SetStencilEnable( false )
end