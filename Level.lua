Level = {}
Level.__index = Level

setmetatable(Level, {
	__call = function (cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
})

function Level:_init()
	self.maxSurvival=5
	self.survivalTimer=0
	
	self.maxChoice=1
	self.choiceTimer=0
	
	self.survival=true
	
	self.timer=0
	
end

function Level:update(dt)
	if(self.survivalTimer>=self.maxSurvival)
	then
		self.survivalTimer=0
		self.survival=false
	end
	
	if(self.choiceTimer>=self.maxChoice)
	then
		self.choiceTimer=0
		self.survival=true
	end
	
	if(self.survival==true)
	then
		self.survivalTimer=self.survivalTimer+dt
	else
		self.choiceTimer=self.choiceTimer+dt
	end
end

function Level:draw()
	
end