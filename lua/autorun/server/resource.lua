--workshop file
resource.AddWorkshop( "449576946" )
resource.AddWorkshop( "751584776" )



function RemovePrintersNitemsOnDisconnect()
	
    for k, v in pairs(ents.FindByClass("register_tray")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	    for k, v in pairs(ents.FindByClass("printer_display")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	    for k, v in pairs(ents.FindByClass("print_scanner")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	    for k, v in pairs(ents.FindByClass("paper_money")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	    for k, v in pairs(ents.FindByClass("money_stamp_100")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	    for k, v in pairs(ents.FindByClass("money_stamp_20")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	    for k, v in pairs(ents.FindByClass("money_stamp_10")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	    for k, v in pairs(ents.FindByClass("money_stamp_5")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	    for k, v in pairs(ents.FindByClass("money_printer")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	    for k, v in pairs(ents.FindByClass("extra_storage")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	for k, v in pairs(ents.FindByClass("extra_print_speed")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	for k, v in pairs(ents.FindByClass("extra_current_amount")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
	
	for k, v in pairs(ents.FindByClass("cooler")) do
                if v.SID == ply.SID then
                   v:Remove()
                end
    end
end
hook.Add("PlayerDisconnected","RemovePrinternstuff",RemovePrintersNitemsOnDisconnect)