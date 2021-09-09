local http = require("coro-http")
local decode = require("json").decode

CMD["quote"] = function(message)
    local _, arg = ext.parseMsg(message, 1)
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

--Currently only taking image photo, will add more features soon!
CMD["promeme"] = function(message)
    ::redo::
    local uri = "https://www.reddit.com/r/ProgrammerHumor/random/.json"
    local Suc, Res = http.request("GET", uri)
    local body = decode(Res)[1].data.children[1]
    local data = body.data
    --
    if data.is_video then
        goto redo
    return end
    message.channel:send{
        embed = {
            title = data.title,
            description = data.selftext,
            image = {
                url = data.url_overridden_by_dest
            },
            thumbnail = {
                url = data.thumbnail
            },
            author = {
                name = data.author,
                url = "https://www.reddit.com"..data.permalink
            }
        },
        reference = { message = message, mention = true}
    }
end


CMD["reddit"] = function(message)
    ::redo::
    local _, arg = ext.parseMsg(message, 1)
    local uri = "https://www.reddit.com/r/"..arg[1].."/random/.json"
    local Suc, Res = http.request("GET", uri)

    if not Suc then
        goto redo
    return end
    
   if decode(Res).error == 404 then
        message:reply("No sub-reddit found, try again.")
    return end
    local body = decode(Res)[1].data.children[1]
    local data = body.data
    --
    if data.is_video then
        goto redo
    return end
    message.channel:send{
        embed = {
            title = data.title,
            description = data.selftext,
            image = {
                url = data.url_overridden_by_dest
            },
            thumbnail = {
                url = data.thumbnail
            },
            author = {
                name = data.author,
                url = "https://www.reddit.com"..data.permalink
            }
        },
        reference = { message = message, mention = true}
    }
end

CMD["joined"] = function(message)
    local m = message.guild:getMember(message.mentionedUsers.first and message.mentionedUsers.first.id or message.author.id)
    local Date = require("discordia").Date
        message.channel:send{
            embed = {
                thumbnail = {url = m.avatarURL},
                fields = {
                    {name = 'Name', value = m.nickname and string.format('%s (%s)', m.username, m.nickname) or m.username, inline = true},
                    {name = 'Discriminator', value = m.discriminator, inline = true},
                    {name = 'ID', value = m.id, inline = true},
                    {name = 'Status', value = m.status:gsub('^%l', string.upper), inline = true},
                    {name = 'Joined Server', value = m.joinedAt and m.joinedAt:gsub('%..*', ''):gsub('T', ' ') or '?', inline = true},
                    {name = 'Joined Discord', value = Date.fromSnowflake(m.id):toISO(' ', ''), inline = true},
                }
            }   
        }
end