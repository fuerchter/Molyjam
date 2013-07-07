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

	local velocity={x=0, y=0}
	
	if love.keyboard.isDown("w") then
		velocity.y=velocity.y-1
	end
	if love.keyboard.isDown("s") then
		velocity.y=velocity.y+1
	end
	if love.keyboard.isDown("a") then
		velocity.x=velocity.x-1
	end
	if love.keyboard.isDown("d") then
		velocity.x=velocity.x+1
	end
	
	local length=math.sqrt(math.pow(velocity.x, 2)+math.pow(velocity.y, 2))
	if(length~=0)
	then
		--normalize velocity and multiply it by the character speed
		velocity.x=velocity.x/length*speed*dt
		velocity.y=velocity.y/length*speed*dt
	end
	self.position.x=self.position.x+velocity.x
	self.position.y=self.position.y+velocity.y
	
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