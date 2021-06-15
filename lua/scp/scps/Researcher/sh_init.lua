--[[
	Plague doctor sh_init.lua
]]--

CLASS = CLASS or {};

local pMeta = FindMetaTable( "Player" );


function pMeta:SetResearcher( client )
	self:SetNWEntity( "Researcher", client );
	client:SetNWEntity( "DClass", self );
end;


function pMeta:GetResearcher()
	return self:GetNWEntity( "Researcher" );
end;


function pMeta:ClearResearcher()
	local client = self:GetResearcher();
	client:ClearSCP();
	client:SetNWEntity( "DClass", NULL );
	self:SetNWEntity( "Researcher", NULL );
end;


function pMeta:SetDClass( client )
	self:SetNWEntity( "DClass", client );
	client:SetNWEntity( "Researcher", self );
	self:AssignSCP();
end;


function pMeta:GetDClass()
	return self:GetNWEntity( "DClass" );
end;


function pMeta:ClearDClass()
	local client = self:GetDClass();
	client:SetNWEntity( "Researcher", NULL );
	self:SetNWEntity( "DClass", NULL );
	self:ClearSCP();
end;


function pMeta:ClearSCP()
	self:SetNWInt( "SCPID", 0 );
end;


function pMeta:GetSCP()
	return self:GetNWInt( "SCPID" );
end;


function pMeta:AssignSCP()
	local SCPs = SCP.Classes.Stored;
	SCPs[0] = nil;
	SCPs[1] = nil;
	local SCP = table.Random( SCPs );
	if( self.AssignTime == nil ) then
		self.AssignTime = CurTime();
	end;
	if( #team.GetPlayers( SCP.Team ) > 0 ) then
		self:SetNWInt( "SCPID", SCP.ID );
		self.AssignTime = nil;
	else
		if( CurTime() - self.AssignTime <= 2 ) then
			self:AssignSCP();
		else
			self.AssignTime = nil;
		end;
	end;
end;