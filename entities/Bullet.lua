require "../Entity"

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
	self.position.y = self.position.y + self.velocity.y * dt
	
	if self.position.x < 0 or self.position.y < 0 or self.position.x > 1280 or self.position.y > 720 then
		self.level:removeEntity(self)
		return
	end
	
	local entitiesCollided = self.level:getEntitiesInRange(self.position, self.size)
	
	for index = 1, #entitiesCollided do
		if entitiesCollided[index].type == "Character" then
			entitiesCollided[index]:die()
			return
		end
	end
end

function Bullet:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.circle("fill", self.position.x, self.position.y, self.size, segments)
end