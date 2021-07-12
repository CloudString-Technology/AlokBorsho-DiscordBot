
local pp = require('pretty-print')

local function prettyLine(...)
	local ret = {}
	for i = 1, select('#', ...) do
		local arg = pp.strip(pp.dump(select(i, ...)))
		table.insert(ret, arg)
	end
	return table.concat(ret, '\t')
end

local function printLine(...)
	local ret = {}
	for i = 1, select('#', ...) do
		local arg = tostring(select(i, ...))
		table.insert(ret, arg)
	end
	return table.concat(ret, '\t')
end


local function code(str)
	return string.format('```\n%s```', str)
end

local sandbox = {
    math = math,
    string = string,
    coroutine = coroutine,
    os = os,
    pairs = pairs,
    table = table,
    type = type,
    collectgarbage = collectgarbage
}

local codedLines = {}

local function executeLua(arg, msg)
    if not arg then return end
--    if msg.author.id ~= msg.client.owner.id or "314245165776764928" then return end

    arg = arg:gsub('```\n?', '') -- strip markdown codeblocks
    if arg:find("os.exit()") then return end
    local lines = {}

    sandbox.print = function(...)
        table.insert(lines, printLine(...))
    end

    sandbox.p = function(...)
        table.insert(lines, prettyLine(...))
    end

    local fn, syntaxError = load(arg, 'AlokBorsho', 't', sandbox)
    if not fn then return msg:reply(code(syntaxError)) end

    local success, runtimeError = pcall(fn)
    if not success then return msg:reply(code(runtimeError)) end

    lines = table.concat(lines, '\n')

    if #lines > 1990 then -- truncate long messages
        lines = lines:sub(1, 1990)
    end
    local replyCode = code(lines)
    if replyCode:len() > 7 then 
        return msg.channel:send({
            content = replyCode,
            reference = {message = msg, mention = true}
            })
    end
end
local function executeLuaOwner(arg, msg, client)
    if not arg then return end
--    if msg.author.id ~= msg.client.owner.id or "314245165776764928" then return end

    arg = arg:gsub('```\n?', '') -- strip markdown codeblocks

    local lines = {}

    sandbox.message = msg
    sandbox.guild = msg.guild
    sandbox.channel = msg.channel

    if msg.author == client.owner then
        sandbox.client = client
    end
    sandbox.print = function(...)
        table.insert(lines, printLine(...))
    end

    sandbox.p = function(...)
        table.insert(lines, prettyLine(...))
    end
    local fn, syntaxError = load(arg, 'AlokBorsho', 't', sandbox)
    if not fn then return msg:reply(code(syntaxError)) end

    local success, runtimeError = pcall(fn)
    if not success then return msg:reply(code(runtimeError)) end

    lines = table.concat(lines, '\n')

    if #lines > 1990 then -- truncate long messages
        lines = lines:sub(1, 1990)
    end

    local replyCode = code(lines)
    sandbox.message = nil
    sandbox.guild = nil
    sandbox.channel = nil
    sandbox.client = nil
    if replyCode:len() > 7 then 
        return msg.channel:send({
            content = replyCode,
            reference = {message = msg, mention = true}
            })
    end
end

local function isAutho(client, message)
    local id = message.author.id
    if id == client.owner.id then return true end
    if id == message.guild.owner.id then return true end
    return false
end



CMD["exec"] = function(message, content)
    if not content then return message:reply("No content found to execute!\nYou can execute Lua here. However, Discord API can be used by Guild/Client owner.")  end
    if isAutho(client, message) then
        return executeLuaOwner(content, message, client) 
    end
    if not isAutho(client, message) then
        return executeLua(content, message) 
    end
end
