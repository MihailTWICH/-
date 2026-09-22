AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



function ENT:Initialize()
	self:SetModel("models/props/money_printer_pieces/register.mdl")
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
	
	
	self.IsRegister = true
	self.SetDrum = 0
	self.SetDisplay = 0
	self.SetScanner = 0
	self.SetPrinter = 0 --<< -----------this is so when both the drum/display entity touch the register () it will remove itself and spawn the money printer
	self.setstorage = 0
	
		self.Entityi = ents.Create("prop_dynamic");
		self.Entityi:SetPos(self:GetPos() + Vector(-2, 11, 9))
		self.Entityi:SetAngles(self:GetAngles() - Angle(0, 0, 0));
		self.Entityi:SetModel("models/props/money_printer_pieces/drum.mdl");
		self.Entityi:SetParent(self);
		self.Entityi:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self.Entityi:SetNotSolid(true)
		self.Entityi:Spawn(); 
		self.Entityi:SetNoDraw(true)
	   
	   
		self.Display = ents.Create("prop_dynamic");
		self.Display:SetPos(self:GetPos() + Vector(-6, -7, 14.0))
		self.Display:SetAngles(self:GetAngles() - Angle(0, 0, 0));
		self.Display:SetModel("models/props/money_printer_pieces/display.mdl");
		self.Display:SetParent(self);
		self.Display:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self.Display:SetNotSolid(true)
		self.Display:Spawn(); 
		self.Display:SetNoDraw(true)	

		self.Scanner = ents.Create("prop_dynamic");
		self.Scanner:SetPos(self:GetPos() + Vector(0, 32.5, -2.5))
		self.Scanner:SetAngles(self:GetAngles() - Angle(0, 0, 0));
		self.Scanner:SetModel("models/props/money_printer_pieces/scanner.mdl");
		self.Scanner:SetParent(self);
		self.Scanner:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self.Scanner:SetNotSolid(true)
		self.Scanner:Spawn(); 
		self.Scanner:SetNoDraw(true)
		
timer.Create( "register"..self:EntIndex( ),1,0, function() 
	//print(self.setstorage)
	if self.SetPrinter == 3 then 
		printer = ents.Create("money_printer");
		printer:SetPos(self:GetPos() + Vector(0,0,10))
		printer:Spawn()
		printer:Setowning_ent(self:Getowning_ent())
		self:Remove()
	end

	if self.SetDrum == 1 then
		self.Entityi:SetNoDraw(false)
	end
	
	if self.SetDisplay == 1 then 
		self.Display:SetNoDraw(false)
	end
	
	if self.SetScanner == 1 then 
		self.Scanner:SetNoDraw(false)
	end

end)

	
end
	
	



function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()
	if (self.damage <= 0) then
		self.Entity:Destruct()
		self.Entity:Remove()
	end
end

function ENT:Destruct()
	local vPoint = self.Entity:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end


function ENT:Touch( hitEnt )
	if hitEnt.IsMoneyPrinter then
		self:SetNotSolid( false ) 
		self:SetTrigger( false )
		self:SetColor( 0, 0, 0, 0 )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD ) 
		constraint.NoCollide(self,GetWorldEntity(),0,0)
	end
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
		local SpawnPos = tr.HitPos + tr.HitNormal * 46
		local ent = ents.Create( "register_tray" )
		
		ent:SetPos( SpawnPos )
		ent:Spawn()
		ent:Activate()
	return ent
   
end
