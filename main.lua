require "Level"
require "Quote"
require "Opinions"
require "entities/Viewer"

function love.load()
	level=Level()
	influence={}
	influence[Opinions.getId("vegetarian")]=1
	influence[Opinions.getId("religious")]=0
	influence[Opinions.getId("hopper")]=0
	influence[Opinions.getId("hipster")]=0
	quote=Quote("bla", influence)
	opinions={}
	opinions[Opinions.getId("vegetarian")]=true
	opinions[Opinions.getId("religious")]=true
	opinions[Opinions.getId("hopper")]=false
	opinions[Opinions.getId("hipster")]=false
	viewer=Viewer(opinions)
	viewer:calculateStatus(quote)
end

function love.update(dt)
	level:update(dt)
	love.graphics.setCaption(viewer.status)
end

function love.draw()

end