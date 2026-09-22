AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	self:SetModel("models/props_lab/reciever01d.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetTrigger(true)
	
	red = Color (255,100,100,0)
	self:SetColor(red)
	
	 self.damage = 25
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass( 1 )	
	end
	
	self.speed = 0.20 -- how fast you want the printer to print. this should not be higher then "self.print_cycle" in \lua\entities\money_printer\init.lua.
	self.heat = 2 -- lower the amount of seconds it will take for the temp to rise. this should always stay a low number and should always be lower then "self.printer_heat" in lua\entities\money_printer\init.lua. 
	self.isAnaddition = true -- setting this to true will allow your players to keep adding more boost. false will always set the print speed to "self.speed".
	self.Maximum_printSpeed_limit = 0.50 -- the maximum print speed (the lower the number the faster the printer can print). you should always keep this number higher then 0.40
	
	
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
	  local ent = ents.Create( "extra_print_speed" )
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
		
		if hitEnt.print_cycle <= self.Maximum_printSpeed_limit then 
			if self.cantuse then
				self.cantuse = false
				timer.Create( "cantUse"..self:EntIndex( ),2,1, function() 
					self:EmitSound("buttons/combine_button2.wav", 60, 100)
					self:SetColor(Color(255,255,255,255))
					self:SetMaterial("models/error/new light1")
					timer.Simple(1,function() self:SetMaterial() self:SetColor(red) end)
					self.cantuse = true
				end)
			end
			hitEnt.print_cycle = self.Maximum_printSpeed_limit
			//print (hitEnt.print_cycle)
			return false 
		end
	
		if self.isAnaddition then 
			self.speed = hitEnt.print_cycle - self.speed
			hitEnt.print_cycle = self.speed
			
			if hitEnt.print_cycle < self.Maximum_printSpeed_limit then 
				hitEnt.print_cycle = self.Maximum_printSpeed_limit
			end
			
		end 
		
	timer.Adjust( "cash"..hitEnt:EntIndex( ),self.speed,0)
	
	if hitEnt.printer_heat == 0 then
		self:Remove() 
		return false 
	end
	
	if hitEnt.printer_heat <= self.heat then 
		self:Remove() 
		return false
	end
	
	hitEnt.printer_heat = hitEnt.printer_heat - self.heat
	timer.Adjust( "heat"..hitEnt:EntIndex( ),hitEnt.printer_heat,0)
	self:Remove()
	end
end

function ENT:OnRemove()
	timer.Remove( "cantUse"..self:EntIndex( ))
end