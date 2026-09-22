ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "register tray"
ENT.Author = "[myb] flapjack"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Category		= "money printer system"

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
end