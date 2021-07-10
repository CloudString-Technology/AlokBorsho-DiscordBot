local discord = require("discordia")

_G.client = discord.Client{
    logFile = 'bot.log',
    cacheAllMembers = true,
} 

_G.dEnum = discord.enums --Loads all type informations here.

discord.extensions() -- load all helpful extensions

_G.timer = require('timer')
_G.fs = require("fs")



client:once("ready", function() -- bot is ready

    client:setGame("https://alokborsho.win")
    print("Logged in as " .. client.user.username)
end)





local dToken = require("./token")

client:run("Bot "..dToken)