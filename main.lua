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
	local viewer = Viewer(level, {true, true, true, true}, {x=500,y=500})
	viewer:calculateStatus(Quote("",{5,5,5,5}))
	local viewer2 = Viewer(level, {true, true, true, true}, {x=700,y=500})
	viewer2:calculateStatus(Quote("",{5,5,5,5}))
end

function love.update(dt)
	level:update(dt)
	love.graphics.setCaption(#level.entities)
	--love.graphics.setCaption(level.survivalTimer .. " " .. level.choiceTimer .. " " .. tostring(level.survival))
end

function love.draw()
	level:draw()
end