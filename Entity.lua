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
	
	level:registerEntity(self)
end

--functions that every entity need
function Entity:update(dt)
	
end

function Entity:draw()
	
end