CMD["ping"] = function(message)
    message:reply("pong")
end

CMD["quote"] = function(message)
    local _, arg = parseMsg(message, 1)
    if tonumber(arg[1]) == nil then 
        message:reply("It must be snowflake ID") return end
    
    local msgChannel = message.mentionedChannels.first or message.channel

    local  Msg = msgChannel:getMessage(arg[1])
    if not Msg then
        message:reply("Couldn't find the quote you looking for.") return end

    message:reply{
        embed = {
            author = {
                name = Msg.author.username,
                icon_url = Msg.author.avatarURL
            },
            description = "```"..Msg.content.."```",
            footer = {
                text = "#".. msgChannel.name
            },
            timestamp = Msg.timestamp,
        }
    }
end

