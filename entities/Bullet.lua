Bullet = {}
Bullet.__index = Bullet

setmetatable(Bullet, {
	__index = Entity,
	__call = function (cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
})

--velocity has to be given as vector {x=***,y=***}
function Bullet:_init(level, position, velocity, size)
	Entity._init(self, level, "Bullet", position)
	
	self.velocity = velocity
	self.size = size
end

function Bullet:update(dt)
	self.position.x = self.position.x + self.velocity.x * dt
	self.position.y = self.position.x + self.velocity.y * dt
	
	local entitiesCollided = self.level:getEntitiesInRange(self.position, self.size)
	
	for index = 1, #entitiesCollided do
		if entitiesCollided[index].type == "character" then
			--kill character here
			
			return
		end
	end
end

function Bullet:draw()
	
end