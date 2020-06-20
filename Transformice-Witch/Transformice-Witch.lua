doll = "xxx" -- Nick lalki
god = "Kosmek" -- Twój nick
 
for name in pairs(tfm.get.room.playerList) do
        for keys, k in pairs({73, 74, 75, 76}) do
                tfm.exec.bindKeyboard(god, k, true, true)
        end
end
 
function eventKeyboard(god, key, down, x, y)
        if key == 73 then
                tfm.exec.movePlayer(doll, 0, 0, true, 0, -40, false)
        elseif key == 75 then
                tfm.exec.movePlayer(doll, 0, 0, true, 0, 40, false)
        elseif key == 74 then
                tfm.exec.movePlayer(doll, 0, 0, true, -40, 0, false)                
        elseif key == 76 then
                tfm.exec.movePlayer(doll, 0, 0, true, 40, 0, false)                      
        end
end
 
print("<font color='#FFFF00'>"..doll.."<font color='#FFFF00'> jest teraz Twoją lalką!")