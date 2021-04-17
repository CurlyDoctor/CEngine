-- Maid
-- Author: Quenty
-- Source: https://github.com/Quenty/NevermoreEngine/blob/version2/Modules/Shared/Events/Maid.lua
-- License: MIT (https://github.com/Quenty/NevermoreEngine/blob/version2/LICENSE.md)
-- Modified by scripting1st

--[[
	maid = Maid.new()
	maid:GiveTask(task)
		> task is an event connection, function, or instance/table with a 'Destroy' method
	maid:GivePromise(promise)
		> Give the maid a promise as a task, which will call 'promise:Cancel()' on cleanup
	
	maid:DoCleaning()
		> Alias for Destroy
	
	maid:Destroy()
		> Goes through each task & disconnects events, destroys instances, and calls functions
--]]


local Maid = {}
Maid.__index = Maid 




--- Returns a new Maid object
-- @constructor Maid.new()
-- @treturn Maid
function Maid.new()
	local self = setmetatable({
		_tasks = {};
	}, Maid)
	return self
end


--- Returns Maid[key] if not part of Maid metatable
-- @return Maid[key] value



--- Add a task to clean up
-- @usage
-- Maid[key] = (function)         Adds a task to perform
-- Maid[key] = (event connection) Manages an event connection
-- Maid[key] = (Maid)             Maids can act as an event connection, allowing a Maid to have other maids to clean up.
-- Maid[key] = (Object)           Maids can cleanup objects with a `Destroy` method
-- Maid[key] = nil                Removes a named task. If the task is an event, it is disconnected. If it is an object,
--                                it is destroyed.


--- Same as indexing, but uses an incremented number as a key.
-- @param task An item to clean
-- @treturn number taskId
function Maid:GiveTask(task)
	local Promise = self.Shared.Promise 
	assert(task, "Task cannot be false or nil")

	local taskId = (#self._tasks + 1)
	self._tasks[taskId] = task

	if (type(task) == "table" and (not task.Destroy) and (not Promise.is(task))) then
		warn("[Maid.GiveTask] - Gave table task without .Destroy\n\n" .. debug.traceback())
	end

	return taskId
end


function Maid:GivePromise(promise)
	local Promise = self.Shared.Promise
	assert(Promise.is(promise), "Expected promise")
	if (promise:getStatus() ~= Promise.Status.Started) then
		return promise
	end
	local newPromise = Promise.resolve(promise)
	local id = self:GiveTask(newPromise)
	newPromise:finally(function()
		self[id] = nil
	end)
	return newPromise
end


--- Cleans up all tasks.
-- @alias Destroy
function Maid:DoCleaning()
	local tasks = self._tasks
	local Promise = self.Shared.Promise

	-- Disconnect all events first as we know this is safe
	for index, task in pairs(tasks) do
		if (typeof(task) == "RBXScriptConnection") then
			tasks[index] = nil
			task:Disconnect()
		end
	end

	-- Clear out tasks table completely, even if clean up tasks add more tasks to the maid
	local index, task = next(tasks)
	while (task ~= nil) do
		tasks[index] = nil
		if (type(task) == "function") then
			task()
		elseif (typeof(task) == "RBXScriptConnection") then
			task:Disconnect()
		elseif (task.Destroy) then
			task:Destroy()
		elseif (Promise.is(task)) then
			task:cancel()
		end
		index, task = next(tasks)
	end
end



--- Alias for DoCleaning()
-- @function Destroy
Maid.Destroy = Maid.DoCleaning

return Maid