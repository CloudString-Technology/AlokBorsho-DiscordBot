---@param message Message
client:on("messageCreate", function(message)

    --Restricted the Command/Content feature only for Normal users.
    if message.author == client.user then return end
    if message.author.bot then return end
    if not message.guild then return end

    --spamControl(message.author, client, message)
    --Start of Command Module.
    local cmd, content = parseMsg(message)
    if not CMD[cmd] then return end
    local suc, error = pcall(function() CMD[cmd](message, content) end)
    if not suc then 
        print("ERROR:", error)
    end
    --end of Command Module
end)
