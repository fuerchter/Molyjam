require "../Entity"
require "../Opinions"
require "../entities/Bullet"

Viewer = {}
Viewer.__index = Viewer

setmetatable(Viewer, {
	__index = Entity,
	__call = function (cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
})

function Viewer:_init(level, opinions, position)
	Entity._init(self, level, "Viewer", position)
	
	self.statusList={}
	self.statusList[1]="happy"
	self.statusList[2]="pissed"
	self.statusList[3]="amok"
	
	self.status=1
	
	self.bulletTime = 0
	
	--make sure there are only two opinions
	local counter = 0
	
	for i=1, #Opinions do
		
		if counter == 1 then
			opinions[i] = false
		end
	
		if opinions[i] == true then
			counter = counter + 1
		end
	end

	self.opinions=opinions
	
	self.image=love.graphics.newImage("assets/viewer.png")
end

function Viewer:calculateStatus(quote)
	for index = 1, #self.opinions do
		if(self.opinions[index])
		then
			self.status=self.status+quote.influence[index]
		end
	end
	
	if(self.status<1)
	then
		self.status=1
	elseif(self.status>3)
	then
		self.status=3
	end
end

function Viewer:update(dt)
	self.bulletTime = self.bulletTime + dt

	if self.status == 2 then
		if self.bulletTime > 2 then
			self.bulletTime = 0
			
			local speed = -30
			local y = math.random(1, 10)
			local x = math.random(1, 10)
			local length = math.sqrt(x*x + y*y)
			
			local length_y = (y / length) * speed
			
			if math.random() > 0.5 then
					length_y = length_y * -1
			end
			
			local length_x = (x / length) * speed
			
			Bullet(self.level, {x=self.position.x, y=self.position.y}, {x = length_x, y = length_y})
		end
	elseif self.status == 3 then
		if self.bulletTime > 2 then
			self.bulletTime = 0
			
			local characters = self.level:getEntitiesByType("Character")
			
			if #characters == 1 then
				local speed = -50
				local y = math.abs(characters[1].position.y - self.position.y)
				local x = math.abs(characters[1].position.x - self.position.x)
				local length = math.sqrt(x*x + y*y)
				
				local length_y = (y / length) * speed
				
				if characters[1].position.y - self.position.y > 0 then
					length_y = length_y * -1
				end
				
				local length_x = (x / length) * speed
				
				Bullet(self.level, {x=self.position.x, y=self.position.y}, {x = length_x, y = length_y})
			end
		end
	end
end

function Viewer:draw()
	love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
end