-- aylConfig 6.0 by ayellowlizard
-- Oh boy, another rewrite
local aylConfig = {}
pages = {}
configs = {}
keys = {}

-- Core
function aylConfig:format(title, description, subtitle)
    if description then
        description = "\n§r§7" .. description
    else
        description = ""
    end
    if subtitle then
        subtitle = "\n§r" .. subtitle
    else
        subtitle = ""
    end
    return "§l" .. title .. subtitle .. description
end
function aylConfig:init(dPages, dConfigs)
    pages = dPages
    for i,v in pairs(pages) do
        pages[i].page = action_wheel:newPage(pages[i].title)
    end
    -- The reason I am doing a second pass here is because the child might be created before parent, breaking the loop
    for i,v in pairs(pages) do
        if pages[i].parent then
            -- To and from actions for page navigation
            pages[i].to = pages[pages[i].parent].page:newAction()
            :title(aylConfig:format(pages[i].title, pages[i].desc))
            :item(pages[i].item)
            :onLeftClick(function()
                action_wheel:setPage(pages[i].page)
            end)
            pages[i].from = pages[i].page:newAction()
            :title(aylConfig:format("Back", nil))
            :item("minecraft:barrier")
            :onLeftClick(function()
                action_wheel:setPage(pages[pages[i].parent].page)
            end)
        else
            -- Main page
            action_wheel:setPage(pages[i].page)
        end
    end
    configs = dConfigs
    for i,v in pairs(configs) do
        if config:load(i) ~= nil then
            configs[i].value = config:load(i)
        end
        configs[i].action = pages[configs[i].page].page:newAction()
        :item(configs[i].item)
        :toggled(configs[i].value)
        pings[i] = configs[i].func
        if configs[i].type == "boolean" then
            configs[i].action:setOnToggle(pings[i])
        elseif configs[i].type == "integer" or configs[i].type == "string" then
            configs[i].action:setOnScroll(pings[i])
        end
    end
end
-- Save funcs
function aylConfig:saveBoolean(key, value)
    config:save(key, value)
    configs[key].value = value
    -- Title
    local subtitle = nil
    if configs[key].value then
        subtitle = "§2ON"
    else
        subtitle = "§4OFF"
    end
    configs[key].action:setTitle(aylConfig:format(configs[key].title, configs[key].desc, subtitle))
    return value
end
function aylConfig:saveInteger(key, value, auto, min, max, step)
    if not auto then
        value = ((configs[key].value - min + value*step) % (max - min + 1)) + min
        config:save(key, value)
        configs[key].value = value
    end
    configs[key].action:setTitle(aylConfig:format(configs[key].title, configs[key].desc, configs[key].value .. "§7 - Scroll to change value"))
    return value
end
function aylConfig:saveString(key, value, auto, list)
    if not auto then
        local position = nil
        for i,v in ipairs(list) do
            if list[i] == configs[key].value then
                position = i
            end
        end
        value = list[((position-1-value) % #list) + 1]
        config:save(key, value)
        configs[key].value = value
    end
    -- Title
    local subtitle = "§7"
    for i,v in ipairs(list) do
        local newSubtitle = nil
        if list[i] == configs[key].value then
            newSubtitle = "§r> " .. list[i] .. "§7"
        else
            newSubtitle = list[i]
        end
        if i ~= 1 then
            newSubtitle = "\n" .. newSubtitle
        end
        subtitle = subtitle .. newSubtitle
    end
    configs[key].action:setTitle(aylConfig:format(configs[key].title, configs[key].desc, subtitle))
    return value
end
--Networking
function pings.ping(key, value)
    configs[key].value = value
end
function aylConfig:ping()
    for i,v in pairs(configs) do
        pings.ping(i, configs[i].value)
    end
end
function aylConfig:functions()
    for i,v in pairs(configs) do
        configs[i].func(configs[i].value, configs[i].action, true)
    end
end
function events.tick()
    if world.getTime() % 200 == 0 then -- every 10 seconds (200 ticks)
        -- Sync values with other players
        aylConfig:ping()
        -- Run functions based on those synced values
        aylConfig:functions()
    end
end
function events.entity_init()
    aylConfig:functions()
end

return aylConfig