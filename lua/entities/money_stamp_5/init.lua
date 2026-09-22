AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	self:SetModel("models/Mechanics/robotics/a1.mdl")
	self:SetMaterial("models/props/money_printer/moneyPrinterV3/five_dollar_bill_static")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetTrigger(true)
	self.damage = 25
	
	self.makeamount = 5 --< how much you want to print in seconds
	self.currentamount = 500 -- < how much the printer needs to print before cashing out.

	local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetMass( 1 )	
		end

end


function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()
		if (self.damage <= 0) then
			self.Entity:Remove()
		end
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
		local SpawnPos = tr.HitPos + tr.HitNormal * 46
		local ent = ents.Create( "money_stamp_5" )
		ent:SetPos( SpawnPos )
		ent:Spawn()
		ent:Activate()
	return ent

end


function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity  
		if string.find( ent:GetClass( ), "money_printer" ) then
 
			if self.currentamount > ent:GetCur() then 	
				ent:SetCur(self.currentamount)
				ent:SetSkin(2)
				self:Remove()
			end
	
		if ent.make >= self.makeamount then return end
		
			if self.makeamount > ent.make then 
				ent.make = self.makeamount
			end
			ent.check = 0	

			ent.skin = 5			
			ent:SetSkin(2)
			self:Remove()
		end
end
