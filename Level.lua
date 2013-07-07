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
	self.maxSurvival=20
	self.survivalTimer=self.maxSurvival
	
	--how long the choice phase lasts (in seconds)
	self.maxChoice=10
	self.choiceTimer=0
	self.choiceTimerFloored=0
	self.choiceTimerFlooredPrevious=0
	self.choiceTimerSound=love.audio.newSource("assets/timer.wav", "static")
	self.noChoiceSound=love.audio.newSource("assets/buzzer.wav", "static")
	self.deathSound=love.audio.newSource("assets/death.wav", "static")
	
	--general timer
	self.timer=0
	
	self.survival=true
	self.choice=0
	self.choiceButtons = { [1] = "h", [2] = "j", [3] = "k", [4] = "l"}
	
	self.gameFinished = false
	
	self.highscore = 0
	
	self.saveFile = love.filesystem.newFile("highscore.txt")
	if not love.filesystem.isFile("highscore.txt") then
		self.saveFile:open("w")
		self.saveFile:write(0)
		self.saveFile:close()
	else
		self.saveFile:open("r")
		local contents, size = self.saveFile:read()
		if size > 0 then
			self.highscore = tonumber(contents)
		end
		self.saveFile:close()
	end
	
	self.entities = {}
	
	self:loadQuotes()
	
	self.minViewers=15
	self.maxViewers=20
	
	self.windowSize=windowSize
	self.stageRect={x=0, y=0, width=190, height=self.windowSize.height-112}
	self:generateViewers(self.minViewers, self.maxViewers)
	self.maxViewerTimer=15
	self.viewerTimer=0
	
	self.character=Character(self, {x=100,y=100})
end

function Level:registerEntity(entity)
	--fixes rendering of audience
	if entity.type == "Viewer" then
		for index = 1, #self.entities do
			if self.entities[index].type == "Viewer" then
				if self.entities[index].position.y < entity.position.y then
					table.insert(self.entities, index + 1, entity)
					return
				end
			end
		end
		table.insert(self.entities, entity)
	else
		table.insert(self.entities, entity)
	end
end

function Level:removeEntity(entity)

	--character has died, finish game
	if entity.type == "Character" then
		self.deathSound:play()
		self.deathSound:rewind()
		self:finishGame()
	end

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

function Level:getEntitiesByCollision(entity)
	local foundEntities = {}

	for i = 1, #self.entities do
		if self.entities[i].hitbox:doesOverlapWith(entity.hitbox) then
			table.insert(foundEntities, self.entities[i])
		end
	end
	
	return foundEntities
end

function Level:finishGame()
	self.gameFinished = true
	
	--save score
	if self.highscore < self.timer then
		self.saveFile:open("w")
		self.saveFile:write(self.timer)
		self.saveFile:close()
	end
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
		if(self.choice~=0)
		then
			for i=1, #self.entities
			do
				if self.entities[i].type == "Viewer" then
					self.entities[i]:calculateStatus(self.choices[self.choice])
				end
			end
		else
			love.audio.play(self.noChoiceSound)
			for i=1, #self.entities do
				if self.entities[i].type == "Viewer" then
					self.entities[i]:calculateStatus(Quote("INVALID", {1,1,1,1}))
				end
			end
		end
		self.choice=0
		self.choiceTimer=0
		self.choiceTimerFloored=0
		self.choiceTimerFlooredPrevious=0
		self.survival=true
	end
	
	if(self.survival)
	then
		self.survivalTimer=self.survivalTimer+dt
	else
		self.choiceTimer=self.choiceTimer+dt
		self.choiceTimerFloored=math.floor(self.choiceTimer)
		if(self.choiceTimerFloored>self.choiceTimerFlooredPrevious)
		then
			love.audio.play(self.choiceTimerSound)
			self.choiceTimerSound:rewind()
			self.choiceTimerFlooredPrevious=self.choiceTimerFloored
		end
	end
	
	self.viewerTimer=self.viewerTimer+dt
	if(self.viewerTimer>=self.maxViewerTimer)
	then
		self:generateViewers(5, 5)
		self.viewerTimer=0
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

function Level:generateViewers(minViewers, maxViewers)
	--generating a random amount of viewers with random opinions
	for i=1, math.random(minViewers, maxViewers)
	do
		opinions={[1] = false, [2] = false, [3] = false, [4] = false}
		
		local rand = math.random()
		
		if rand < 0.25 then
			opinions[1] = true
		elseif rand < 0.5 then
			opinions[2] = true
		elseif rand < 0.75 then
			opinions[3] = true
		else
			opinions[4] = true
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
	if self.gameFinished then
		return
	end

	self:setTimers(dt)
	
	if(not self.survival)
	then
		--player has to make a choice on which quote to say
		if(love.keyboard.isDown(self.choiceButtons[1]))
		then
			self.choice=1
		end
		if(love.keyboard.isDown(self.choiceButtons[2]))
		then
			self.choice=2
		end
		if(love.keyboard.isDown(self.choiceButtons[3]))
		then
			self.choice=3			
		end
		if(love.keyboard.isDown(self.choiceButtons[4]))
		then
			self.choice=4
		end
	end
	--love.graphics.setCaption(self.choice)
	
	for i = 1, #self.entities do
		if self.entities[i] ~= nil then
			self.entities[i]:update(dt)
		end
	end
end

function Level:drawChoices()
	for i=1, #self.choices
	do
		if(i==self.choice)
		then
			love.graphics.setColor(89, 63, 158, 255)
			love.graphics.setFont(love.graphics.newFont((self.windowSize.height - self.stageRect.height) / 4.5))
		else
			love.graphics.setFont(love.graphics.newFont((self.windowSize.height - self.stageRect.height) / 5))
			love.graphics.setColor(0, 0, 0, 255)
		end
		
		love.graphics.print(self.choiceButtons[i] .. ": " .. self.choices[i].text, 30, self.stageRect.height+(i-1)*((self.windowSize.height - self.stageRect.height) / 4))
		--love.graphics.print(self.choiceButtons[i] .. ": " .. self.choices[i].text .. " " .. self.choices[i].influence[1] .. " " .. self.choices[i].influence[2] .. " " .. self.choices[i].influence[3] .. " " .. self.choices[i].influence[4], 0, self.stageRect.height+(i-1)*15)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setFont(love.graphics.newFont((self.windowSize.height - self.stageRect.height) / 5))
	end
	
end

function Level:drawTimers()
	if(not self.survival)
	then
		love.graphics.setColor(89, 63, 158, 255)
		love.graphics.print(math.floor(self.maxChoice-self.choiceTimer) .. " seconds left. Pick a statement!", 850, self.stageRect.height+(self.windowSize.height - self.stageRect.height) / 4)
	end
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print(math.floor(self.timer) .. " seconds survived! Highscore: " .. math.floor(self.highscore), 850, self.stageRect.height)
	love.graphics.setColor(255, 255, 255, 255)
end

function Level:drawViewers()
	love.graphics.setColor(0, 0, 0, 255)
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
	love.graphics.setColor(255, 255, 255, 255)
end

function Level:drawDebug()
	self:drawViewers()

	for i = 1, #self.entities do
		if self.entities[i].type == "Bullet" or self.entities[i].type == "Character" then
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.rectangle("line", self.entities[i].hitbox.position.x, 
									self.entities[i].hitbox.position.y, 
									self.entities[i].hitbox.width,
									self.entities[i].hitbox.height)
			love.graphics.setColor(255, 255, 255, 255)
		end
	end
end

function Level:draw()
	for i = 1, #self.entities do
		self.entities[i]:draw()
	end
	
	--self:drawDebug()
	--self:drawViewers()
	
	if(not self.survival)
	then
		self:drawChoices()
	end
	self:drawTimers()
end