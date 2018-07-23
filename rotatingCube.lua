Vector = {}

function Vector:new(xV,yV,zV)
	local newObj = {x = xV, y = yV, z = zV}
	self.__index = self
	return setmetatable(newObj, self)
end

function Vector:rotate(xR,yR,zR)
	--degrees to radians, because fuck working with radians
	xR = math.rad(xR)
	yR = math.rad(yR)
	zR = math.rad(zR)
	
	--set some temp values
	local tempX = self.x
	local tempY = self.y
	local tempZ = self.z
	
	--rotate around Z-axis
	self.x = ((tempX * math.cos(zR)) - (tempY * math.sin(zR)))
	self.y = ((tempX * math.sin(zR)) + (tempY * math.cos(zR)))
	
	--reset temp values
	tempX = self.x
	tempY = self.y
	tempZ = self.z
	
	--rotate around Y-axis
	self.x = ((tempX * math.cos(yR)) + (tempZ * math.sin(yR)))
	self.z = ((-1 * tempX * math.sin(yR)) + (tempZ * math.cos(yR)))
	
	--reset temp value
	tempX = self.x
	tempY = self.y
	tempZ = self.z
	
	--rotate around X-axis
	self.y = ((tempY * math.cos(xR)) - (tempZ * math.sin(xR)))
	self.z = ((tempY * math.sin(xR)) + (tempZ * math.cos(xR)))
	
end



Cube = {}

function Cube:new(scale)
	local v1 = Vector:new( scale, scale, scale)
	local v2 = Vector:new(-scale, scale, scale)
	local v3 = Vector:new(-scale,-scale, scale)
	local v4 = Vector:new( scale,-scale, scale)
	local v5 = Vector:new( scale, scale,-scale)
	local v6 = Vector:new(-scale, scale,-scale)
	local v7 = Vector:new( scale,-scale,-scale)
	local v8 = Vector:new(-scale,-scale,-scale)
	
	local nodeArr = {v1,v2,v3,v4,v5,v6,v7,v8}
	
	local e1  = {v1,v2}
	local e2  = {v1,v5}
	local e3  = {v5,v6}
	local e4  = {v2,v6}
	local e5  = {v1,v4}
	local e6  = {v5,v7}
	local e7  = {v6,v8}
	local e8  = {v2,v3}
	local e9  = {v3,v4}
	local e10 = {v4,v7}
	local e11 = {v7,v8}
	local e12 = {v3,v8}
	
	local edgeArr = {e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12}
	
	local newObj = {nodes = nodeArr, edges = edgeArr}
	
	self.__index = self
	return setmetatable(newObj, self)
end

function Cube:rotate(xR,yR,zR)
	for i = 1, #self.nodes do
		self.nodes[i]:rotate(xR,yR,zR)
	end
end



--small helper function to go from graphed space to buffer space
function toScrn(n)
	return n + 20
end

--small helper function because Lua doesn't have a sign function???
function sign(n)
	return (n / math.abs(n))
end



--buffer to write to
buffer = {}

function clear()
	for j = 1,40 do
		buffer[j] = {}
		
		for i = 1, 40 do
			buffer[j][i] = " "
		end
	end
end

function draw()
	for y = 1, 40 do
		local str = ""
		
		for x = 1, 40 do
			str = str .. buffer[y][x]
		end
		
		print(str)
	end
end

--uses simple DDA, courtesy of Wikipedia
function addLine(vert1,vert2)
	local x1 = toScrn(vert1.x)
	local y1 = toScrn(vert1.y)
	local x2 = toScrn(vert2.x)
	local y2 = toScrn(vert2.y)
	
	local deltaX = x2 - x1
	local deltaY = y2 - y1
	
	local step = 0.0
	
	if(math.abs(deltaX) >= math.abs(deltaY)) then
		step = math.abs(deltaX)
	else
		step = math.abs(deltaY)
	end
	
	deltaX = deltaX / step
	deltaY = deltaY / step
	
	local x = x1
	local y = y1
	local inc = 1
	
	while (inc <= step) do
		buffer[math.floor(y)][math.floor(x)] = "#"
		x = x + deltaX
		y = y + deltaY
		inc = inc + 1
	end
end



c = Cube:new(10.0)

c:rotate(20,20,20)

while true do
	os.execute("cls")
	clear()
	
	c:rotate(0,15,0)
	
	for i = 1, #c.edges do
		addLine(c.edges[i][1], c.edges[i][2])
	end
	
	draw()
	
	io.read()
end