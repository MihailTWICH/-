include("shared.lua")


function ENT:Draw()

	
    local	cash = "$" ..self:GetCash()
    local	heat = self:GetHeat()
    local	printinfo = self:GetStandby()
    local	paper = self:GetPaper()
    local	cur = "$" ..self:GetCur()


	self.Entity:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles() 

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")
	 name = owner 
	
	surface.SetFont("DermaDefaultBold") 
	
	Ang:RotateAroundAxis(Ang:Up(), 90)
	
	cam.Start3D2D(Pos + Ang:Up() * 11.5, Ang + Angle(0,0,6), 0.11)
	
		 
		surface.SetDrawColor(0,0,0,255)
		
		surface.DrawRect (-140,-130,95,120)
	
		surface.SetDrawColor(255,255,255,255)
		surface.DrawOutlinedRect (-140,-120,100,120)
		
		
		surface.SetTextColor(255,255,255,255)
		surface.SetFont("DermaLarge")
		surface.SetTextPos( -130, -40 ) 
		surface.DrawText( cash ) 
		
		
		
		surface.SetTextPos( -130, -100 ) 
		surface.SetFont("DermaLarge")
		surface.DrawText( cur ) 
		
		
		
		surface.SetTextPos( -135, -120 ) 
		surface.SetFont("DermaDefaultBold")
		surface.DrawText( "amount needed" ) 
		surface.SetTextPos( -135, -60 ) 
		surface.DrawText( "Current amount" ) 
		
		
	cam.End3D2D()

	
	cam.Start3D2D( Pos + Ang:Up() * -8.20 + Ang:Right() * 13.2  , Ang + Angle(0,0,53.5), 0.11)
	surface.SetDrawColor(255,0,0,255)
		 
		surface.DrawRect (-15,-55,10,40 - heat)
		surface.SetTextColor(255,0,0,255)
		surface.SetFont("DermaDefault")
		surface.SetTextPos( -135, -130 ) 
		surface.DrawText( "heat" ) 
		
		
		surface.SetTextPos( -90, -130 ) 
		surface.SetTextColor(255,255,160,255)
		surface.DrawText( "paper" ) 
		
		surface.SetFont("Trebuchet24")
		surface.SetTextPos( -80, -110 ) 
		surface.DrawText( paper ) 
		
		surface.SetFont("Trebuchet18")
		surface.SetTextColor(0,245,255,255)
		surface.SetTextPos( -150, -85 ) 
		surface.DrawText("".. printinfo ) 
		
		surface.SetFont("Trebuchet24")
		surface.SetTextColor(255,0,0,255)
		surface.SetTextPos( -145, -110 ) 
		surface.DrawText( "F"..heat.."*" )
		
		local fire = Material("icon16/fire.png")
		surface.SetMaterial(fire)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(-150,-130,16,16)
		
		local paper = Material("icon16/page_white.png")
		surface.SetMaterial(paper)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(-110,-130,16,16)
	cam.End3D2D()
end

function DrawInfo()
	local tr = LocalPlayer():GetEyeTrace()
	if IsValid(tr.Entity) and tr.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 400 then
		if tr.Entity:GetClass() == "money_printer" then
			local ent = tr.Entity
			local pos = ent:GetPos()
			
			
			pos.z = pos.z + 8
			pos = pos:ToScreen()

			text = name
			
			draw.DrawText(text, "TargetID", pos.x + 1, pos.y + 1, Color(0, 0, 0, 200), 1)
			draw.DrawText(text, "TargetID", pos.x, pos.y, Color(255, 255, 255, 200), 1)
		end
	end
end
hook.Add( "HUDPaint", "DrawInfostampname", DrawInfo ) 

