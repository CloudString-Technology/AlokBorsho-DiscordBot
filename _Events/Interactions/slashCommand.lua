--[[local exampleCMD = {
    name = "example",
    description = "Example Command",
    guild_id = "..." 

}]]


LoadslashCMD = function (client)
    --client:createSlashCommand(exampleCMD)
end


---@param intr Interaction
---@param client Client
client:on("slashCommand", function(intr)
    local data = intr.data -- Data needs to be loaded, it returns in a table, and data in property name data.
end)
