require "Quote"
require "Opinions"
require "entities/Viewer"

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
	
	self.maxChoice=2
	self.choiceTimer=0
	self.choicesToGenerate=4
	
	self.survival=true
	self.choiceMade=false
	
	self.timer=0
	
	self.entities = {}
	
	self:loadQuotes()
	
	self.minViewers=5
	self.maxViewers=10
	self:generateViewers()
end

function Level:registerEntity(entity)
	table.insert(self.entities, entity)
end

function Level:removeEntity(entity)
	pos = self:findEntity(entity)
	if pos ~= -1 then
		table.remove(self.entities, pos)
	end
end

function Level:getEntityByType(entType)
	local foundEntites = {}

	for i = 1, #self.entities do
		if self.entities[i].type == entType then
			table.insert(foundEntities, self.entities[i])
		end
	end
	
	return foundEntities
end

function Level:findEntity(entity)
	for i = 1, #self.entities do
		if self.entities[i] == entity then
			return i
		end
	end
	return -1
end

function Level:getEntitiesInRange(position, radius)
	local foundEntites = {}

	for i = 1, #self.entities do
		--and do the pythagoras
		local x = self.entities[i].position.x - position.x
		local y = self.entities[i].position.y - position.y
		local r = math.sqrt(x*x + y*y)
	
		if r <= radius then
			table.insert(foundEntities, self.entities[i])
		end
	end
	
	return foundEntities
end

function Level:loadQuotes()
	self.quotes={}
	local xmlParser = require("xml/xmlSimple").newParser()
	local xmlFile = love.filesystem.newFile("quotes.xml")
	xmlFile:open('r')
	local fileContents = xmlFile:read()
	local xml = xmlParser:ParseXmlText(fileContents)
	for index = 1, #xml:children() do
		xmlQuote=xml:children()[index]
		
		text=xmlQuote["@text"]
		
		influence={}
		influence[Opinions.getId("vegetarian")]=xmlQuote["@vegetarian"]
		influence[Opinions.getId("religious")]=xmlQuote["@religious"]
		influence[Opinions.getId("hopper")]=xmlQuote["@hopper"]
		influence[Opinions.getId("hipster")]=xmlQuote["@hipster"]
		
		table.insert(self.quotes, Quote(text, influence))
	end
end

function Level:setTimers(dt)
	if(self.survivalTimer>=self.maxSurvival)
	then
		self.survivalTimer=0
		self.survival=false
		self.choiceMade=false
		self:generateChoice()
	end
	
	if(self.choiceTimer>=self.maxChoice)
	then
		if(not self.choiceMade)
		then
			--no choice was made?
		end
		self.choiceTimer=0
		self.survival=true
	end
	
	if(self.survival)
	then
		self.survivalTimer=self.survivalTimer+dt
	else
		self.choiceTimer=self.choiceTimer+dt
	end
end

function Level:generateChoice()
	self.choice={}
	for i=1, self.choicesToGenerate
	do
		--seed?
		table.insert(self.choice, self.quotes[math.random(#self.quotes)])
	end
	--love.graphics.setCaption(math.random(#self.quotes) .. " " .. math.random(#self.quotes) .. " " .. math.random(#self.quotes) .. " " .. math.random(#self.quotes))
end

function Level:generateViewers()
	--generating a random amount of viewers with random opinions
	for i=1, math.random(self.minViewers, self.maxViewers)
	do
		opinions={}
		for i=1, #Opinions
		do
			rand=math.random()
			if(rand>=0.5)
			then
				opinions[i]=true
			else
				opinions[i]=false
			end
		end
		Viewer(self, opinions, {x=100,y=100})
	end
end

function Level:update(dt)
	self:setTimers(dt)
	
	if(not self.survival)
	then
		--made a choice
		if(not self.choiceMade and love.keyboard.isDown("return"))
		then
			for i=1, #self.entities
			do
				--automatically choosing first quote for now
				if self.entities[i].type == "Viewer" then
					self.entities[i]:calculateStatus(self.choice[1])
				end
			end
			selfChoiceMade=true
		end
	end
end

function Level:draw()
	for i = 1, #self.entities do
		self.entities[i]:draw()
	end
end