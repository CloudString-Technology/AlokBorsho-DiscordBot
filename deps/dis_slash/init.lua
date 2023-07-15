local discordia = require 'discordia'
local discordia_interactions = require 'discordia-interactions'

local classes = discordia.class.classes
local enums = discordia.enums
local f = string.format


-- Application commands are native ways to interact with apps in the Discord client.
-- There are 3 types of commands accessible in different interfaces: the chat input,
-- a message's context menu (top-right menu or right-clicking in a message), and a
-- user's context menu (right-clicking on a user).
---@class ApplicationCommand
---@field guild_id? Snowflake
---@field name string
---@field description string
---@field options? CommandOption[]
---@field default_member_permissions string
---@field dm_permission? boolean 
---@field default_permission? boolean # DEPRECATED
---@field nsfw? boolean

---@class ApplicationCommandInfo : ApplicationCommand
---@field id Snowflake
---@field type integer
---@field application_id Snowflake
---@field version Snowflake


-- Slash commands—the CHAT_INPUT type—are a type of application command. They're
-- made up of a name, description, and a block of options, which you can think of
-- like arguments to a function. The name and description help users find your
-- command among many others, and the options validate user input as they fill out
-- your command.
--
-- `CHAT_INPUT` command names and command option names must match the following
-- regex `^[-_\p{L}\p{N}\p{sc=Deva}\p{sc=Thai}]{1,32}$` with the unicode flag set.
-- If there is a lowercase variant of any letters used, you must use those.
---@class SlashCommand : ApplicationCommand

---@class SlashCommandInfo : ApplicationCommandInfo
---@field type 1


-- Required `options` must be listed before optional options
---@class CommandOption
---@field type commandOptionType # Type of option
---@field name string   # 1-32 character name
---@field description string  # 1-100 character description
---@field required? boolean   # If the parameter is required or optional--default false
---@field choices? commandOptionChoice[]  # Choices for STRING, INTEGER, and NUMBER types for the user to pick from, max 25
---@field options? CommandOption[]    # If the option is a subcommand or subcommand group type, these nested options will be the parameters
---@field channel_types? integer[]    # If the option is a channel type, the channels shown will be restricted to these types
---@field min_value? integer    # If the option is an INTEGER or NUMBER type, the minimum value permitted
---@field max_value? integer    # If the option is an INTEGER or NUMBER type, the maximum value permitted
---@field min_length? integer   # For option type STRING, the minimum allowed length (minimum of 0, maximum of 6000)
---@field max_length? integer   # For option type STRING, the maximum allowed length (minimum of 1, maximum of 6000)
---@field autocomplete? boolean # If autocomplete interactions are enabled for this STRING, INTEGER, or NUMBER type option

---@alias commandOptionChoice {name: string, value: string|number}
---@alias commandOptionType
---| 1  # SUB_COMMAND
---| 2  # SUB_COMMAND_GROUP
---| 3  # STRING
---| 4  # INTEGER
---| 5  # BOOLEAN
---| 6  # USER
---| 7  # CHANNEL
---| 8  # ROLE
---| 9  # MENTIONABLE
---| 10 # NUMBER
---| 11 # ATTACHMENT


-- First inject the needed endpoints into Discordia's API.lua
do
  -- define API.request to be identical to discordia/API.request
  local discordia_api = classes.API
  local API = {
    request = discordia_api.request,
  }

  -- endpoints we will need
  local endpoints = {
    guildApplicationCommands  = '/applications/%s/guilds/%s/commands',
    guildApplicationCommand   = '/applications/%s/guilds/%s/commands/%s',
    globalApplicationCommands = '/applications/%s/commands',
    globalApplicationCommand  = '/applications/%s/commands/%s',
  }

  function API:getGlobalApplicationCommands(application_id)
    local endpoint = f(endpoints.globalApplicationCommands, application_id)
    return self:request('GET', endpoint)
  end

  function API:createGlobalApplicationCommand(application_id, payload)
    local endpoint = f(endpoints.globalApplicationCommands, application_id)
    return self:request('POST', endpoint, payload)
  end

  function API:getGlobalApplicationCommand(application_id, command_id)
    local endpoint = f(endpoints.globalApplicationCommand, application_id, command_id)
    return self:request('GET', endpoint)
  end

  function API:editGlobalApplicationCommand(application_id, command_id, payload)
    local endpoint = f(endpoints.globalApplicationCommand, application_id, command_id)
    return self:request('PATCH', endpoint, payload)
  end

  function API:deleteGlobalApplicationCommand(application_id, command_id)
    local endpoint = f(endpoints.globalApplicationCommand, application_id, command_id)
    return self:request('DELETE', endpoint)
  end

  function API:bulkOverwriteGlobalApplicationCommands(application_id, payload)
    local endpoint = f(endpoints.globalApplicationCommands, application_id)
    return self:request('PUT', endpoint, payload)
  end


  function API:getGuildApplicationCommands(application_id, guild_id)
    local endpoint = f(endpoints.guildApplicationCommands, application_id, guild_id)
    return self:request('GET', endpoint)
  end

  function API:createGuildApplicationCommand(application_id, guild_id, payload)
    local endpoint = f(endpoints.guildApplicationCommands, application_id, guild_id)
    return self:request('POST', endpoint, payload)
  end

  function API:getGuildApplicationCommand(application_id, guild_id, command_id)
    local endpoint = f(endpoints.guildApplicationCommand, application_id, guild_id, command_id)
    return self:request('GET', endpoint)
  end

  function API:editGuildApplicationCommand(application_id, guild_id, command_id, payload)
    local endpoint = f(endpoints.guildApplicationCommand, application_id, guild_id, command_id)
    return self:request('PATCH', endpoint, payload)
  end

  function API:deleteGuildApplicationCommand(application_id, guild_id, command_id)
    local endpoint = f(endpoints.guildApplicationCommand, application_id, guild_id, command_id)
    return self:request('DELETE', endpoint)
  end

  function API:bulkOverwriteGuildApplicationCommands(application_id, guild_id, payload)
    local endpoint = f(endpoints.guildApplicationCommands, application_id, guild_id)
    return self:request('PUT', endpoint, payload)
  end


  -- inject the new API calls into the actual discordia/API
  do
    for k, v in pairs(API) do
      rawset(discordia_api, k, v)
    end
  end
end


-- Inject Client methods we will need
do
  ---@type Client
  local discordia_client = classes.Client

  -- A method to create slash commands.
  -- If the `guild_id` field in `command` is present, it creates a guild slash command instead.
  -- it is very bare-bones and only includes stuff we need in this bot.
  -- There is also almost no validation checks. No version control, therefore you are supposed to
  -- have this in a client:once('ready') event, and it will recreate the command on each time you launch the client.
  ---@param command SlashCommand
  ---@return SlashCommandInfo|nil command, string? err
  function discordia_client:createSlashCommand(command)
    local payload = {
      type = 1, -- CHAT_INPUT
      name = command.name,
      description = command.description,
      options = command.options,
      default_member_permissions = command.default_member_permissions,
      dm_permission = command.dm_permission,
      default_permission = command.default_permission,
      nsfw = command.nsfw,
    }
    
    if command.guild_id then
      return self._api:createGuildApplicationCommand(self.user.id, command.guild_id, payload)
    else
      return self._api:createGlobalApplicationCommand(self.user.id, payload)
    end
  end

  -- Takes a list of (slash) application commands, overwriting the existing global command list for this application.
  -- Returns a list of application command objects. Commands that do not already exist will count toward
  -- daily application command create limits.
  -- Specifying the `guildId` parameter will make it override the guild's commands instead.
  ---@param commands SlashCommand[]
  ---@param guildId? Snowflake
  ---@return SlashCommandInfo[]|nil commands, string? err
  function discordia_client:bulkOverwriteApplicationCommands(commands, guildId)
    local payload = {}
    for _, command in pairs(commands) do
      table.insert(payload, {
        type = 1, -- CHAT_INPUT
        name = command.name,
        description = command.description,
        options = command.options,
        default_member_permissions = command.default_member_permissions,
        dm_permission = command.dm_permission,
        default_permission = command.default_permission,
        nsfw = command.nsfw,
      })
    end

    if guildId then
      return self._api:bulkOverwriteGuildApplicationCommands(self.user.id, guildId, payload)
    else
      return self._api:bulkOverwriteGlobalApplicationCommands(self.user.id, payload)
    end
  end

  -- Get the current application's global application commands.
  -- Specifying the `guildId` parameter will return the guild's commands instead.
  ---@param guildId? Snowflake
  ---@return ApplicationCommandInfo[]|nil commands, string? err
  function discordia_client:getApplicationCommands(guildId)
    if guildId then
      return self._api:getGuildApplicationCommands(self.user.id, guildId)
    else
      return self._api:getGlobalApplicationCommands(self.user.id)
    end
  end

  -- Fetch a global application command.
  -- Specifying the `guildId` parameter will return a guild command instead.
  ---@param commandId Snowflake
  ---@param guildId? Snowflake
  ---@return ApplicationCommandInfo|nil command, string? err
  function discordia_client:getApplicationCommand(commandId, guildId)
    if guildId then
      return self._api:getGuildApplicationCommand(self.user.id, guildId, commandId)
    else
      return self._api:getGlobalApplicationCommand(self.user.id, commandId)
    end
  end

  -- Edit a global (slash) application command.
  -- Specifying the `guildId` parameter will edit a guild command instead.
  ---@param commandId Snowflake
  ---@param command SlashCommand
  ---@param guildId? Snowflake
  ---@return SlashCommandInfo|nil command, string? err
  function discordia_client:editApplicationCommand(commandId, command, guildId)
    local payload = {
      type = 1, -- CHAT_INPUT
      name = command.name,
      description = command.description,
      options = command.options,
      default_member_permissions = command.default_member_permissions,
      dm_permission = command.dm_permission,
      default_permission = command.default_permission,
      nsfw = command.nsfw,
    }

    if guildId then
      return self._api:editGuildApplicationCommand(self.user.id, guildId, commandId, payload)
    else
      return self._api:editGlobalApplicationCommand(self.user.id, commandId, payload)
    end
  end

  -- Delete a global application command.
  -- Specifying the `guildId` parameter will delete a guild command instead.
  ---@param commandId Snowflake
  ---@param guildId? Snowflake
  ---@return string|nil empty, string? err
  function discordia_client:deleteApplicationCommand(commandId, guildId)
    if guildId then
      return self._api:deleteGuildApplicationCommand(self.user.id, guildId, commandId)
    else
      return self._api:deleteGlobalApplicationCommand(self.user.id, commandId)
    end
  end
end


-- Add an interactions prelistener to emit needed events
do
  ---@param intr Interaction
  ---@param client Client
  function discordia_interactions.EventHandler.interaction_create_prelisteners.slashCommands(intr, client)
    if intr.type == enums.interactionType.applicationCommand and intr.data.type == 1 then
      client:emit('slashCommand', intr)
    end
  end

  function discordia_interactions.EventHandler.interaction_create_prelisteners.autocomplete(intr, client)
    if intr.type == enums.interactionType.applicationCommandAutocomplete and intr.data.type == 1 then
      client:emit('slashCommandAutocomplete', intr)
    end
  end
end
