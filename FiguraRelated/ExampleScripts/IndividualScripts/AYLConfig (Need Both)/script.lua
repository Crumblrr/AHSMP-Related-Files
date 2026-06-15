local aylConfig = require("aylConfig")
config:setName("aylConfig")

local dPages = {
    main = {},
    child = {parent = "main", item = "minecraft:structure_void", title = "Child", desc = "GET OUT OF MY ROOM I'M PLAYING MINECRAFT"},
    grandchild = {parent = "child", item = "minecraft:structure_block", title = "Grandchild", desc = "Goo goo ga ga"},
}
local dConfigs = {
    woof = {page = "main", type = "boolean", value = true, item = "minecraft:bone", title = "Woof", desc = "Bluey", func = function(value, action, auto)
        value = aylConfig:saveBoolean("woof", value)
        if not auto then
            log(value)
        end
    end},
    meow = {page = "child", type = "integer", value = 1, item = "minecraft:cod", title = "Meow", desc = "Catdog", func = function(value, action, auto)
        value = aylConfig:saveInteger("meow", value, auto, 0, 20, 1)
        if not auto then
            log(value)
        end
    end},
    cluck = {page = "main", type = "string", value = "two", item = "minecraft:feather", title = "Cluck", desc = "Chicken or the egg?", func = function(value, action, auto)
        value = aylConfig:saveString("cluck", value, auto, {"one", "two", "three", "four"})
        if not auto then
            log(value)
        end
    end},
}
aylConfig:init(dPages, dConfigs)