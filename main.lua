require "Level"

function love.load()
	level=Level()
end

function love.update(dt)
	level:update(dt)
	love.graphics.setCaption(level.survivalTimer .. " " .. level.choiceTimer .. " " .. tostring(level.survival))
end

function love.draw()

end