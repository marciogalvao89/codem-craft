Config = {}


Config.frameworkObject = "newqb" -- newqb, oldqb, esx, infinity
Config.Mysql = "oxmysql" -- mysql-async -- oxmysql
Config.SetCraftXpCommand = 'setxp' -- example = setxp id xp  = setxp 2 5
Config.AdminPerm = 'admin' --- admin rank
Config.Craft = {
    {npcHash = 's_m_m_ammucountry' ,coords = vector3(244.89, -802.82, 30.29) , npcHeading = 83.91},
    {npcHash = 's_m_m_ammucountry' ,coords = vector3(1574.89, 3561.82, 35.22) , npcHeading = 28.91},
    {npcHash = 's_m_m_ammucountry' ,coords = vector3(-447.89, 5995.82, 31.34) , npcHeading = 79.91}

}



Config.Categories = {
    {
        name = "weapon",
        label = "Weapon",
    },
      
}

Config.CraftItem = {
    {
        itemName = 'weapon_revolver',
        itemLabel = 'Revolver',
        minute = 20 ,
        level = 0,
        xp = 100,
        category = 'weapon',
        required = {
            { label = 'Metalscrap', name = "metalscrap", amount = 10},
            { label = 'Copper', name = "copper", amount =10},
            { label = 'Aluminum', name = "aluminum", amount =10},
            
        },
        imagesname = 'Assault-Rifle-MK-II-Big' ,  ---- for mid image
   
    },
    {
        itemName = 'weapon_molotov',
        itemLabel = 'Molotov',
        minute = 20 ,
        level = 0,
        xp = 100,
        category = 'weapon',
        required = {
            { label = 'Combustivel', name = "jerry_can", amount = 1},
            { label = 'Vidro', name = "glass", amount =1},
            
        },
        imagesname = 'Assault-Rifle-MK-II-Big' ,  ---- for mid image
   
    },
        
 
}


function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end


Config.Notifications = { -- Notifications
    ["success"] = {
        message = 'Item Craftado',
        type = "succes",
        time = 2500,
    },
  
    ["error"] = {
        message = 'Não conseguiste Craftar.',
        type = "error",
        time = 2500,
    },

}