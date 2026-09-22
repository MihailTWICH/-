AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	self:SetModel("models/props_lab/reciever01d.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetTrigger(true)
	
	gold = Color (255,215,0,0)
	self:SetColor(gold)
	
	 self.damage = 25
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass( 1 )	
	end
	 
		self.storageamount = 250 -- extra storage amount.
		self.max_storage_use = 8 -- amount of use for each printer.
		
		self.cantuse = true
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
	  local ent = ents.Create( "extra_storage" )
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


function ENT:Touch( hitEnt )
	if hitEnt.IsPrinter then
		
		if  hitEnt.storageuse >= self.max_storage_use  then 
			if self.cantuse then
				self.cantuse = false
				timer.Create( "cantUse"..self:EntIndex( ),2,1, function() 
					self:EmitSound("buttons/combine_button2.wav", 60, 100)
					self:SetColor(Color(255,255,255,255))
					self:SetMaterial("models/error/new light1")
					timer.Simple(1,function() self:SetMaterial() self:SetColor(gold) end)
					self.cantuse = true
				end)
			end
			return false
		end
		hitEnt.extrastorage = hitEnt.extrastorage + self.storageamount
		hitEnt.storageuse = hitEnt.storageuse + 1
	self:Remove()
	end
end


