--[[
	Message module should contain: 
	messageCreate(message) [Once a message created by a guild member inside GuildTextChannel]
	messageUpdate(message) [Once a message inside GuildTextChannel get edited/updated]
	messageDelete(message) [When a message from GuildTextChannel get removed]
	buttonPressed(type, buttonid, member, message, values) [Message intraction button based]
]]
require("./message")

--[[
	Channel module should contain:
	channelCreate(channel) [When a GuildTextChannel is created]
	channelUpdate(channel) [When a GuildTextChannel is updated/edited]
	channelDelete(channel) [When a GuildTextChannel is removed]
	pinsUpdate(channel) [Pinned message update related to GuildTextChannel]
	typing(userID, channelID, timestamp) [When a user types in a GuildTextChannel, with time]
	webhooksUpdate(channel) [webhook update in a GuildTextChannel]
]]
require("./channel")

--[[
	Guild module should contain: 
	guildCreate(guild) [When the bot joins a Guild for the first time]
	guildUpdate(guild) [Any kind of update within the guild]
	guildDelete(guild) [When bot get removed from a guild]
	inviteCreate(invite, guild) [when a user creates a invite in a guild]
	guildAvailable,
	guildUnavailable
]]
require("./guild")

--[[
	Member Module should contain:
	userBan(user, guild) [When a user get banned from a Guild]
	userUnban(user, guild) [A user gets unbanned from a Guild]
	userUpdate(user) [User update, cached to client.user]
	memberJoin(member) [A member joins a guild]
	memberLeave(member) [Once a member leaves a guild]
	memberUpdate(member) [Member's update within the guild]
	presenceUpdate
]]
require("./member")

--[[
	Role Module should contain:
	roleCreate(role) [Role created in a guild] 
	roleUpdate(role) [All kinds of update of a role]
	roleDelete(role) [Role has been removed from a guild]
]]
require("./role")

--[[
	Voice Module should contain:
	voiceConnect(member) [Once a member joins a GuildVoiceChannel]
	voiceDisconnect(member) [Left a GuildVoiceChannel]
	voiceUpdate(member) [Member's update while being inside a Guildvoicechannel]
	voiceChannelJoin(member, channel) [GuildVoiceChannel where the member joined]
	voiceChannelLeave(member, channel) [Once a member leave GuildVoiceChannel]
]]
require('./voice')






---Added all interactions
require('./interactions')