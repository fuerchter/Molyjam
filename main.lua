require "Level"
require "Quote"
require "Opinions"
require "entities/Viewer"
require "entities/Character"

local level = nil

function love.load()
	love.graphics.setMode(1280, 720, false, false, 0)
	level = Level()
	Character(level, {x=100,y=100})
end

function love.update(dt)
	level:update(dt)
	love.graphics.setCaption(#level.entities)
	--love.graphics.setCaption(level.survivalTimer .. " " .. level.choiceTimer .. " " .. tostring(level.survival))
end

function love.draw()
	level:draw()
end