ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "[myb] flapjack"
 
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.Category		= "money printer system"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Cur")
	self:NetworkVar("Int", 1, "Cash")
	self:NetworkVar("Int", 2, "Heat")
	self:NetworkVar("Int", 3, "Paper")
	self:NetworkVar("String", 0, "Standby")
	self:NetworkVar("Entity", 4, "owning_ent")
end
