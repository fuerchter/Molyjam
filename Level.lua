require "Quote"

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
	self.maxSurvival=1
	self.survivalTimer=0
	
	self.maxChoice=1
	self.choiceTimer=0
	
	self.survival=true
	
	self.timer=0
	
	self:loadQuotes()
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
		self:generateChoice()
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

function Level:generateChoice()
	self.choice={}
	for i=1, 4
	do
		--seed?
		table.insert(self.choice, self.quotes[math.random(#self.quotes)])
	end
	--love.graphics.setCaption(math.random(#self.quotes) .. " " .. math.random(#self.quotes) .. " " .. math.random(#self.quotes) .. " " .. math.random(#self.quotes))
end

function Level:update(dt)
	self:setTimers(dt)
	if(survival==false)
	then
		--have player choose quote
	end
end

function Level:draw()
	
end