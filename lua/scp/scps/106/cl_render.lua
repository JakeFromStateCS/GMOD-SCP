
-- Setup variables
wp.matView = CreateMaterial(
	"UnlitGeneric",
	"GMODScreenspace",
	{
		["$basetexturetransform"] = "center .5 .5 scale -1 -1 rotate 0 translate 0 0",
		["$texturealpha"] = "0",
		["$vertexalpha"] = "1",
	}
)
wp.matDummy = Material( "debug/white" )

wp.portals = {}
wp.drawing = true --default portals to not draw

-- Start drawing the portals
-- This prevents the game from crashing when loaded for the first time
hook.Add( "PostRender", "WorldPortals_StartRender", function()
	wp.drawing = false
	hook.Remove( "PostRender", "WorldPortals_StartRender" )
end )

function wp.shouldrender( portal )
	local camOrigin = GetViewEntity():GetPos()
	local exitPortal = portal:GetExit()
	local distance = camOrigin:Distance( portal:GetPos() )
	local disappearDist = portal:GetDisappearDist()
	
	local override=hook.Call("wp-shouldrender", GAMEMODE, portal, exitPortal, plyOrigin)
	if override ~= nil then return override end
	
	if not IsValid( exitPortal ) then return false end
	
	if not (disappearDist <= 0) and distance > disappearDist then return false end
	
	--don't render if the view is behind the portal
	local behind = wp.IsBehind( camOrigin, portal:GetPos(), portal:GetForward() )
	if behind then return false end
	
	

	return true
end



-- Render views from the portals
hook.Add( "RenderScene", "WorldPortals_Render", function( plyOrigin, plyAngle )

	wp.portals = ents.FindByClass( "linked_portal_door" )

	if ( not wp.portals ) then return end
	if ( wp.drawing ) then return end

	-- Disable phys gun glow and beam
	local oldWepColor = LocalPlayer():GetWeaponColor()
	LocalPlayer():SetWeaponColor( Vector(0, 0, 0) )
	
	for _, portal in pairs( wp.portals ) do

		local exitPortal = portal:GetExit()

		if not wp.shouldrender( portal, exitPortal, plyOrigin ) then continue end
		if not portal:GetShouldDrawNextFrame() then continue end
		portal:SetShouldDrawNextFrame( false )
		
		hook.Call("wp-prerender", GAMEMODE, portal, exitPortal, plyOrigin)
		
		local oldRT = render.GetRenderTarget()
		render.SetRenderTarget( portal:GetTexture() )
			render.Clear( 0, 0, 0, 255 )
			render.ClearDepth()
			render.ClearStencil()

			render.EnableClipping(true)
			render.PushCustomClipPlane( exitPortal:GetForward(), exitPortal:GetForward():Dot(exitPortal:GetPos() - (exitPortal:GetForward() *0.5) ) )

			local camOrigin = wp.TransformPortalPos( plyOrigin, portal, exitPortal )
			local camAngle = wp.TransformPortalAngle( plyAngle, portal, exitPortal )

			wp.drawing = true
			wp.drawingent = portal
				render.RenderView( {
					x = 0,
					y = 0,
					w = ScrW(),
					h = ScrH(),
					origin = camOrigin,
					angles = camAngle,
					drawpostprocess = true,
					drawhud = false,
					drawmonitors = false,
					drawviewmodel = false,
					zfar = 1500
				} )
			wp.drawing = false
			wp.drawingent = nil

			render.PopCustomClipPlane()
			render.EnableClipping(false)
		render.SetRenderTarget( oldRT )
		
		hook.Call("wp-postrender", GAMEMODE, portal, exitPortal, plyOrigin)
	end

	LocalPlayer():SetWeaponColor( oldWepColor )
end )

--[[ causes player to see themselves in first person sometimes (particularly in multiplayer)
hook.Add("ShouldDrawLocalPlayer", "WorldPortals_Render", function()
	if wp.drawing then
		return true
	end
end)
]]--