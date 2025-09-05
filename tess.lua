local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local selectedTheme = "Default"
local Window = Rayfield:CreateWindow({
   Name = "99 Nights In The Forest - Script By AbilBGR",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "99 Nights In The Forest",
   LoadingSubtitle = "Script By AbilBGR",
   Theme = selectedTheme, -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "saver", -- Create a custom folder for your hub/game
      FileName = "K"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})
local PlayerTab = Window:CreateTab("Player")
local GameTab = Window:CreateTab("Game")
local EspTab = Window:CreateTab("Esp")
local BringItemTab = Window:CreateTab("Bring Item")
local DiscordTab = Window:CreateTab("Discord")
local SettingsTab = Window:CreateTab("Settings")
local ActiveEspItems,ActiveDistanceEsp,ActiveEspEnemy,ActiveEspChildren,ActiveEspPeltTrader,AlrActivatedFlyPC,ActivateFly,ActiveNoCooldownPrompt = false,false,false,false,false,false,false,false

Rayfield:Notify({
   Title = "Cheat Version",
   Content = "V.0.3",
   Duration = 2.5,
   Image = "rewind",
})


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local IYMouse = Players.LocalPlayer:GetMouse()
local FLYING = false
local QEfly = true
local iyflyspeed = 1
local vehicleflyspeed = 1

local function sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until IYMouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.CFrame = T.CFrame
		BV.Velocity = Vector3.new(0, 0, 0)
		BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.Velocity = Vector3.new(0, 0, 0)
				end
				BG.CFrame = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

local function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local velocityHandlerName = "BodyVelocity"
local gyroHandlerName = "BodyGyro"
local mfly1
local mfly2

local function UnMobileFly()
	pcall(function()
		FLYING = false
		local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		root:FindFirstChild(velocityHandlerName):Destroy()
		root:FindFirstChild(gyroHandlerName):Destroy()
		Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
		mfly1:Disconnect()
		mfly2:Disconnect()
	end)
end

local function MobileFly()
	UnMobileFly()
	FLYING = true

	local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local camera = workspace.CurrentCamera
	local v3none = Vector3.new()
	local v3zero = Vector3.new(0, 0, 0)
	local v3inf = Vector3.new(9e9, 9e9, 9e9)

	local controlModule = require(Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.Parent = root
	bv.MaxForce = v3zero
	bv.Velocity = v3zero

	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.Parent = root
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50

	mfly1 = Players.LocalPlayer.CharacterAdded:Connect(function()
		local bv = Instance.new("BodyVelocity")
		bv.Name = velocityHandlerName
		bv.Parent = root
		bv.MaxForce = v3zero
		bv.Velocity = v3zero

		local bg = Instance.new("BodyGyro")
		bg.Name = gyroHandlerName
		bg.Parent = root
		bg.MaxTorque = v3inf
		bg.P = 1000
		bg.D = 50
	end)

	mfly2 = RunService.RenderStepped:Connect(function()
		root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		camera = workspace.CurrentCamera
		if Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
			local humanoid = Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
			local VelocityHandler = root:FindFirstChild(velocityHandlerName)
			local GyroHandler = root:FindFirstChild(gyroHandlerName)

			VelocityHandler.MaxForce = v3inf
			GyroHandler.MaxTorque = v3inf
			humanoid.PlatformStand = true
			GyroHandler.CFrame = camera.CoordinateFrame
			VelocityHandler.Velocity = v3none

			local direction = controlModule:GetMoveVector()
			if direction.X > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((iyflyspeed) * 50))
			end
			if direction.X < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((iyflyspeed) * 50))
			end
			if direction.Z > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((iyflyspeed) * 50))
			end
			if direction.Z < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((iyflyspeed) * 50))
			end
		end
	end)
end

local function CreateEsp(Char, Color, Text,Parent,number)
	if not Char then return end
	if Char:FindFirstChild("ESP") and Char:FindFirstChildOfClass("Highlight") then return end
	local highlight = Char:FindFirstChildOfClass("Highlight") or Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
highlight.Adornee = Char
highlight.FillColor = Color
highlight.FillTransparency = 1
highlight.OutlineColor = Color
highlight.OutlineTransparency = 0
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Enabled = true
	highlight.Parent = Char

	
	local billboard = Char:FindFirstChild("ESP") or Instance.new("BillboardGui")
	billboard.Name = "ESP"
	billboard.Size = UDim2.new(0, 50, 0, 25)
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, number, 0)
	billboard.Adornee = Parent
	billboard.Enabled = true
	billboard.Parent = Parent

	
	local label = billboard:FindFirstChildOfClass("TextLabel") or Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = Text
	label.TextColor3 = Color
	label.TextScaled = true
	label.Parent = billboard

	task.spawn(function()
		local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

while highlight and billboard and Parent and Parent.Parent do
	local cameraPosition = Camera and Camera.CFrame.Position
	if cameraPosition and Parent and Parent:IsA("BasePart") then
	local distance = (cameraPosition - Parent.Position).Magnitude
				task.spawn(function()
if ActiveDistanceEsp then
label.Text = Text.." ("..math.floor(distance + 0.5).." m)"
else
label.Text = Text
end
end)

	end

	RunService.Heartbeat:Wait()
end

	end)
end

local function KeepEsp(Char,Parent)
	if Char and Char:FindFirstChildOfClass("Highlight") and Parent:FindFirstChildOfClass("BillboardGui") then
		Char:FindFirstChildOfClass("Highlight"):Destroy()
		Parent:FindFirstChildOfClass("BillboardGui"):Destroy()
	end
end

local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    else
        warn("setclipboard is not supported in this environment.")
    end
end
local DiscordLink = DiscordTab:CreateButton({
   Name = "Discord Link",
   Callback = function()
copyToClipboard("https://discord.gg/E2TqYRsRP4")
end,
})
local PlayerFlySpeedSlider = PlayerTab:CreateSlider({
   Name = "Fly Speed(Recommended to put 1 or below 5!)",
   Range = {0, 10},
   Increment = 0.1,
   Suffix = "Fly Speed",
   CurrentValue = 1,
   Flag = "Slider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
CurrentValue = Value
iyflyspeed = Value
end,  iyflyspeed = CurrentValue,
})

local PlayerFlyToggle = PlayerTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "ButtonFly", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActivateFly = Value 
task.spawn(function()
if not FLYING and ActivateFly then
			if UserInputService.TouchEnabled then
				MobileFly()
			else
task.spawn(function()
if not AlrActivatedFlyPC then 
AlrActivatedFlyPC = true
Rayfield:Notify({
   Title = "Fly",
   Content = "When you enable to fly you can press F to fly/unfly (it won't disable the button!)",
   Duration = 5,
   Image = "rewind",
})
end
end)
				NOFLY()
				wait()
				sFLY()
			end
		elseif FLYING and not ActivateFly then
			if UserInputService.TouchEnabled then
				UnMobileFly()
			else
				NOFLY()
			end
		end
end)
end,
})
local EspItemsToggle = EspTab:CreateToggle({
   Name = "Items Esp",
   CurrentValue = false,
   Flag = "EspItems",
   Callback = function(Value)
  ActiveEspItems = Value 
task.spawn(function()
while ActiveEspItems do 
task.spawn(function()
 for _,Obj in pairs(Game.Workspace.Items:GetChildren()) do 
if Obj:isA("Model") and Obj.PrimaryPart and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
CreateEsp(Obj,Color3.fromRGB(255,255,0),Obj.Name,Obj.PrimaryPart) 
end 
end
end)
task.wait(0.1)
end task.spawn(function()
 for _,Obj in pairs(Game.Workspace.Items:GetChildren()) do 
if Obj:isA("Model") and Obj.PrimaryPart and  Obj:FindFirstChildOfClass("Highlight") and Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
KeepEsp(Obj,Obj.PrimaryPart)
end 
end
end)
end)
end,
})
local EspEnemyToggle = EspTab:CreateToggle({
   Name = "Enemy Esp",
   CurrentValue = false,
   Flag = "EspEnemy",
   Callback = function(Value)
  ActiveEspEnemy = Value 
task.spawn(function()
while ActiveEspEnemy do 
task.spawn(function()
 for _,Obj in pairs(Game.Workspace.Characters:GetChildren()) do 
if Obj:isA("Model") and Obj.PrimaryPart and (Obj.Name ~= "Lost Child" and Obj.Name ~= "Lost Child2" and Obj.Name ~= "Lost Child3" and Obj.Name ~= "Lost Child4" and Obj.Name ~= "Pelt Trader") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
CreateEsp(Obj,Color3.fromRGB(255,0,0),Obj.Name,Obj.PrimaryPart) 
end 
end
end)
task.wait(0.1)
end task.spawn(function()
 for _,Obj in pairs(Game.Workspace.Characters:GetChildren()) do 
if Obj:isA("Model") and Obj.PrimaryPart and (Obj.Name ~= "Lost Child" and Obj.Name ~= "Lost Child2" and Obj.Name ~= "Lost Child3" and Obj.Name ~= "Lost Child4" and Obj.Name ~= "Pelt Trader") and Obj:FindFirstChildOfClass("Highlight") and Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
KeepEsp(Obj,Obj.PrimaryPart)
end 
end
end)
end)
end,
})
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.F then
		if not FLYING and ActivateFly then
			if UserInputService.TouchEnabled then
				MobileFly()
			else
				NOFLY()
				wait()
				sFLY()
			end
		elseif FLYING and ActivateFly then
			if UserInputService.TouchEnabled then
				UnMobileFly()
			else
				NOFLY()
			end
		end
	end
end)

local EspChildrensToggle = EspTab:CreateToggle({
   Name = "Childrens Esp",
   CurrentValue = false,
   Flag = "EspChildrens",
   Callback = function(Value)
  ActiveEspChildren = Value 
task.spawn(function()
while ActiveEspChildren do 
task.spawn(function()
 for _,Obj in pairs(Game.Workspace.Characters:GetChildren()) do 
if Obj:isA("Model") and Obj.PrimaryPart and (Obj.Name == "Lost Child" or Obj.Name == "Lost Child2" or Obj.Name == "Lost Child3" or Obj.Name == "Lost Child4") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
CreateEsp(Obj,Color3.fromRGB(0,255,0),Obj.Name,Obj.PrimaryPart) 
end 
end
end)
task.wait(0.1)
end task.spawn(function()
 for _,Obj in pairs(Game.Workspace.Characters:GetChildren()) do 
if Obj:isA("Model") and Obj.PrimaryPart and (Obj.Name == "Lost Child" or Obj.Name == "Lost Child2" or Obj.Name == "Lost Child3" or Obj.Name == "Lost Child4") and Obj:FindFirstChildOfClass("Highlight") and Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
KeepEsp(Obj,Obj.PrimaryPart)
end 
end
end)
end)
end,
})
local EspPeltTraderToggle = EspTab:CreateToggle({
   Name = "Pelt Trader Esp",
   CurrentValue = false,
   Flag = "EspPeltTrader",
   Callback = function(Value)
  ActiveEspPeltTrader = Value 
task.spawn(function()
while ActiveEspPeltTrader do 
task.spawn(function()
 for _,Obj in pairs(Game.Workspace.Characters:GetChildren()) do 
if Obj:isA("Model") and Obj.PrimaryPart and Obj.Name == "Pelt Trader" and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
CreateEsp(Obj,Color3.fromRGB(0,255,255),Obj.Name,Obj.PrimaryPart) 
end 
end
end)
task.wait(0.1)
end task.spawn(function()
 for _,Obj in pairs(Game.Workspace.Characters:GetChildren()) do 
if Obj:isA("Model") and Obj.PrimaryPart and Obj.Name == "Pelt Trader" and Obj:FindFirstChildOfClass("Highlight") and Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
KeepEsp(Obj,Obj.PrimaryPart)
end 
end
end)
end)
end,
})
-- Target items with desired quantities and CATEGORY
local targetItems = {
    ["Log"] = {quantity = 10, category = "Material"},
    ["Coal"] = {quantity = 15, category = "Material"},
    ["Fuel"] = {quantity = 5, category = "Consumable"},
    ["Berry"] = {quantity = 15, category = "Food"},
    ["Alien Chest"] = {quantity = 2, category = "Container"},
    ["Bolt"] = {quantity = 20, category = "Material"},
    ["Coin Stack"] = {quantity = -1, category = "Currency"},
    ["Fuel Canister"] = {quantity = 8, category = "Consumable"},
    ["Item Chest"] = {quantity = 3, category = "Container"},
    ["Laser Fence Blueprint"] = {quantity = 1, category = "Blueprint"},
    ["Old Flashlight"] = {quantity = 2, category = "Tool"},
    ["Old Radio"] = {quantity = 1, category = "Tool"},
    ["Revolver Ammo"] = {quantity = 50, category = "Ammo"},
    ["Rifle Ammo"] = {quantity = 100, category = "Ammo"},
    ["Sheet Metal"] = {quantity = 25, category = "Material"},
    ["UFO Component"] = {quantity = 5, category = "Component"},
    ["UFO Scrap"] = {quantity = 15, category = "Component"},
    ["Old Car Engine"] = {quantity = 1, category = "Vehicle Part"},
    ["Rifle"] = {quantity = 1, category = "Weapon"},
    ["Seed Box"] = {quantity = 5, category = "Farming"},
    ["Steak"] = {quantity = 10, category = "Food"},
    ["Strong Flashlight"] = {quantity = 1, category = "Tool"},
    ["Stronghold Diamond Chest"] = {quantity = 1, category = "Container"},
    ["Tyre"] = {quantity = 4, category = "Vehicle Part"},
    ["Washing Machine"] = {quantity = 1, category = "Furniture"},
    ["Wolf Corpse"] = {quantity = 3, category = "Resource"},
    ["Wolf Pelt"] = {quantity = 5, category = "Resource"},
    ["Alpha Wolf Corpse"] = {quantity = 1, category = "Resource"},
    ["Anvil Back"] = {quantity = 1, category = "Crafting"},
    ["Anvil Base"] = {quantity = 1, category = "Crafting"},
    ["Anvil Front"] = {quantity = 1, category = "Crafting"},
    ["Apple"] = {quantity = 10, category = "Food"},
    ["Bandage"] = {quantity = 5, category = "Medical"},
    ["Broken Microwave"] = {quantity = 1, category = "Furniture"},
    ["Cake"] = {quantity = 1, category = "Food"},
    ["Chair"] = {quantity = 2, category = "Furniture"},
    ["Leather Body"] = {quantity = 1, category = "Armor"},
    ["Medkit"] = {quantity = 3, category = "Medical"},
    ["Morsel"] = {quantity = 10, category = "Food"},
    ["Notice"] = {quantity = 1, category = "Miscellaneous"},
    ["Oil Barrel"] = {quantity = 2, category = "Container"},
}

-- Add Item Chest1 to Item Chest20 with a "Container" category
for i = 1, 20 do
    targetItems["Item Chest" .. i] = {quantity = 1, category = "Container"}
end

-- Define categories for easy iteration and UI creation
local categories = {"All", "Food", "Material", "Container", "Tool", "Weapon"}

-- How often the script can be run (in seconds)
local COOLDOWN = 2

--// ====================================== \\--

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Variables
local canGrab = true
local canScan = true
local canDiscover = true
local collectedItems = {}
local availableItems = {}
local discoveredItems = {}
local currentCategory = "All"

-- Wait for PlayerGui to be available
local playerGui = Player:WaitForChild("PlayerGui")

-- ============== MODERN iOS THEME GUI ============== 
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "iOSItemGrabber"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Container (iOS-style card)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 350)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(242, 242, 247) -- iOS light gray
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14) -- iOS rounded corners
corner.Parent = mainFrame

-- Shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.88
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Parent = mainFrame
shadow.ZIndex = -1

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = Color3.fromRGB(242, 242, 247)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1, 0, 0.6, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.SourceSansSemibold
title.Text = "99 Nights - ITEM GRABBER"
title.TextSize = 16
title.TextYAlignment = Enum.TextYAlignment.Bottom

local subtitle = Instance.new("TextLabel")
subtitle.Parent = header
subtitle.Size = UDim2.new(1, 0, 0.4, 0)
subtitle.Position = UDim2.new(0, 0, 0.6, 0)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(120, 120, 128)
subtitle.Font = Enum.Font.SourceSans
subtitle.Text = "Collect nearby items"
subtitle.TextSize = 12
subtitle.TextYAlignment = Enum.TextYAlignment.Top

-- Tab Bar (iOS-style segmented control)
local tabContainer = Instance.new("Frame")
tabContainer.Parent = mainFrame
tabContainer.Size = UDim2.new(1, -20, 0, 28)
tabContainer.Position = UDim2.new(0, 10, 0, 50)
tabContainer.BackgroundColor3 = Color3.fromRGB(229, 229, 234)
tabContainer.BorderSizePixel = 0

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(1, 0)
tabCorner.Parent = tabContainer

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.Parent = tabContainer
tabListLayout.FillDirection = Enum.FillDirection.Horizontal
tabListLayout.Padding = UDim.new(0, 1)

-- Status Bar
local statusBar = Instance.new("Frame")
statusBar.Parent = mainFrame
statusBar.Size = UDim2.new(1, -20, 0, 20)
statusBar.Position = UDim2.new(0, 10, 0, 130)
statusBar.BackgroundTransparency = 1

local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = statusBar
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(120, 120, 128)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Text = "Ready to scan"
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Item List (iOS-style table view)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = mainFrame
scrollFrame.Size = UDim2.new(1, -10, 1, -150)
scrollFrame.Position = UDim2.new(0, 5, 0, 150)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 205)
scrollFrame.BorderSizePixel = 0
scrollFrame.BottomImage = ""
scrollFrame.MidImage = ""
scrollFrame.TopImage = ""

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.Padding = UDim.new(0, 2)

-- ============== YOUR ORIGINAL FUNCTIONS ==============

-- iOS Style Button Creator
local function createiOSButton(icon, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 36, 0, 36)
    button.BackgroundColor3 = color
    button.Text = icon
    button.TextSize = 18
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    -- Button animation
    button.MouseButton1Down:Connect(function()
        button.Size = UDim2.new(0, 34, 0, 34)
    end)
    
    button.MouseButton1Up:Connect(function()
        button.Size = UDim2.new(0, 36, 0, 36)
    end)
    
    return button
end

-- Forward declaration for updateItemDisplay
local updateItemDisplay

-- Function to discover new items in workspace
local function discoverNewItems()
    if not canDiscover then return end
    canDiscover = false
    
    discoveredItems = {}
    local newItemsFound = 0
    
    statusLabel.Text = "ðŸ” Discovering new items..."
    
    -- Scan workspace for any items not in our target list
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("BasePart") or item:IsA("Model") then
            local itemName = item.Name
            -- Skip if it's already in our target list or if it's a common non-item object
            if not targetItems[itemName] and not discoveredItems[itemName] then
                -- Filter out common game objects that aren't items
                local skipNames = {
                    "Baseplate", "SpawnLocation", "Camera", "Lighting", "Terrain",
                    "StarterGui", "StarterPack", "StarterPlayer", "ReplicatedStorage",
                    "ServerStorage", "Teams", "Workspace", "Players", "Part", "Block",
                    "Wedge", "CornerWedge", "Cylinder", "Ball", "Seat", "VehicleSeat",
                    "TrussPart", "WedgePart", "CornerWedgePart", "Model", "Folder",
                    "Configuration", "IntValue", "StringValue", "BoolValue", "NumberValue"
                }
                
                local shouldSkip = false
                for _, skipName in pairs(skipNames) do
                    if itemName == skipName or itemName:find("Part") or itemName:find("Block") then
                        shouldSkip = true
                        break
                    end
                end
                
                if not shouldSkip and itemName ~= "" and #itemName > 1 then
                    discoveredItems[itemName] = (discoveredItems[itemName] or 0) + 1
                    newItemsFound = newItemsFound + 1
                end
            end
        end
    end
    
    if newItemsFound > 0 then
        statusLabel.Text = "ðŸ†• Found " .. newItemsFound .. " new item types!"
        -- Add discovered items to available items for display
        for itemName, count in pairs(discoveredItems) do
            if not targetItems[itemName] then -- Only add if truly new
                targetItems[itemName] = {quantity = 1, category = "Miscellaneous"}
            end
            availableItems[itemName] = count
        end
        updateItemDisplay()
    else
        statusLabel.Text = "âœ… No new items found."
    end
    
    task.spawn(function()
        task.wait(1)
        canDiscover = true
    end)
end

-- Function to bring specific item to player
local function bringSpecificItem(itemName)
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        statusLabel.Text = "âŒ Character not found!"
        return
    end

    local targetPosition = character.HumanoidRootPart.CFrame
    local itemsFound = 0
    local itemsMoved = 0
    local itemData = targetItems[itemName] or {quantity = 1}
    local targetCount = itemData.quantity
    local collectedCount = 0
    
    statusLabel.Text = "ðŸŽ¯ Collecting " .. itemName .. "..."
    
    -- Search through workspace for specific item
    for _, item in pairs(workspace:GetDescendants()) do
        if item.Name == itemName then
            -- Check if we need more of this item
            if targetCount == -1 or collectedCount < targetCount then
                itemsFound = itemsFound + 1
                collectedCount = collectedCount + 1
                
                local success = false
                
                -- Handle different item types
                if item:IsA("BasePart") then
                    if item.Anchored then
                        item.Anchored = false
                    end
                    item.CFrame = targetPosition * CFrame.new(math.random(-3, 3), 2, math.random(-3, 3))
                    success = true
                elseif item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChildOfClass("BasePart")
                    if primaryPart then
                        if primaryPart.Anchored then
                            primaryPart.Anchored = false
                        end
                        if item.PrimaryPart then
                            item:SetPrimaryPartCFrame(targetPosition * CFrame.new(math.random(-3, 3), 2, math.random(-3, 3)))
                        else
                            primaryPart.CFrame = targetPosition * CFrame.new(math.random(-3, 3), 2, math.random(-3, 3))
                        end
                        success = true
                    end
                end
                
                if success then
                    itemsMoved = itemsMoved + 1
                end
                
                -- 
})
local ValueSpeed = 16
local OldSpeed = Game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
local PlayerSpeedSlider = PlayerTab:CreateSlider({
   Name = "Player Speed(Recommended to put it below 500!)",
   Range = {0, 1000},
   Increment = 1,
   Suffix = "Speeds",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
CurrentValue = Value
ValueSpeed = Value
end,  ValueSpeed = CurrentValue,
})

local PlayerActiveModifyingSpeedToggle = PlayerTab:CreateToggle({
   Name = "Active Modifying Player Speed",
   CurrentValue = false,
   Flag = "ButtonSpeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActiveSpeedBoost = Value 
task.spawn(function()
while ActiveSpeedBoost do 
task.spawn(function()
Game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = ValueSpeed 
Game.Players.LocalPlayer.Character.Humanoid:SetAttribute("BaseSpeed",ValueSpeed)
end)
task.wait(0.1)
end
Game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = OldSpeed 
Game.Players.LocalPlayer.Character.Humanoid:SetAttribute("BaseSpeed",OldSpeed)
end)
end,
})
local NoCooldownpromptToggle = playerTab:CreateToggle({
   Name = "Instant Interact",
   CurrentValue = false,
   Flag = "NoCooldownPrompt1", 
   Callback = function(Value)
ActiveNoCooldownPrompt = Value 
task.spawn(function()  
while ActiveNoCooldownPrompt do
for _,Assets in pairs(Game.Workspace:GetDescendants()) do  
if Assets:isA("ProximityPrompt") then 
task.spawn(function()
if Assets.HoldDuration ~= 0 then
Assets:SetAttribute("HoldDurationOld",Assets.HoldDuration)
Assets.HoldDuration = 0
end
end)
end 
end  
wait(0.1) end 
for _,Assets in pairs(Game.Workspace:GetDescendants()) do  
if Assets:isA("ProximityPrompt") then 
task.spawn(function()
if Assets:GetAttribute("HoldDurationOld") and Assets:GetAttribute("HoldDurationOld") ~= 0 then
Assets.HoldDuration = Assets:GetAttribute("HoldDurationOld")
end
end)
end 
end   
end)
end,
})
local ButtonUnloadCheat = SettingsTab:CreateButton({
   Name = "Unload Cheat",
   Callback = function()
  Rayfield:Destroy()
end,
})
local ActiveEspDistanceToggle = SettingsTab:CreateToggle({
   Name = "Active Distance for esp",
   CurrentValue = false,
   Flag = "EspDistance",
   Callback = function(Value)
  ActiveDistanceEsp = Value 
end,
})
local Themes = {
   ["Default"] = "Default",
   ["Amber Glow"] = "AmberGlow",
   ["Amethyst"] = "Amethyst",
   ["Bloom"] = "Bloom",
   ["Dark Blue"] = "DarkBlue",
   ["Green"] = "Green",
   ["Light"] = "Light",
   ["Ocean"] = "Ocean",
   ["Serenity"] = "Serenity"
}

local Dropdown = SettingsTab:CreateDropdown({
   Name = "Change Theme",
   Options = {"Default", "Amber Glow", "Amethyst", "Bloom", "Dark Blue", "Green", "Light", "Ocean", "Serenity"},
   CurrentOption = selectedTheme,  -- pour afficher ce qui est rÃ©ellement chargÃ©
   Flag = "ThemeSelection",
   Callback = function(Selected)
      local ident = Themes[Selected[1]]
      Window.ModifyTheme(ident)  -- <â€” Applique le thÃ¨me en direct
   end, 
})
Rayfield:LoadConfiguration()
