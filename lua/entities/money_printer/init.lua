AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	self:SetModel("models/props/money_printer/moneyprinterv3.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSkin(10)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	
	local phys = self:GetPhysicsObject()
	phys:Wake()
	phys:SetMass(30)

	 
	self.bullet = ents.Create("prop_scalable");
		self.bullet:SetPos(self:GetPos() + Vector(15, 9, -1))
		self.bullet:SetAngles(self:GetAngles() - Angle(0, 0, 0));
		self.bullet:SetParent(self)
		self.bullet:SetModel("models/weapons/shell.mdl");
		self.bullet:SetNotSolid(true)
		self.bullet:SetNoDraw(true)
		self.bullet:Spawn(); 
	
	self.IsPrinter = true
	self:SetHeat(50)
	self:SetStandby("..idle")
	self:SetCash(0)
	self:SetCur(250)
	self.skin = 0
	self.extrastorage = self.extrastorage or 0
	self.sparking = false
	self.damage = 100
	self.set_static = false
	self.boostuse = 0
	self.storageuse = 0
	self.check = self.check or 0
	
	
	amount_paper_needed = 10 -- how much paper we need to start printing.
	self.make = 1 -- by DEFAULT how many in increments will the printer make when printing. default should be 1$
	self.printer_heat = 10 -- how often should the temperature rise in seconds. set to 0 to disable heating.
	self.print_cycle = 1 -- how many seconds until the printer makes more money$$
	
	
timer.Create("misc"..self:EntIndex( ),1,0, function()
	
	if self.check == self.extrastorage then return end
	self:SetCur(self:GetCur() + self.extrastorage)
	self.check = self.extrastorage
end)	
	
timer.Create( "cash"..self:EntIndex( ),self.print_cycle,0, function() 
 
	
	if self:GetCash() >= self:GetCur() then 
		self:SetCash(self:GetCur())
		self:SetStandby("Ready to cash out") 
	--	self:EmitSound("ambient/machines/spindown.wav", 60, 100) --
		if self.set_static == true then return  end
		self:SetSkin(self:GetSkin() + 1)
		self.set_static = true
		return
	end
	
	

	if self:GetPaper() <= 0 then 
		self:SetSkin(10) 
		self:SetStandby("Out of paper")   
		return 
	end
	self.set_static = false
	cash = self:GetCash() + self.make
	self:SetCash(cash)
	self:EmitSound("ambient/machines/hydraulic_1.wav", 60, 100) 
	self:SetStandby("Printing...")
	
	if self.skin == 5 then 
		self:SetSkin(2) 
		return 
	end 
	
	if self.skin == 10 then 
		self:SetSkin(4) 
		return 
	end 
	
	if self.skin == 20 then 
		self:SetSkin(6) 
		return 
	end 
	
	if self.skin == 100 then 
		self:SetSkin(8) 
		return 
	end 
	
	self:SetSkin(0)
	
    end)
	

	if self.printer_heat == 0 then
		return 
	end
timer.Create( "heat"..self:EntIndex( ),self.printer_heat,0, function(ent)
	self.print_cycle = self.print_cycle
	if  self:GetHeat() > 100 then 
		DarkRP.notify(self:Getowning_ent(), 1, 10, string.format("Your printer is about to overheat\nPlace a cooler down soon!"))			
	end

	if  self:GetHeat() > 118 then  
		self:SetHeat(120) 
		self:BurstIntoFlames() 
		timer.Destroy( "heat"..self:EntIndex( ))
		return false 
	end 
	
	if  self:GetHeat() < 50 then 
		self:SetHeat(50)  
		return false  
	end
	
	temp = math.random(1,2)
	
	if self:GetCash()  == 0 then
		heat =  self:GetHeat() - temp
		self:SetHeat(heat) 
		return true 
	end 
		
	if self:GetCash() >= self:GetCur() then
		heat =  self:GetHeat() - temp
		self:SetHeat(heat)
		return true 
	end 
	
	 heat =  self:GetHeat() + temp
	 self:SetHeat(heat)
end)

end

function ENT:Use(activator, obj)

if  self:GetCash() >= self:GetCur() then 
	if(activator:IsPlayer()) then
		DarkRP.createMoneyBag(self.bullet:GetPos(), self:GetCur())
		self:SetNWString("printerinfo","Idle..")
		self:SetCash(0)
		self:SetPaper(self:GetPaper() - amount_paper_needed )
			if self:GetPaper() < 1 then 
				self:SetPaper(0)
			end
	end
end

end


function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		local rnd = math.random(1, 10)
		if rnd < 3 then
			self:BurstIntoFlames()
		else
			self:Destruct()
			self:Remove()
		end
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	
end 

function ENT:BurstIntoFlames()
	DarkRP.notify(self:Getowning_ent(), 1, 10, string.format("Your money printer is overheating!"))		
	self.burningup = true
	local burntime = math.random(8, 18)
	self:Ignite(burntime, 0)
	timer.Simple(burntime, function() self:Fireball() end)
end

function ENT:Fireball()
	if not self:IsOnFire() then self.burningup = false return end
	local dist = math.random(20, 280) -- Explosion radius
	self:Destruct()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
			v:Ignite(math.random(5, 22), 0)
		elseif v:IsPlayer() then
			local distance = v:GetPos():Distance(self:GetPos())
			v:TakeDamage(distance / dist * 100, self, self)
		end 
	end
	self:Remove()
end

function ENT:Think()

	if self:WaterLevel() > 0 then
		self:Destruct()
		self:Remove()
		return
	end

	if not self.sparking then return end

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
end


function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	 local SpawnPos = tr.HitPos + tr.HitNormal * 46
	  local ent = ents.Create( "money_printer" )
	   ent:SetPos( SpawnPos )
	   ent:Spawn()
	   ent:Activate()
	return ent
   
end


function ENT:OnRemove()
	timer.Destroy( "cash"..self:EntIndex( ))
	timer.Destroy( "heat"..self:EntIndex( ))
end
