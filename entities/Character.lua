require "../Entity"

Character = {}
Character.__index = Character

setmetatable(Character, {
	__index = Entity,
	__call = function (cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
})

function Character:_init(level, position)
	Entity._init(self, level, "Character", position)
	
	self.image=love.graphics.newImage("assets/viewer.png")
end

function Character:die()
	self.level:removeEntity(self)
end

function Character:update(dt)
	local speed = 40
	local leftClip = 0
	local topClip = 0
	local rightClip = self.level.stageRect.width
	local bottomClip = self.level.stageRect.height

	if love.keyboard.isDown("w") then
		self.position.y = self.position.y - speed * dt
	end
	if love.keyboard.isDown("s") then
		self.position.y = self.position.y + speed * dt
	end
	if love.keyboard.isDown("a") then
		self.position.x = self.position.x - speed * dt
	end
	if love.keyboard.isDown("d") then
		self.position.x = self.position.x + speed * dt
	end
	
	if self.position.x-self.image:getWidth()/2 < leftClip then
		self.position.x = leftClip+self.image:getWidth()/2
	end
	if self.position.y-self.image:getHeight()/2 < topClip then
		self.position.y = topClip+self.image:getHeight()/2
	end
	if self.position.x+self.image:getWidth()/2 > rightClip then
		self.position.x = rightClip-self.image:getWidth()/2
	end
	if self.position.y+self.image:getHeight()/2 > bottomClip then
		self.position.y = bottomClip-self.image:getHeight()/2
	end
end

function Character:draw()
	love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
end