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

	self.opinions=opinions
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
			Bullet(self.level, self.position, {x = -10, y = 0})
		end
	elseif self.status == 3 then
		if self.bulletTime > 2 then
			self.bulletTime = 0
			
			local characters = self.level:getEntitiesByType("Character")
			
			if #characters == 1 then
				local speed = -10
				local y = math.abs(characters[1].position.y - self.position.y)
				local x = math.abs(characters[1].position.x - self.position.x)
				local length = math.sqrt(x*x + y*y)
				
				local length_y = (y / length) * speed
				local length_x = (x / length) * speed
				
				Bullet(self.level, self.position, {x = length_x, y = length_y})
			end
		end
	end
end

function Viewer:draw()

end