--optimize 2
--!strict
local FastSignal = require(script.FastSignal)

local ShadowTable = {}
local Private = {}
ShadowTable.__index = ShadowTable

--[[Creates new ShadowTable class.]]
function ShadowTable.New(Data : {any})
	local self = setmetatable({}, ShadowTable)
	
	Private[self] = {}
	Private[self].Signal = FastSignal.new()
	Private[self].Data = Data or {}
	return self
end

--[[Sets property(key) in ShadowTable class's data.]]
function ShadowTable:SetProperty(PropertyName : any, NewValue : any)
	if Private[self].Data[PropertyName] then
		if Private[self].Data[PropertyName] ~= NewValue then
			Private[self].Data[PropertyName] = NewValue
		end
		Private[self].Signal:Fire(PropertyName, NewValue)
	end
end

--[[Receives property(key) in ShadowTable class's data.]]
function ShadowTable:GetProperty(PropertyName : any) : any
	return Private[self].Data[PropertyName]
end

--[[Fires when there is a change in certain property of ShadowTable class's data.]]
function ShadowTable:OnChangedProperty(PropertyName : any, Callback : (NewValue : any) -> ())
	Private[self].Signal:Connect(function(PropertyName2 : any, NewValue : any)
		if PropertyName2 and PropertyName == PropertyName2 then
			Callback(NewValue)
		end
	end)
end

--[[Fires when there is a change in ANY property of ShadowTable class's data.]]
function ShadowTable:OnAnyChangedProperty(Callback : () -> ())
	Private[self].Signal:Connect(Callback)
end

--[[Updates the data of the ShadowTable class with the new data.]]
function ShadowTable:UpdateTableData(NewTable : {any})
	Private[self].Data = NewTable or {}
	Private[self].Signal:Fire()
end

--[[Removes ShadowTable class and disconnects all .Changed signals.]]
function ShadowTable:Remove()
	if Private[self].Signal then
		Private[self].Signal:DisconnectAll()
	end
	Private[self] = nil
	setmetatable(self :: any, nil)
end
return ShadowTable