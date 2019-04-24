-- Komendy
-- !start - inicjuje grę
-- !new - tworzy nową partię
-- !skip - pomiń bieżącą turę gracza
-- !ban nick - banuje danego gracza
 
adm = "Kosmek" -- nazwa administratora gry
gameName = "UNO!" -- nazwa mapy
configTempo = 15000 -- limit ruchu w ms
autoStart = true -- automatyczna gra bez potrzeby używania ciagłego !start i !new
 
mapa = [[<C><P /><Z><S><S H="40" L="800" o="214a25" X="400" c="3" Y="135" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S L="800" o="214a25" X="400" H="60" N="" Y="370" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S H="3000" L="200" o="6a7495" X="900" c="3" N="" Y="200" T="12" P="0,0,0,0.2,0,0,0,0" /><S P="0,0,0,0.2,0,0,0,0" L="200" o="6a7495" X="-100" c="3" N="" Y="200" T="12" H="3000" /><S P="0,0,0,0.2,0,0,0,0" L="800" o="6a7495" X="400" c="4" N="" Y="-41" T="12" H="100" /></S><D><P C="ffd800" Y="60" T="90" P="0,0" X="606" /><P C="ffd800" Y="60" T="90" X="812" P="0,0" /><P C="ffd800" Y="60" T="90" P="0,0" X="194" /><P C="ffd800" Y="60" T="90" X="-12" P="0,0" /><P C="ffd800" Y="60" T="90" X="400" P="0,0" /><P C="317c39" Y="125" T="34" P="0,0" X="0" /><P C="8a311b" Y="135" T="19" P="0,0" X="150" /><P C="8a311b" Y="135" T="19" X="250" P="0,0" /><P C="8a311b" Y="134" T="19" P="0,0" X="350" /><P C="8a311b" Y="134" T="19" X="450" P="0,0" /><P C="8a311b" Y="134" T="19" P="0,0" X="550" /><P C="8a311b" Y="134" T="19" X="650" P="0,0" /><P C="8a311b" Y="135" T="19" X="50" P="0,0" /><P C="8a311b" Y="134" T="19" P="0,0" X="750" /><DS Y="100" X="400" /></D><O /></Z></C>]]
 
-- kolory kart
-- czerwony, niebieski, żółty, zielony, czarny
colorInt = {0xFF3232, 0x5365CC, 0xFFD800, 0x73D33B, 1}
colorStr = {"FF3232", "5365CC", "FFD800", "73D33B", "000000"}
 
-- specjalne ikony kart
rev="&#167;"
skip="&#216;"
d2="+2"
d4="+4"
wild="*"
 
-- Talia 108 kart
cards = { -- {kolor, wartość}
        {1,"0"},{1,"1"},{1,"1"},{1,"2"},{1,"2"},{1,"3"},{1,"3"},{1,"4"},{1,"4"},{1,"5"},{1,"5"},{1,"6"},{1,"6"},{1,"7"},{1,"7"},{1,"8"},{1,"8"},{1,"9"},{1,"9"},{1,rev},{1,rev},{1,skip},{1,skip},{1,d2},{1,d2},
        {2,"0"},{2,"1"},{2,"1"},{2,"2"},{2,"2"},{2,"3"},{2,"3"},{2,"4"},{2,"4"},{2,"5"},{2,"5"},{2,"6"},{2,"6"},{2,"7"},{2,"7"},{2,"8"},{2,"8"},{2,"9"},{2,"9"},{2,rev},{2,rev},{2,skip},{2,skip},{2,d2},{2,d2},
        {3,"0"},{3,"1"},{3,"1"},{3,"2"},{3,"2"},{3,"3"},{3,"3"},{3,"4"},{3,"4"},{3,"5"},{3,"5"},{3,"6"},{3,"6"},{3,"7"},{3,"7"},{3,"8"},{3,"8"},{3,"9"},{3,"9"},{3,rev},{3,rev},{3,skip},{3,skip},{3,d2},{3,d2},
        {4,"0"},{4,"1"},{4,"1"},{4,"2"},{4,"2"},{4,"3"},{4,"3"},{4,"4"},{4,"4"},{4,"5"},{4,"5"},{4,"6"},{4,"6"},{4,"7"},{4,"7"},{4,"8"},{4,"8"},{4,"9"},{4,"9"},{4,rev},{4,rev},{4,skip},{4,skip},{4,d2},{4,d2},
        {5,wild},{5,wild},{5,wild},{5,wild},{5,d4},{5,d4},{5,d4},{5,d4},
}
 
-- TEKST
 
txtDraw = "Zagraj wcześniejszym kolorem %s lub kup %d karty."
txtSit = "Idź na wybrane miejsce i naciśnij spacje, aby je zająć!"
txtGameOver = "%s wygrał/-a!"
txtPass = "Poczekaj"
txtWarn = "Wróć na swoje miejsce!"
txtChoose = "Wybierz kolor"
txtRed = "CZERWONY"
txtBlue = "NIEBIESKI"
txtYellow = "ŻÓŁTY"
txtGreen = "ZIELONY"
 
-- ZMIENNE GRY
 
commands = {"ban", "kick", "new", "start"}
pack = {}
stack = {}
player = {}
nick = {}
timerTxt = {}
mode = "init"
duel = false
actual = nil
turn = false
sel = true
draw = false
accumulation = 0
accumulation4 = 0
flux = 1
tempoGame = os.time() + 15000
tempo = os.time()+1000
 
-- FUNKCJE POMOCNICZE
 
function split(t,s)
        local a={}
        for i,v in string.gmatch(t,string.format("[^%s]+",s or "%s")) do
                table.insert(a,i)
        end
        return a
end
 
function getNick(p)
        return p:sub(1,1):upper() .. p:sub(2):lower()
end
 
function shuffle(b)
        local new = {}
        local rand = {}
        for i=1, #b do
                rand[i] = i
        end
        for i=1, #b do
                local r = math.random(#rand)
                table.insert(new, b[rand[r]])
                table.remove(rand, r)
        end
        return new
end
 
function _effect(id, x, y, turns, vel)
        for i=1, turns do
                tfm.exec.displayParticle(id, x, y, math.random(-vel,vel)/10, math.random(-vel,vel)/10, 0, 0)
        end
end
 
function deleteText()
        local delete={}
        for i,v in pairs(timerTxt) do
                if v.time<os.time() then
                        table.insert(delete,i)
                        ui.removeTextArea(v.id, v.p)
                end
        end
        for i=1,#delete do
                timerTxt[delete[i]]=nil
        end
end
 
function timerText(i, t, pp)
        table.insert(timerTxt, {id=i, time=os.time()+t, p=pp})
end
 
function newGame()
        for i=1, 50 do
                ui.removeTextArea(i)
        end
        for i=1, 8 do
                if player[i] then
                        nick[player[i].nick] = nil
                        player[i] = nil
                end
        end
        ui.removeTextArea(100)
        mode = "init"
        tfm.exec.newGame(mapa)
end
 
function drawCard(i, c, p, x, y)
        ui.addTextArea(i, "\n<p align='center'><font size='23px' color='#ffffff'>"..c[2], p, x, y, 40, 60, colorInt[c[1]], 0xffffff, 1,false)
end
 
function drawCards(p)
        ui.addTextArea(11, "", p, 330, 200, 40, 60, 1, 0xffffff, 1,false)
        ui.addTextArea(12, "<p align='center'><font size='12px' color='#FFD800'>UNO", p, 333, 223, 34, 16, 0xFF3232, 0xFF3232, 1,false)
end
 
function updateScore(n, p)
        ui.addTextArea(n, "<p align='center'>"..player[n].nick.."<b>\n<font size='18px'><j>"..(#player[n].hand~=1 and #player[n].hand or "Jeden!"), p, (n-1)*100-50, 115, 200, 60, 0, 0, 0, false)
end
 
function updateHand(p)
        for i=20, 50 do
                ui.removeTextArea(i, p)
        end
        for i, v in pairs(player[nick[p]].hand) do
                drawCard(i+20, v, p, 400-(#player[nick[p]].hand*25)+50*(i-1), 330)
        end
end
 
function updateFlux(p)
        defFlux = {
                "&gt; &gt; Copyright Kosmek &gt; &gt;",
                "&lt; &lt; Copyright Kosmek &lt; &lt;"
        }
        ui.addTextArea(14, string.format("<p align='center'><font size='20px' color='#214A25'><b>%s", defFlux[flux]), p, 0, 160, 800, 120, 0, 0, 0, false)
end
 
function updatePoints(p)
        ui.addTextArea(13, "", p, 100*(turn-1), 30, 100, 120, -1, 0xffffff, 1, false)
end
 
function updateTimer()
        tempoGame = os.time() + configTempo
end
 
function createPlayer(p, n)
        player[n] = {nick=p, hand={}, timer=os.time()+2000}
        updateScore(n)
        ui.removeTextArea(0, p)
        nick[p] = n
end
 
function removePlayerUI(p, n)
        ui.removeTextArea(n)
        player[n] = nil
        nick[p] = nil
end
 
function removePlayer(p, n)
        if n == turn then
                autoPlay()
        end
        for i=1, #player[n].hand do
                ui.removeTextArea(i+20, p)
                table.insert(stack, table.remove(player[n].hand))
        end
        removePlayerUI(p, n)
end
 
function _sort(b)
        table.sort(b, function(a, b)
                p = {["0"]=0,["1"]=1,["2"]=2,["3"]=3,["4"]=4,["5"]=5,["6"]=6,["7"]=7,["8"]=8,["9"]=9,[rev]=10,[skip]=11,[d2]=12,[wild]=13,[d4]=14,}
                if a[1] ~= b[1] then
                        return a[1] < b[1]
                else
                        return p[a[2]] < p[b[2]]
                end
        end)
end
 
function compareCards(p, qtd)
        ui.addTextArea(70+nick[p], "<p align='center'><font size='20px'><bv><b>+"..qtd, nil, (nick[p]-1)*100, 145, 100, 60, 0, 0, 0, false)
        timerText(70+nick[p], 2000)
        draw = true
        for i=1, qtd do
                if #pack == 0 then
                        pack = shuffle(stack)
                        stack = {}
                end
                table.insert(player[nick[p]].hand, table.remove(pack))
        end
        _sort(player[nick[p]].hand)
        updateHand(p)
        updateScore(nick[p])
end
 
function prevPick()
        local n = turn
        repeat
                n = flux == 1 and (n == 1 and 8 or n - 1) or (n == 8 and 1 or n + 1)
        until player[n]
        return n
end
 
function catchNext()
        local n = turn
        repeat
                n = flux == 1 and (n == 8 and 1 or n + 1) or (n == 1 and 8 or n - 1)
        until player[n]
        return n
end
 
function passTime()
        turn = catchNext()
        draw = false
        updatePoints()
        updateTimer()
        ui.removeTextArea(15)
        ui.removeTextArea(16)
        ui.removeTextArea(17)
end
 
function isNot(p)
        local x = tfm.get.room.playerList[p].x
        return nick[p] and x > (nick[p]-1)*100+20 and x < (nick[p]-1)*100+80
end
 
function useDraw4()
        accumulation4 = accumulation4 + 4
        ui.addTextArea(16, string.format("<p align='center'>"..txtDraw, d4, accumulation4), player[turn].nick, 250, 290, 300, 20, 1, 1, 0.4, true)
end
 
function autoPlay()
        local p = player[turn].nick
        n = accumulation > 0 and accumulation or accumulation4 > 0 and accumulation4 or 1
        accumulation = 0
        accumulation4 = 0
        if not draw then
                compareCards(p, n)
        end
        passTime()
        if actual[1] == 5 then
                changeColor()
                sel = true
                if actual[2] == d4 then
                        useDraw4()
                end
        end
end
 
function changeColor(n)
        actual[1] = n or math.random(1,4)
        drawCard(10, actual, nil, 420, 200)
        local b = {21, 23, 24, 22}
        _effect(b[actual[1]], 445, 230, 30, 20)
end
 
function useSkip()
        _effect(35, catchNext()*100-50, 100, 50, 10)
        passTime()
        passTime()
end
 
function useReverse()
        flux = flux == 1 and 2 or 1
        updateFlux()
        for i=20, 780, 10 do
                tfm.exec.displayParticle(3, i, 177, 0, 0, 0, 0)
        end
end

 
function eventNewGame()
        tempo = os.time()+1000
        tfm.exec.setUIMapName(gameName)
        ui.addTextArea(0, "<font size='25px'><p align='center'>"..txtSit, nil, 0, 180, 800, 200, 0, 0, 0, false)
        for i, v in pairs(tfm.get.room.playerList) do
                tfm.exec.bindKeyboard(i, 32, true, true)
                system.bindMouse(i, true)
        end
end
 
function eventTextAreaCallback(id, p, cmd)
        if id == 15 and nick[p] == turn then
                changeColor(tonumber(cmd))
                passTime()
                sel = true
                if actual[2] == d4 then
                        accumulation4 = accumulation4 + 4
                        ui.addTextArea(16, string.format("<p align='center'>"..txtDraw, d4, accumulation4), player[turn].nick, 250, 290, 300, 20, 1, 1, 0.4, true)
                end
        elseif cmd == "skip" and nick[p] == turn then
                passTime()
        end
end
 
function eventMouse(p, x, y)
        if mode == "start" then
                local xx =  tfm.get.room.playerList[p].x
                if player[nick[p]] and y > 325 and y < 400 and isNot(p) then
                        local card = math.ceil((x+5 - (400 - (#player[nick[p]].hand*25)))/50)
                        local hand = player[nick[p]].hand
                        if turn == nick[p] and sel then
                                if hand[card] and (accumulation == 0 or hand[card][2] == d2) and (accumulation4 == 0 or hand[card][2] == d4) and (hand[card][1] == actual[1] or hand[card][2] == actual[2] or hand[card][2] == wild or hand[card][2] == d4) then
                                        if actual[2] == d4 or actual[2] == wild then
                                                actual[1] = 5
                                        end
                                        table.insert(stack, actual)
                                        actual = table.remove(hand, card)
                                        updateHand(p)
                                        drawCard(10, actual, nil, 420, 200)
                                        updateScore(nick[p])
                                        if #player[nick[p]].hand == 0 then
                                                ui.addTextArea(13, "", nil, 5, 5, 790, 400, 1, 1, 0.5, false)
                                                ui.addTextArea(14, string.format("<p align='center'><font size='60px' color='#ffffff'>"..txtGameOver, p), nil, 0, 170, 800, 400, 0, 0, 0, false)
                                                tfm.exec.setPlayerScore(p, 1, true)
                                                mode = "end"
                                        else
                                                if actual[2] == wild or actual[2] == d4 then
                                                        sel = false
                                                        draw = true
                                                        ui.addTextArea(15, string.format("<p align='center'>%s\n<a href='event:1'><font color='#FF3232'>%s</font></a> - <a href='event:2'><font color='#5365CC'>%s</font></a> - <a href='event:3'><font color='#FFD800'>%s</font></a> - <a href='event:4'><font color='#73D33B'>%s</font></a>", txtChoose, txtRed, txtBlue, txtYellow, txtGreen), p, 250, 285, 300, 35, 1, 1, 0.7, true)
                                                else
                                                        if actual[2] == skip then
                                                                useSkip()
                                                        elseif actual[2] == rev then
                                                                if duel then
                                                                        useSkip()
                                                                else
                                                                        useReverse()
                                                                        passTime()
                                                                end
                                                        elseif actual[2] == d2 then
                                                                accumulation = accumulation + 2
                                                                passTime()
                                                                ui.addTextArea(16, string.format("<p align='center'>"..txtDraw, d2, accumulation), player[turn].nick, 250, 290, 300, 20, 1, 1, 0.4, true)
                                                        else
                                                                passTime()
                                                        end
                                                end
                                        end
                                        for i=1, 10 do
                                                tfm.exec.displayParticle(3, 445, 230, math.random(-20,20)/10, math.random(-20,20)/10, 0, 0)
                                        end
                                end
                        elseif os.time() > player[nick[p]].timer and hand[card] then
                                drawCard(nick[p]+200, hand[card], nil, (nick[p]-1)*100+30, 30)
                                timerText(200+nick[p], 1000)
                                player[nick[p]].timer = os.time()+2000
                        end
                elseif x > 325 and x < 375 and y > 195 and y < 245 and not draw and turn == nick[p] and sel then
                        if accumulation > 0 or accumulation4 > 0 then
                                compareCards(p, accumulation > 0 and accumulation or accumulation4)
                                accumulation = 0
                                accumulation4 = 0
                                passTime()
                        else
                                compareCards(p, 1)
                                ui.addTextArea(16, "<p align='center'><a href='event:skip'>"..txtPass, p, 250, 290, 300, 20, 1, 1, 0.7, true)
                                draw = true
                        end
                end
        end
end
 
function eventChatCommand(p, cmd)
        local arg = split(cmd, " ")
        if p == adm then
                if arg[1] == "start" and mode == "init" then
                        local r = {}
                        mode = "start"
                        sel = true
                        flux = 1
                        draw = false
                        actual = nil
                        updateTimer()
                        pack = shuffle(cards)
                        stack = {}
                        ui.removeTextArea(0)
                        for i, v in pairs(player) do
                                compareCards(v.nick, 7)
                                table.insert(r, i)
                        end
                        duel = #r == 2
                        repeat
                                table.insert(stack, actual)
                                actual = table.remove(pack)
                        until actual[2] ~= d4 and actual[2] ~= wild and actual[2] ~= d2 and actual[2] ~= skip and actual[2] ~= rev
                        drawCard(10, actual, nil, 420, 200)
                        drawCards()
                        turn = r[math.random(#r)]
                        updatePoints()
                        updateFlux()
                elseif arg[1] == "new" then
                        newGame()
                elseif arg[1] == "skip" then
                        autoPlay()
                elseif arg[1] == "ban" and arg[2] and nick[getNick(arg[2])] then
                        eventPlayerLeft(getNick(arg[2]))
                end
        end
end
 
function eventKeyboard(p, t, d, x, y)
        if mode == "init" and os.time() > tempo and not nick[p] then
                if x > 20 and x < 80 and not player[1] then
                        createPlayer(p, 1)
                elseif x > 120 and x < 180 and not player[2] then
                        createPlayer(p, 2)
                elseif x > 220 and x < 280 and not player[3] then
                        createPlayer(p, 3)
                elseif x > 320 and x < 380 and not player[4] then
                        createPlayer(p, 4)
                elseif x > 420 and x < 480 and not player[5] then
                        createPlayer(p, 5)
                elseif x > 520 and x < 580 and not player[6] then
                        createPlayer(p, 6)
                elseif x > 620 and x < 680 and not player[7] then
                        createPlayer(p, 7)
                elseif x > 720 and x < 780 and not player[8] then
                        createPlayer(p, 8)
                end
        end
end
 
function eventLoop()
        for i, v in pairs(player) do
                if not isNot(v.nick) then
                        ui.addTextArea(100, "<font size='50px' color='#ffffff'><p align='center'>"..txtWarn, v.nick, 5, 325, 790, 80, 0xff0000, 0xff0000, 1, true)
                else
                        ui.removeTextArea(100, v.nick)
                end
        end
        if mode == "end" then
                local b = {0, 1, 2, 4, 9, 11, 13}
                local x, y, id = math.random(800), math.random(400), b[math.random(#b)]
                for i=1, 40 do
                        tfm.exec.displayParticle(id, x, y, math.random(-20,20)/10, math.random(-20,20)/10, 0, 0)
                end
                if os.time() > tempoGame and autoStart then
                        updateTimer()
                        eventChatCommand(adm, "new")
                end
        end
        if mode == "start" then
                if os.time() > tempoGame then
                        autoPlay()
                elseif tempoGame - os.time() < 10000 then
                        ui.addTextArea(17, "<p align='center'><font size='25px' color='#214A25'>"..math.ceil((tempoGame - os.time())/1000), nil, 350, 210, 90, 100, 0, 0, 0, false)
                else
                        ui.removeTextArea(17)
                end
        elseif mode == "init" then
                if os.time() > tempoGame and autoStart then
                        updateTimer()
                        eventChatCommand(adm, "start")
                end
        end
        deleteText()
end
 
function eventNewPlayer(p)
        if mode == "init" then
                ui.addTextArea(0, "<font size='25px'><p align='center'>"..txtSit, p, 0, 180, 800, 200, 0, 0, 0, false)
                tfm.exec.bindKeyboard(p, 32, true, true)
                system.bindMouse(p, true)
        elseif mode == "start" then
                drawCard(10, actual, p, 420, 200)
                drawCards(p)
                updatePoints(p)
                updateFlux(p)
        end
        for i, v in pairs(player) do
                updateScore(i, p)
        end
        tfm.exec.respawnPlayer(p)
        tfm.exec.setUIMapName(gameName)
end
 
function eventPlayerLeft(p)
        if mode == "init" then
                if nick[p] then
                        removePlayerUI(p, nick[p])
                end
        elseif mode == "start" then
                if nick[p] and player[nick[p]] then
                        removePlayer(p, nick[p])
                end
        end
end
 
function eventPlayerDied(p)
        tfm.exec.respawnPlayer(p)
end

 
tfm.exec.disableAutoScore(true)
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAfkDeath(true)
for i, v in pairs(commands) do
        system.disableChatCommandDisplay(v, true)
end
for i, v in pairs(tfm.get.room.playerList) do
        tfm.exec.setPlayerScore(i, 0, false)
end
tfm.exec.newGame(mapa)