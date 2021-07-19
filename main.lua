--Making the whole script inside one single coroutine coro-* works, also async works more easily.
coroutine.wrap(function() 

    --Error handling
    local Suc, error = pcall(function()
        
        require("./app") -- Require the bot script.

    end)
    if not Suc then
        print("ERROR:", error)
    end
end)()


--Do not change anything here!

--TEST PUSH FOR GITHUB