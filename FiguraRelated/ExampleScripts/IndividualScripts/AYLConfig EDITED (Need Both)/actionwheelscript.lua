-- THIS VERSION INCLUDES THE BUTTON ACTION, ADDED BY CRUMB
local aylConfig = require("aylConfig")
config:setName("aylConfig")

local dPages = {
    main = {},
    child = {parent = "main", item = "minecraft:structure_void", title = "Child", desc = "GET OUT OF MY ROOM I'M PLAYING MINECRAFT"},
    grandchild = {parent = "child", item = "minecraft:structure_block", title = "Grandchild", desc = "Goo goo ga ga"},
}
local dConfigs = {
    toggle = {page = "main", type = "boolean", value = true, item = "minecraft:lever", title = "Toggle Me!", desc = "Bluey", func = function(value, action, auto)
        value = aylConfig:saveBoolean("toggle", value)
        if not auto then
            log(value)
        end
    end},
    scroll = {page = "child", type = "integer", value = 1, item = "minecraft:cod", title = "Scrolley Rolley!", desc = "Catdog", func = function(value, action, auto)
        value = aylConfig:saveInteger("scroll", value, auto, 0, 20, 1)
        if not auto then
            log(value)
        end
    end},
    select = {page = "main", type = "string", value = "two", item = "minecraft:feather", title = "Scroll (But Less Values)", desc = "Chicken or the egg?", func = function(value, action, auto)
        value = aylConfig:saveString("select", value, auto, {"one", "two", "three", "four"})
        if not auto then
            log(value)
        end
    end},

-- CRUMB ACTIONS FOR YOU!

    button = {page = "main", type = "button", value = true, item = "minecraft:oak_button", title = "One Time Button", desc = "Useful for playing a 1-off anim, like Jester Dance", func = function(value, action, auto)
        value = aylConfig:saveButton("button", value)
        if not auto then
            log(value)
        end
    end},
                                                        -- | THIS DETERMINES WHAT THE DEFAULT VALUE IS! IDK WHY IT IS AT TWO AUTOMATICALLY!
                                                        -- V  
    crumbselect = {page = "main", type = "string", value = "two", item = "minecraft:feather", title = "Select State", desc = "Functional Scroll Action to Change States of Something", func = function(value, action, auto)
        value = aylConfig:saveString("crumbselect", value, auto, {"one", "two", "three", "four"})
        --if not auto then <--- COMMENT THIS BS OUT OR REMOVE IT! IDC!
            if value == "one" then
                log("Hi, I'm your first state! I make you visible, but I make your held items invisible!")
                vanilla_model.PLAYER:setVisible(true)
                vanilla_model.HELD_ITEMS:setVisible(false)
            end
            if value == "two" then
                log("Hi, I'm your second state! I make you AND your held items visible!")
                vanilla_model.PLAYER:setVisible(true)
                vanilla_model.HELD_ITEMS:setVisible(true)
            end
            if value == "three" then
                log("Hi, I'm your third state! I make you AND your held items invisible!")
                vanilla_model.PLAYER:setVisible(false)
                vanilla_model.HELD_ITEMS:setVisible(false)
            end
            if value == "four" then
                log("Hi, I'm your fourth state! I don't change any visibility values. If you select me, you will just be whatever state you were before me! Unlike that prior state, I don't force the effect. If these states were, say, running scale commands for you, leaving one blank would mean that you could run scale commands in game without them being overriden!") 
            end
        --end
    end},

}
aylConfig:init(dPages, dConfigs)