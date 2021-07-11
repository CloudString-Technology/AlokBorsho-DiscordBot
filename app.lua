local discord = require("discordia")

_G.client = discord.Client{
    logFile = 'bot.log',
    cacheAllMembers = true,
} 

_G.dEnum = discord.enums --Loads all type informations here.

discord.extensions() -- load all helpful extensions


require("./extensions")


client:once("ready", function() -- bot is ready

    client:setGame("https://alokborsho.win")
    print("Logged in as " .. client.user.username)
end)

_G.CMD = {}

require("./_Commands/public") --Added public commands

---@param message Message
client:on("messageCreate", function(message)

    --Restricted the Command/Content feature only for Normal users.
    if message.author == client.user then return end
    if message.author.bot then return end
    if not message.guild then return end

    local cmd, arg = parseMsg(message.content)
    if CMD[cmd] then CMD[cmd](message, arg) end

end)



local dToken = require("./token")
client:run("Bot "..dToken)