AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



function ENT:Initialize()
	self:SetModel("models/props_lab/bindergreen.mdl")
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
	  local ent = ents.Create( "paper_money" )
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



function ENT:PhysicsCollide( data, phys ) 
 ent = data.HitEntity  

	if string.find( ent:GetClass( ), "money_printer" ) then
	    ent:SetPaper(ent:GetPaper() + 10)  
		self:Remove()
	end
end
