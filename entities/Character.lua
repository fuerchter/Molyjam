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
end

function Character:update(dt)
	local speed = 10
	local leftClip = 10
	local topClip = 10
	local rightClip = 100
	local bottomClip = 300

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
	
	if self.position.x < leftClip then
		self.position.x = leftClip
	end
	if self.position.y < topClip then
		self.position.y = topClip
	end
	if self.position.x > rightClip then
		self.position.x = rightClip
	end
	if self.position.y > bottomClip then
		self.position.y = bottomClip
	end
end

function Character:draw()

end