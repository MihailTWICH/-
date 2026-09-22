include("shared.lua")

function ENT:Draw()
	self.Entity:DrawModel()
end

function DrawInfo()
	local tr = LocalPlayer():GetEyeTrace()
	if IsValid(tr.Entity) and tr.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 400 then
		if tr.Entity:GetClass() == "money_stamp_10" then
			local ent = tr.Entity
			local pos = ent:GetPos()

			pos.z = pos.z + 8
			pos = pos:ToScreen()

			text = "10$ Money stamp"
			
			draw.DrawText(text, "TargetID", pos.x + 1, pos.y + 1, Color(0, 0, 0, 200), 1)
			draw.DrawText(text, "TargetID", pos.x, pos.y, Color(255, 255, 255, 200), 1)
		end
	end
end
hook.Add( "HUDPaint", "DrawInfostamp10", DrawInfo ) 