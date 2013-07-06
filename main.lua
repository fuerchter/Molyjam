require "Level"
require "Quote"
require "Opinions"
require "entities/Viewer"

function love.load()
	level=Level()
	
	opinions={}
	opinions[Opinions.getId("vegetarian")]=true
	opinions[Opinions.getId("religious")]=true
	opinions[Opinions.getId("hopper")]=false
	opinions[Opinions.getId("hipster")]=false
	viewer=Viewer(opinions)
	viewer:calculateStatus(level.quotes[1])
end

function love.update(dt)
	level:update(dt)
	--love.graphics.setCaption(viewer.status)
	--love.graphics.setCaption(level.survivalTimer .. " " .. level.choiceTimer .. " " .. tostring(level.survival))
end

function love.draw()

end