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
	
	self.hitboxOffset = 18
	self.movementTimer = 0
	
	self.image=love.graphics.newImage("assets/character1.png")
	self.image2=love.graphics.newImage("assets/character2.png")
	self:setHitbox(Hitbox({x = position.x, y = position.y}, self.image:getWidth() - self.hitboxOffset, self.image:getHeight() - self.hitboxOffset))
end

function Character:die()
	self.level:removeEntity(self)
end

function Character:update(dt)
	local speed = 70
	local leftClip = 0
	local topClip = 0
	local rightClip = self.level.stageRect.width
	local bottomClip = self.level.stageRect.height
	local moved = false

	local velocity={x=0, y=0}
	
	if love.keyboard.isDown("w") then
		velocity.y=velocity.y-1
		moved = true
	end
	if love.keyboard.isDown("s") then
		velocity.y=velocity.y+1
		moved = true
	end
	if love.keyboard.isDown("a") then
		velocity.x=velocity.x-1
		moved = true
	end
	if love.keyboard.isDown("d") then
		velocity.x=velocity.x+1
		moved = true
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
	
	self:updateHitbox(-(self.image:getWidth()-self.hitboxOffset)/2, -(self.image:getHeight()-self.hitboxOffset)/2)
	
	if moved then
		self.movementTimer = self.movementTimer + dt
	end
	
	if self.movementTimer > 1 then
		self.movementTimer = 0
	end
end

function Character:draw()
	if self.movementTimer < 0.5 then
		love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
	else
		love.graphics.draw(self.image2, self.position.x, self.position.y, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
	end
end