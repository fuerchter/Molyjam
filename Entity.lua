require "Hitbox"

Entity = {}
Entity.__index = Entity

setmetatable(Entity, {
	__call = function (cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
})

--creates an entity
function Entity:_init(level, entType, position)
	self.position = position
	self.type = entType
	self.level = level
	--standard hitbox is offscreen
	self.hitbox = Hitbox({x = -100, y = -100}, 0, 0)
	
	level:registerEntity(self)
end

--register hitbox
function Entity:setHitbox(hitbox)
	self.hitbox = hitbox
end

function Entity:updateHitbox(x_offset, y_offset)
	self.hitbox.position.x = self.position.x + x_offset
	self.hitbox.position.y = self.position.y + y_offset
end

--functions that every entity need
function Entity:update(dt)
	
end

function Entity:draw()
	
end