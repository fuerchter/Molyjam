require "Level"
require "Opinions"

function love.load()
	level=Level()
end

function love.update(dt)
	level:update(dt)
	--love.graphics.setCaption(level.survivalTimer .. " " .. level.choiceTimer .. " " .. tostring(level.survival))
	love.graphics.setCaption(Opinions.getIdByName("hopper"))
end

function love.draw()

end