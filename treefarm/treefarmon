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

local monitor = peripheral.wrap('top')
term.redirect(monitor)

rednet.open('right')

local line = 1

local wood = nil
local energy = nil
local saplings = nil

local function printLevels()
	term.clear()
	term.setCursorPos(1,1)
	if wood ~= nil then term.write(wood) end
	term.setCursorPos(1, 2)
	if energy ~= nil then term.write(energy) end
	term.setCursorPos(1, 3)
	if saplings ~= nil then term.write(saplings) end
end

local function getMessage(msg)
	if string.find(msg, 'saplings') then
		saplings = msg
	elseif string.find(msg, 'wood') then
		wood = msg
	elseif string.find(msg, 'energy') then
		energy = msg
	end
end

while true do
	local id, msg, dst = rednet.receive()
	getMessage(msg)
	printLevels()
end

term.dispose()

if rednet.isOpen('right') then
	rednet.close('right')
end
