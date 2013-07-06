require "../Entity"
require "../Opinions"

Viewer = {}
Viewer.__index = Viewer

setmetatable(Viewer, {
	__index = Entity,
	__call = function (cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
})

function Viewer:_init(opinions)
	Entity._init(self, "Viewer")
	
	self.statusList={}
	self.statusList[1]="happy"
	self.statusList[2]="pissed"
	self.statusList[3]="amok"
	
	self.status=1

	self.opinions=opinions
	--[[self.opinions={}
	self.opinions[1]=true
	self.opinions[2]=true
	self.opinions[3]=false
	self.opinions[4]=false]]
end

function Viewer:calculateStatus(quote)	
	for index = 1, #self.opinions do
		if(self.opinions[index] == true)
		then
			self.status=self.status+quote.influence[index]
		end
	end
	
	if(self.status<1)
	then
		self.status=1
	elseif(self.status>3)
	then
		self.status=3
	end
end

function Viewer:update(dt)

end

function Viewer:draw()

end