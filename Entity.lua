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
function Entity:_init(entType)
	self.type = entType
end

--functions that every entity need
function Entity:update(dt)
	
end

function Entity:draw()
	
end