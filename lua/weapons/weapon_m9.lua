AddCSLuaFile()

SWEP.PrintName = "Tranquilizer"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.UseHands = false
SWEP.ViewModelFOV = 90;
SWEP.HoldType = "pistol";

SWEP.Slot = 1
SWEP.SlotPos = 3

SWEP.DrawWeaponInfoBox = false

SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip= 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

function SWEP:Deploy()
	self:SetHoldType( self.HoldType );
end;

function SWEP:ShootBullet( damage, num, aimcone )
	local bullet = {}

	bullet.Num 	= num
	bullet.Src 	= self.Owner:GetShootPos()
	bullet.Dir 	= self.Owner:GetAimVector()
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )
	bullet.Tracer	= 5
	bullet.Force	= 1
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	
	function bullet.Callback( pl, tr, dmg )
		local victim = tr.Entity
		local hitgroup = tr.HitGroup
		
		if ( IsValid( victim ) and victim:IsPlayer() ) then
			local time
			if ( hitgroup == HITGROUP_HEAD ) then
				time = 0
			elseif ( hitgroup == HITGROUP_CHEST ) then
				time = 10
			elseif ( hitgroup == HITGROUP_STOMACH ) then
				time = 20
			else
				time = 30
			end
			
	
			if ( victim.TranqTime ) then
				victim.TranqTime = victim.TranqTime - ( 1 - ( time / 30 ) ) * 15
			else
				victim.TranqTime = CurTime() + time
			end
		end
	end
	
	self.Owner:FireBullets( bullet );
	
	self:ShootEffects()
end

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack() ) then
		self:SetNextPrimaryFire( CurTime() + 0.5 )
		
		self:ShootBullet( 0.1, 1, 0 )
		self:EmitSound( "weapons/usp/usp1.wav" )
		
		self:TakePrimaryAmmo( 1 );
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if ( self:DefaultReload( ACT_VM_RELOAD ) ) then
		self:EmitSound( "weapons/pistol/pistol_reload1.wav" )
	end
end

if SERVER then	
	local function CreateTranqRagdoll( pl )
		local ragdoll = ents.Create( "prop_ragdoll" )
		ragdoll:SetModel( pl:GetModel() )
		ragdoll:SetPos( pl:GetPos() + Vector( 0, 0, 5 ) )
		ragdoll:SetAngles( pl:GetAngles() )
		ragdoll:Spawn()
		
		for i = 1, ragdoll:GetPhysicsObjectCount() - 1 do
			local bone = ragdoll:GetPhysicsObjectNum( i )
			
			if ( IsValid( bone ) ) then
				local pl_bonepos, pl_boneang = pl:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
				
				bone:SetPos( pl_bonepos )
				bone:SetAngles( pl_boneang )
				bone:SetVelocity( pl:GetVelocity() )
			end
		end
		
		pl.TranqRagdoll = ragdoll
		timer.Simple( 0.1, function()
			net.Start( "TranqRagdoll" )
				net.WriteEntity( pl )
				net.WriteEntity( ragdoll )
			net.Broadcast()
		end )
		
		return ragdoll
	end
	
	CreateConVar( "m9_tranqtime", 30, FCVAR_ARCHIVE )
	
	util.AddNetworkString( "TranqRagdoll" )
	hook.Add( "PlayerTick", "TranqPlayers", function( pl )
		if ( pl.TranqTime and pl.TranqTime < CurTime() ) then
			if ( string.find( pl:GetModel(), "female" ) ) then
				pl:EmitSound( "vo/npc/female01/pain01.wav" )
			elseif ( string.find( pl:GetModel(), "male" ) ) then
				pl:EmitSound( "vo/npc/male01/pain04.wav" )
			elseif ( string.find( pl:GetModel(), "combine" ) or string.find( pl:GetModel(), "police" ) ) then
				pl:EmitSound( "npc/metropolice/vo/shit.wav" )
			end
			
			pl.TranqWeapons = {} 
			
			for _, wep in ipairs( pl:GetWeapons() ) do
				table.insert( pl.TranqWeapons, wep:GetClass() )
			end
			
			pl:StripWeapons()
			
			local ragdoll = CreateTranqRagdoll( pl )
			
			pl:Spectate( OBS_MODE_CHASE )
			pl:SpectateEntity( ragdoll )
			
			pl.WakeTime = CurTime() + GetConVarNumber( "m9_tranqtime" )
			pl:ScreenFade( SCREENFADE.OUT, color_black, 1, GetConVarNumber( "m9_tranqtime" ) )
			
			pl.TranqTime = nil
		end
		
		if ( pl.WakeTime and pl.WakeTime < CurTime() ) then
			local health, armor = pl:Health(), pl:Armor()
			
			pl:UnSpectate()
			pl:Spawn()
			
			pl:SetHealth( health )
			pl:SetArmor( armor )
			
			if ( IsValid( pl.TranqRagdoll ) ) then
				timer.Simple( 0, function()
					pl:SetPos( pl.TranqRagdoll:GetPos() )
				end )
				
				pl.TranqRagdoll:Remove()
			end
			
			for _, wep in ipairs( pl.TranqWeapons ) do
				pl:Give( wep )
			end
			
			pl.WakeTime = nil 
		end
	end )
	
	hook.Add( "EntityTakeDamage", "TranqDamage", function( ent, dmg )
		for _, pl in ipairs( player.GetAll() ) do
			if ( IsValid( pl.TranqRagdoll ) and pl.TranqRagdoll == ent ) then
				if ( pl:Health() > dmg:GetDamage() ) then
					pl:SetHealth( pl:Health() - dmg:GetDamage() )
				else
					local pos = pl.TranqRagdoll:GetPos()
					pl:Spawn()
					pl:SetPos( pos )
					pl:SetHealth( 1 )
					pl:TakeDamageInfo( dmg )
				end
			end
		end
	end )
	
	hook.Add( "PlayerDeath", "TranqDeath", function( pl )
		pl.TranqTime = nil
		pl.WakeTime = nil
		
		if ( IsValid( pl.TranqRagdoll ) ) then
			pl.TranqRagdoll:Remove()
		end
	end )
else
	net.Receive( "TranqRagdoll", function()
		local pl = net.ReadEntity()
		local ragdoll = net.ReadEntity()
		
		if ( IsValid( pl ) and IsValid( ragdoll ) ) then
			pl.TranqRagdoll = ragdoll
			
			function ragdoll:GetPlayerColor()
				return pl:GetPlayerColor()
			end
		end
	end )
	
	local star = Material( "sprites/glow04_noz" )
	hook.Add( "PostDrawOpaqueRenderables", "DrawTranqStars", function()
		for _, pl in ipairs( player.GetAll() ) do
			local ragdoll = pl.TranqRagdoll
			
			if ( IsValid( ragdoll ) ) then
				local attach = ragdoll:GetAttachment( ragdoll:LookupAttachment( "eyes" ) )
				
				if ( attach ) then
					local stars = 3
					
					for i = 1, stars do
						local time = CurTime() * 3 + ( math.pi * 2 / stars * i )
						local offset = Vector( math.sin( time ) * 5, math.cos( time ) * 5, 10 )
						
						render.SetMaterial( star )
						render.DrawSprite( attach.Pos + offset, 8, 8, Color( 220, 220, 0 ) )
					end
				end
			end
		end
	end )
end