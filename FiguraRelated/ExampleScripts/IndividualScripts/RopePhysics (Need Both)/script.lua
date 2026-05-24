vanilla_model.PLAYER:setVisible(false)

local ropephysics = require("rope-physics")

-- ropephysics:new(models.rope.Body.roptest,models.playermodel.RightArm.point3, models.playermodel.LeftArm.point2)
local myrope = ropephysics:new(models.rope.Body.ropeshort,models.playermodel.RightArm.point3, models.playermodel.LeftArm.point2)


------------------------- wait function
local timers = {}
local function wait(ticks,next)
    table.insert(timers, {t=world.getTime()+ticks,n=next})
end
events.TICK:register(function()
    for key,timer in pairs(timers) do
        if world.getTime() >= timer.t then
            timer.n()
            table.remove(timers,key)
        end
    end
end)
-------------------------



function a()
    myrope.attachFront = models.playermodel.RightArm.point3
    myrope.attachBack = models.playermodel.LeftArm.point2
    wait(40,b)
end

function b()
    myrope.attachFront = models.playermodel.RightArm.point3
    myrope.attachBack = nil
    wait(40,c)
end

function c()
    myrope.attachFront = models.playermodel.LeftArm.point2
    myrope.attachBack = models.playermodel.RightArm.point3
    wait(40,d)
end

function d()
    myrope.attachFront = models.playermodel.LeftArm.point2
    myrope.attachBack = nil
    wait(40,a)
end

a()