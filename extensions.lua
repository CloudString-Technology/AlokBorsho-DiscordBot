_G.timer = require("timer")
_G.http = require("coro-http")
_G.fs = require("fs")
_G.json = require("json")

local ext = {}

local prefix = '+'
ext.parseMsg = function(message, num)
	local content = type(message) ~= string and message.content or message
	local num = num or 0
	local cmd, arg, line
	local ntable = {}
	if content:find(prefix, 1, true) ~= 1 then return end

	content = content:sub(prefix:len() + 1)
	cmd, arg = content:match('(%S+)%s+(.*)')
	if num ~= 0 then 
		arg = arg:split("%s+")
		for i = 1, num do
			table.insert(ntable, arg[i])
		end
		line = table.concat(arg, " ", num+1)
	end
	if #ntable ~= 0 then arg = ntable or arg end
	return cmd or content, arg, line
end

ext.anAdmin = function(author)
	-- body
end


local globaltables = setmetatable({
	ext = ext
}, {__call = function(self)
	for _, v in pairs(self) do
		v()
	end
end})

for n, m in pairs(globaltables) do
	_G[n] = _G[n] or {}
	setmetatable(m, {__call = function(self)
		for k, v in pairs(self) do
			_G[n][k] = v
		end
	end})
end

return globaltables
