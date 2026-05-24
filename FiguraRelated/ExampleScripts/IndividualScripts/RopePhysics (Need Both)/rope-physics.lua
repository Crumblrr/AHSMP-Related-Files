-- Rope Physics by Manuel_

local Node = {}
Node.__index = Node

---@param value ModelPart
function Node.new(value)
    local self = setmetatable({}, Node)
    self.value = value
    self.prev = nil
    self.next = nil
    return self
end

local DoublyLinkedList = {}
DoublyLinkedList.__index = DoublyLinkedList

function DoublyLinkedList.new()
    local self = setmetatable({}, DoublyLinkedList)
    self.head = nil
    self.tail = nil
    return self
end

function DoublyLinkedList:insert(value)
    local newNode = Node.new(value)
    if not self.head then
        self.head = newNode
        self.tail = newNode
    else
        newNode.prev = self.tail
        self.tail.next = newNode
        self.tail = newNode
    end
end

function DoublyLinkedList:remove(value)
    local current = self.head
    while current do
        if current.value == value then
            if current.prev then
                current.prev.next = current.next
            else
                self.head = current.next
            end
            if current.next then
                current.next.prev = current.prev
            else
                self.tail = current.prev
            end
            return
        end
        current = current.next
    end
end

local Ropes = {}

local Rope = {}
Rope.__index = Rope

--- Create a new rope out of all children in a group
---@param group ModelPart
---@param attachFront ModelPart | nil
---@param attachBack ModelPart | nil
function Rope:new(group,attachFront,attachBack)
    local new = setmetatable({}, Rope)
    group:setParentType("World")
    new.attachFront = attachFront
    new.attachBack = attachBack
    new.rope = DoublyLinkedList.new()
    for _, child in pairs(group:getChildren()) do
        new.rope:insert(child)
    end
    local cr = new.rope.head
    while cr do
        cr.value:setPos(new.attachFront:partToWorldMatrix():apply()*16)
        cr = cr.next
    end
    new.distance = 2
    new.threshold = 0.1
    table.insert(Ropes,new)
    return new
end

local function isInsideBlock(pos)
    local block = world.getBlockState(pos)
    local posx, posy, posz = (pos - block:getPos()):unpack()
    for _, bbox in ipairs(block:getCollisionShape()) do
        if (bbox[1].x < posx and posx < bbox[2].x)
            and (bbox[1].y < posy and posy < bbox[2].y)
            and (bbox[1].z < posz and posz < bbox[2].z)
        then
            return true
        end
    end
    return false
end

local function renderRope(rope,delta)
    local current = rope.rope.head
    while current do
        if current == rope.rope.head then
            current.value:setPos(rope.attachFront:partToWorldMatrix():apply()*16)

            -- rotate head and tail first before any of the middle ones
            local dist, pitch, yaw
            -- Rotate first element
            dist = rope.rope.head.next.value:getPos() - rope.rope.head.value:getPos()
            yaw = rope.rope.head.next.value:getRot().y
            if math.abs(dist.x) > rope.threshold and math.abs(dist.z) > rope.threshold then
                yaw = math.deg(math.atan2(dist.x,dist.z))
            end
            pitch = -math.deg(math.atan2(dist.y, math.sqrt(dist.x * dist.x + dist.z * dist.z)))
            rope.rope.head.value:setRot(pitch,yaw,0)

            -- Rotate last element
            dist = rope.rope.tail.prev.value:getPos() - rope.rope.tail.value:getPos()
            yaw = rope.rope.tail.prev.value:getRot().y
            if math.abs(dist.x) > rope.threshold and math.abs(dist.z) > rope.threshold then
                yaw = math.deg(math.atan2(dist.x,dist.z))-180
            end
            pitch = math.deg(math.atan2(dist.y, math.sqrt(dist.x * dist.x + dist.z * dist.z)))
            rope.rope.tail.value:setRot(pitch,yaw,0)

        elseif rope.attachBack and current == rope.rope.tail then
            current.value:setPos(rope.attachBack:partToWorldMatrix():apply()*16)

        elseif current.prev and (not rope.attachBack or current.next) then
            -- calculate position
            local targetpos = current.value:getPos()
            local d = 0
            -- while d > -2 and not world.getBlockState(targetpos/16):isSolidBlock() do
            while d > -2 and not isInsideBlock(targetpos/16) do
                d = d - 0.1
                targetpos = current.value:getPos() + vec(0,d,0)
            end
            current.value:setPos(targetpos)


            --------------------------------------------
            -- this needs to be improved still... might be better to just use arrays instead of doubly linked list
            local index = 0
            local length = 1
            local cr = rope.rope.head
            while cr do
                index = index + 1
                if cr == current then
                    break
                end
                cr = cr.next
            end
            cr = rope.rope.head
            while cr do
                length = length + 1
                cr = cr.next
            end
            ----------------------------------------------


            local dist1 = current.value:getPos() - current.prev.value:getPos()
            local newpos1 = targetpos
            if dist1:length() > rope.distance then
                newpos1 = current.prev.value:getPos() + dist1:normalized()*rope.distance
            end
            local newpos2 = newpos1

            -- calculate rotation
            local yaw, pitch, pitch2
            pitch = -math.deg(math.atan2(dist1.y, math.sqrt(dist1.x * dist1.x + dist1.z * dist1.z)))
            pitch2 = pitch
            yaw = current.prev.value:getRot().y
            if math.abs(dist1.x) > rope.threshold and math.abs(dist1.z) > rope.threshold then
                yaw = math.deg(math.atan2(dist1.x,dist1.z))
            end

            -- make changes if two connections
            if rope.attachBack then
                local dist2 = current.value:getPos() - current.next.value:getPos()
                if dist2:length() > rope.distance then
                    newpos2 = current.next.value:getPos() + dist2:normalized()*rope.distance
                end
                pitch2 = math.deg(math.atan2(dist2.y, math.sqrt(dist2.x * dist2.x + dist2.z * dist2.z)))
            end

            -- apply position
            current.value:setPos((newpos1*(0+(length-index))+newpos2*(0+(index)))/(0+length))

            -- apply rotation
            current.value:setRot((pitch+pitch2)/2,yaw,0)

        end

        current.value:setLight(world.getLightLevel(current.value:getPos())) -- fix bad lighting when inside block

        current = current.next
    end
end

function events.render(delta)
    for _, rope in ipairs(Ropes) do
        renderRope(rope,delta)
    end
end

return Rope