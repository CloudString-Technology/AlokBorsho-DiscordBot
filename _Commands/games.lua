local function PlayRPS(message, input)
    if input ~= "rock" and input ~= "paper" and input ~= "scissors" then return end 
    local hands = {
        ["1"] = "Paper",
        ["2"] = "Rock",
        ["3"] = "Scissors",
        ["paper"] = 1,
        ["rock"] = 2,
        ["scissors"] = 3
    }   
    local used = hands[input:lower()]
    math.randomseed(os.time())
    local com = math.random(1, 3)
    local comPick = hands[tostring(com)]

    if used == com then 
        return message:reply(comPick.."\nTie! We both picked same!")
    end
    
    if (used == 1 and com == 2) or (used == 2 and com == 3) or (used == 3 and com == 1) then 
        return message:reply(comPick.."\nHurray! You won!")
    else return message:reply(comPick.."\nSad! You lost!")
    end
end

CMD['pick'] = function(message)
    local _, arg = parseMsg(message, 1)
    PlayRPS(message, arg[1])
end
