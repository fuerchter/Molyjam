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

function Level:_init(windowSize)
	--how long the survival phase lasts (in seconds)
	self.maxSurvival=1
	self.survivalTimer=0
	
	--how long the choice phase lasts (in seconds)
	self.maxChoice=10
	self.choiceTimer=0
	
	self.survival=true
	self.choiceMade=false
	
	--general timer
	self.timer=0
	
	self.entities = {}
	
	self:loadQuotes()
	
	self.minViewers=5
	self.maxViewers=10
	
	self.windowSize=windowSize
	self.stageRect={x=0, y=0, width=251, height=self.windowSize.height-154}
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

function Level:getEntitiesByType(entType)
	local foundEntities = {}

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
	local foundEntities = {}

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

--gets all the quotes with their text and stats from the .xml file
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
		for i=1, #Opinions
		do
			influence[i]=xmlQuote["@" .. Opinions.getName(i)]
		end
		
		table.insert(self.quotes, Quote(text, influence))
	end
end

--increase the appropriate timer (survival or choice), generates choices once the choice phase starts
function Level:setTimers(dt)
	self.timer = self.timer + dt

	if(self.survivalTimer>=self.maxSurvival)
	then
		self.survivalTimer=0
		self.survival=false
		self.choiceMade=false
		self:generateChoices()
	end
	
	if(self.choiceTimer>=self.maxChoice)
	then
		if(not self.choiceMade)
		then
			for i=1, #self.entities do
				if self.entities[i].type == "Viewer" then
					self.entities[i]:calculateStatus(Quote("INVALID", {1,1,1,1}))
				end
			end
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

--randomly picks the choices a player has from self.quotes
function Level:generateChoices()
	self.choices={}
	
	--holds the indices in self.quotes of which quotes to display
	local choiceTable={}
	for i=1, 4
	do
		local choice
		local exists=true --holds whether the current generated number in choice already exists
		while(exists)
		do
			choice=math.random(#self.quotes)
			exists=false
			for i=1, #choiceTable
			do
				--the current number already exists
				if(choiceTable[i]==choice)
				then
					exists=true
					break
				end
			end
		end	
		table.insert(choiceTable, choice)
	end
	
	for i=1, #choiceTable
	do
		table.insert(self.choices, self.quotes[choiceTable[i]])
	end
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
		--Viewer size???
		local test_x = math.random(self.stageRect.width+27, self.windowSize.width-27)
		local test_y = math.random(42, self.stageRect.height-42)
		local pos = {x = test_x, y = test_y}
		if #self:getEntitiesInRange(pos, 50) == 0 then
			Viewer(self, opinions, pos)
		else
			i = i - 1
		end
	end
end

function Level:update(dt)
	self:setTimers(dt)
	
	if(not self.survival)
	then
		--player has to make a choice on which quote to say
		if(not self.choiceMade)
		then
			local choice=0
			if(love.keyboard.isDown("up"))
			then
				choice=1
			end
			if(love.keyboard.isDown("down"))
			then
				choice=2
			end
			if(love.keyboard.isDown("left"))
			then
				choice=3
			end
			if(love.keyboard.isDown("right"))
			then
				choice=4
			end
			
			--a choice has been made, calculate effect on viewers
			if(choice~=0)
			then
				for i=1, #self.entities
				do
					if self.entities[i].type == "Viewer" then
						self.entities[i]:calculateStatus(self.choices[choice])
					end
				end
				self.choiceMade=true
			end
		end
	end
	
	for i = 1, #self.entities do
		self.entities[i]:update(dt)
	end
end

function Level:drawChoices()
	for i=1, #self.choices
	do
		love.graphics.print(self.choices[i].text .. " " .. self.choices[i].influence[1] .. " " .. self.choices[i].influence[2] .. " " .. self.choices[i].influence[3] .. " " .. self.choices[i].influence[4], 0, self.stageRect.height+(i-1)*15)
	end
	
end

function Level:drawViewers()
	for i=1, #self.entities
	do
		if self.entities[i].type == "Viewer" then
			love.graphics.print(self.entities[i].status, 300, i*100)
			love.graphics.print(tostring(self.entities[i].opinions[1]), 300, i*100+15)
			love.graphics.print(tostring(self.entities[i].opinions[2]), 300, i*100+30)
			love.graphics.print(tostring(self.entities[i].opinions[3]), 300, i*100+45)
			love.graphics.print(tostring(self.entities[i].opinions[4]), 300, i*100+60)
		end
	end
end

function Level:draw()
	for i = 1, #self.entities do
		self.entities[i]:draw()
	end
	
	self:drawViewers()
	
	if(not self.survival)
	then
		self:drawChoices()
	end
end