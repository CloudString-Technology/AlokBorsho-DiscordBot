local object = require("core").Object
local spamObj = object:extend()
local timer = require('timer')
local spam = {}

function spamObj:initialize(id)
    local id = type(id) == string and id or id.id
    self.id = id
    self.prevMessage = nil
    self.warning = 0
    self.warnLevel = 0
    self.Messages = {}
end
function spamObj:check(message)
    p(self.prevMessage, self.warnLevel, self.warning, "prev MEssages")
    local content = message.content:lower()
    if not self.prevMessage then
        self.prevMessage = { id = message.id, content = message.content:lower(), channel = message.channel.id}
    return end

    if content:match(".*("..self.prevMessage.content..").*") then
        self.warning = self.warning + 1
        if self.prevMessage then
            table.insert(self.Messages, self.prevMessage)
        end
        self.prevMessage = { id = message.id, content = message.content:lower(), channel = message.channel.id}
    end
    if self.warning > 3 then
        self:SendWarning(message)
    end
end

function spamObj:SendWarning(message)

    local mem = message.member
    self.warnLevel = self.warnLevel + 1
    local lvl = self.warnLevel == 0 and 1 or self.warnLevel

    self.prevMessage = nil
    self.warning = 0
    
    --member:addRole("")
    message:reply("You have been muted")
    timer.setTimeout(30*1000, function()
     --   member:removeRole("")
    end)
end

--;


local spamControl = function(member, client, message)
    local ID = member.id
    if spam[ID] == nil then 
        spam[ID] = spamObj:new(ID)
    end
    spam[ID]:check(message)
end

return spamControl