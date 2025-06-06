--optimize 2
--!nonstrict
local FastSignal = require(script.FastSignal)
local DefaultSettings = require(script.Settings)

local ShadowTable = {}
local Private = {}
ShadowTable.__index = ShadowTable

--[[Creates new ShadowTable class.]]
function ShadowTable.New(Data : {any}, Settings : {any})
	local self = setmetatable({}, ShadowTable)
	self.Settings = Settings or DefaultSettings
	
	Private[self] = {}
	Private[self].Signal = FastSignal.new()
	Private[self].Data = Data
	return self
end

--[[Sets property(key) in ShadowTable class's data.]]
function ShadowTable:SetProperty(PropertyName : string, NewValue : any)
	if Private[self].Data[PropertyName] then
		if Private[self].Data[PropertyName] ~= NewValue then
			Private[self].Data[PropertyName] = NewValue
			Private[self].Signal:Fire(PropertyName)
		end
	end
end

--[[Receives property(key) in ShadowTable class's data.]]
function ShadowTable:GetProperty(PropertyName : string) : any
	return Private[self].Data[PropertyName]
end

--[[Fires when there is a change in certain property of ShadowTable class's data.]]
function ShadowTable:OnChangedProperty(PropertyName : string, Callback : () -> ())
	Private[self].Signal:Connect(function(PropertyName2 : string)
		if PropertyName2 and PropertyName == PropertyName2 then
			Callback()
		end
	end)
end

--[[Fires when there is a change in ANY property of ShadowTable class's data.]]
function ShadowTable:OnAnyChangedProperty(Callback : () -> ())
	Private[self].Signal:Connect(Callback)
end

--[[Updates the data of the ShadowTable class with the new data.]]
function ShadowTable:UpdateTableData(NewTable : {any})
	Private[self].Data = NewTable
	Private[self].Signal:Fire()
end

--[[Removes ShadowTable class and disconnects all .Changed signals.]]
function ShadowTable:Remove()
	if Private[self].Signal then
		Private[self].Signal:DisconnectAll()
	end
	setmetatable(self, nil)
end

--[[Loads new settings into the ShadowTable class.]]
function ShadowTable:LoadSettings(Settings : {any})
	self.Settings = Settings or DefaultSettings
end

--[[Overwrites current settings and sets them to default.]]
function ShadowTable:ResetSettings()
	self.Settings = DefaultSettings
end

return ShadowTable
