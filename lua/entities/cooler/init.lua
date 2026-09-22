AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


local TempUse = 60 -- how hot the printer needs to be in order to use the freon. set a value less then 50 to disable temp use limit.


function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_glassbottle001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetTrigger(true)
	 self.damage = 25
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
	phys:Wake()
    phys:SetMass( 1 )	
	end
	

end


function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()
	if (self.damage <= 0) then
		self.Entity:Destruct()
		self.Entity:Remove()
	end
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
		local SpawnPos = tr.HitPos + tr.HitNormal * 46
		local ent = ents.Create( "cooler" )
		ent:SetPos( SpawnPos )
		ent:Spawn()
		ent:Activate()
	return ent
   
end

function ENT:Destruct()
	local vPoint = self.Entity:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("WheelDust", effectdata)
end

function ENT:Use( activator, caller )
	
end 

function ENT:PhysicsCollide( data, phys ) 
 ent = data.HitEntity  
 
	if string.find( ent:GetClass( ), "money_printer" ) then
		if ent:GetHeat() < TempUse then return false end
		 self:EmitSound("ambient/machines/steam_release_2.wav", 80, 200) 
		 ent:SetHeat(50)
	     self:Remove()
	end
end
