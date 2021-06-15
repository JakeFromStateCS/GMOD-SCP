AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );


function ENT:Initialize()
	self.AllowedTeams = {};
	self:SetModel( "models/hunter/plates/plate1x1.mdl" );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS );
	local trace = {
		start = self:GetPos(),
		endpos = self:GetPos() + self:GetForward() * 50
	};
	trace = util.TraceLine( trace );
	--self:SetPos( trace.HitPos );
	--self:SetAngles( self:GetForward() * trace.HitNormal );
	local phys = self:GetPhysicsObject();
	if( phys:IsValid() ) then
		phys:EnableMotion( false );
	end;

	self.portals={}
	self.portals[1]=ents.Create("linked_portal_door")
	self.portals[2]=ents.Create("linked_portal_door")
	self.portals[1]:SetParent( self );
	self.portals[2]:SetParent( self );
	
	self:CreateOpening();
	self:EmitSound( "ambient/machines/teleport1.wav" );
end;


function ENT:SetClient( client )
	self.Client = client;
	self:CreateExit( client );
end;


function ENT:GetThickness( client, maxThickness )
	local trace = client:GetEyeTrace();
	local hitPos = trace.HitPos;
	local hitNormal = trace.HitNormal;
	if( hitPos ) then
		local thickness = 0;
		for i=1, maxThickness do
			local trace = {
				start = hitPos - hitNormal * i,
				endpos = hitPos - hitNormal * ( i + 1 ),
				filter = { client, self }
			};
			trace = util.TraceLine( trace );
			if( trace.HitWorld ) then
				thickness = thickness + 1;
			else
				break;
			end;
		end;
		self.Thickness = thickness;
		return thickness;
	end;
end;



function ENT:CreateOpening()
	self.portals[2]:SetDisappearDist(1000)
	self.portals[2]:SetWidth(60)
	self.portals[2]:SetHeight(91)
	self.portals[2]:SetPos( self:GetPos() - self:GetForward() * 10 - self:GetUp() * 10 );
	self.portals[2]:SetAngles(self:LocalToWorldAngles(Angle(90,0,0)))
	self.portals[2]:SetExit(self.portals[1])
	self.portals[2]:Spawn()
	self.portals[2]:Activate()
end;



function ENT:CreateExit( client )
	local forward = client:GetForward();
	local trace = client:GetEyeTrace();
	forward.z = 0;
	local pos = self:GetPos() + self:GetUp() * ( self.MaxDist + 10 ) - self:GetForward() * 10;
	self.portals[1]:SetDisappearDist(1000)
	self.portals[1]:SetWidth(60)
	self.portals[1]:SetHeight(91)
	self.portals[1]:SetPos( pos )
	self.portals[1]:SetAngles( self:GetAngles() + Angle( -90, 0, 180 ) );
	self.portals[1]:SetExit(self.portals[2])
	self.portals[1]:Spawn()
	self.portals[1]:Activate()
end;