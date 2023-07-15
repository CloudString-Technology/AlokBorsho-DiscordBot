local discord = require("discordia")
require("discordia-components")
require("discordia-interactions")
require("dis_slash")

_G.client = discord.Client{
    logFile = 'bot.log',
    cacheAllMembers = true,
    syncGuilds = true
} 

client:enableAllIntents()

_G.dEnum = discord.enums --Loads all type informations here.

discord.extensions() -- load all helpful extensions


require("./extensions")()

_G.LoadslashCMD = nil

client:once("ready", function() -- bot is ready
    client:setActivity("https://alokborsho.win")
    print("Logged in as " .. client.user.username)
    if not LoadslashCMD == nil and type(LoadslashCMD) == "function" then
        LoadslashCMD(client)
    end
end)


--local spamControl = require("./_Commands/spam")




require("./_Events")

local dToken = require("./token")
client:run("Bot "..dToken)