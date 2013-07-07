require "Level"
require "Quote"
require "Opinions"
require "entities/Viewer"
require "entities/Character"

local level = nil

function love.load()
	local name="Listen and learn"
	love.filesystem.setIdentity(name)
	love.graphics.setCaption(name)
	windowSize={width=1280, height=720}
	love.graphics.setMode(windowSize.width, windowSize.height, false, false, 0)
	level = Level(windowSize)
	background=love.graphics.newImage("assets/background.png")
	funkybynatur=love.audio.newSource("assets/funkybynatur.mp3")
	funkybynatur:setLooping(true)
	funkybynatur:play()
end

function love.update(dt)
	level:update(dt)
	if(level.gameFinished)
	then
		level=Level(windowSize)
	end
	--love.graphics.setCaption(#level.entities)
	--love.graphics.setCaption(level.survivalTimer .. " " .. level.choiceTimer .. " " .. tostring(level.survival))
end

function love.draw()
	love.graphics.draw(background)
	level:draw()
end