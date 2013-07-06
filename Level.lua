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
	
	self:loadQuotes()
	
	self.minViewers=5
	self.maxViewers=10
	self:generateViewers()
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
	self.viewers={}
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
		table.insert(self.viewers, Viewer(opinions))
	end
end

function Level:update(dt)
	self:setTimers(dt)
	
	if(not self.survival)
	then
		--made a choice
		if(not self.choiceMade and love.keyboard.isDown("return"))
		then
			for i=1, #self.viewers
			do
				--automatically choosing first quote for now
				self.viewers[i]:calculateStatus(self.choice[1])
			end
			selfChoiceMade=true
		end
	end
end

function Level:draw()
	
end