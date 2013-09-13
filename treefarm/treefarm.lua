--[[
All my ComputerCraft related scripts and more!
Copyright (C) 2013  Clem2095

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]

local wood = 2			-- slot for wood sample
local saplings = 1	-- slot for saplings
local origin = true	-- we start from.. the begining, yes

local function placeSapling()
	turtle.select(saplings)
	turtle.place()
	return turtle.detect()
end

local function isWood()
	turtle.select(wood)
	if turtle.compare() then
		return true
	end
		
	return false
end

local function chop()
	while turtle.detect() do
		turtle.dig()
		turtle.digUp()
		turtle.up()
	end
	
	while not turtle.detectDown() do
		turtle.down()
	end
	
	print("Chopped the whole thing bro'")
end

local function plantOrChop()
	if not turtle.detect() then
		placeSapling()
	else
		if isWood() then
			chop()
			placeSapling()
		end
	end
end

-- suck items all around (just in case)
local function suck()
	turtle.suck()
	turtle.suckUp()
	turtle.suckDown()
end

-- count how much wood do we have (for treefarmon)
local function countWood()
	local w = 0
	for slot=2,16 do
		w = w + turtle.getItemCount(slot)
	end
	
	return w
end

-- if we cannot go further we've reach the end of the farm (except mobs?)
local function comeBack()
	if origin then
		origin = false
	else
		-- drop full stacks in item tesseract (or whatever is under the turtle)
		for slot=3,16 do
			if turtle.getItemSpace(slot) == 0 then
				print("drop slot's " .. slot .. " content")
				turtle.select(slot)
				turtle.dropDown(64)
			end
		end
	
		-- keep one wood for comparison
		if turtle.getItemSpace(wood) == 0 then
			turtle.select(wood)
			turtle.dropDown(63)
		end
	
	
		-- drop half the sapling we have if more than 50
		-- keep a 'small stock' of sapling as it should get restored
		local nbSaplings = turtle.getItemCount(saplings)
		if nbSaplings > 50 then
			turtle.select(16)
			turtle.dropDown(nbSaplings / 2)
		end

		-- calculate how long we recharge battery
		local wlen = 5
		local energy = turtle.getFuelLevel()
		
		if energy < 1000 then wlen = 10
		elseif energy < 700 then wlen = 20
		elseif energy < 200 then wlen = 35 end
		
		sleep(wlen)
		origin = true
	end
	
	turtle.turnLeft()
	turtle.turnLeft()
end

-- initialize rednet connection
print('Opening wireless connection!')
rednet.open('right')

while true do
	turtle.turnRight()
	plantOrChop()
	suck()
	turtle.turnLeft()
	turtle.turnLeft()
	plantOrChop()
	suck()
	turtle.turnRight()
	
	if not turtle.forward() then
		comeBack()
		if not turtle.forward() then
			-- TODO: manage that in treefarmon
			rednet.broadcast("Help! I'm stuck (>_<)")
		end
	end
	
	-- get inventory stats
	local nbWood = countWood()
	local energy = turtle.getFuelLevel()
	local saplings = turtle.getItemCount(saplings)
	
	-- broadcast stats for treefarmon
	rednet.broadcast('wood: ' .. nbWood)
	rednet.broadcast('energy: ' .. energy)
	rednet.broadcast('saplings: ' .. saplings)
end

-- close rednet connection
if rednet.isOpen('right') then
	print('closing connection!')
	rednet.close('right')
end
