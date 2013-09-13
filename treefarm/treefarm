#!/usr/bin/env lua
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

local saplings = 16
local wood = 15

local ret = false
local nbones = 20

local function placeSapling()
	turtle.select(saplings)
	turtle.place()
	return turtle.detect()
end

local function fertilize(nb)
	turtle.select(bonemeal)
	for c=1,nb do
		turtle.place()
	end
end

local function isWood()
	turtle.select(wood)
	if turtle.compare() then
		print('it\'s wood!')
		return true
	else
		print('nope it\'s sapling ;\'(')
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
	
	print('Chopped the whole thing bro\'')
end

local function plantOrChop()
	if not turtle.detect() then
		local success = placeSapling()
	else
		if isWood() then
			chop()
			placeSapling()
		end
	end
end

local function suck()
	turtle.suck()
	turtle.suckUp()
	turtle.suckDown()
end

local function countWood()
	local w = 0
	for slot=1,15 do
		w = w + turtle.getItemCount(slot)
	end
	
	return w
end

local function comeBack()
	for slot=1,14 do
		if turtle.getItemSpace(slot) == 0 then
			print("drop slot's " .. slot .. " content")
			turtle.select(slot)
			turtle.dropDown(64)
		end
	end
	
	if turtle.getItemSpace(15) == 0 then
		turtle.select(15)
		turtle.dropDown(63)
	end
	
	turtle.turnLeft()
	turtle.turnLeft()
end

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
			rednet.broadcast("Help! I'm stuck (>_<)")
		end
	end
	
	local nbWood = countWood()
	local energy = turtle.getFuelLevel()
	local saplings = turtle.getItemCount(16)
	
	rednet.broadcast('wood: ' .. nbWood)
	rednet.broadcast('energy: ' .. energy)
	rednet.broadcast('saplings: ' .. saplings)
end

if rednet.isOpen('right') then
	print('closing connection!')
	rednet.close('right')
end
