AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	self:SetModel("models/props/money_printer_pieces/scanner.mdl")
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
	  local ent = ents.Create( "print_scanner" )
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
	if hitEnt.IsRegister then
		if hitEnt.SetScanner == 1 then return  end

		if hitEnt.SetScanner == 0 then 
			hitEnt.SetScanner =  1
		end

	hitEnt.SetPrinter = hitEnt.SetPrinter + 1 
	self:Remove()
	end
end


