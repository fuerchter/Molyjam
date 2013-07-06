require "Level"
require "Quote"
require "Opinions"
require "entities/Viewer"

function love.load()
	level=Level()
end

function love.update(dt)
	level:update(dt)
	--love.graphics.setCaption(viewer.status)
	--love.graphics.setCaption(level.survivalTimer .. " " .. level.choiceTimer .. " " .. tostring(level.survival))
end

function love.draw()
	level:draw()
end