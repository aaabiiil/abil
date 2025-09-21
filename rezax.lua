local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Window = WindUI:CreateWindow({
    Folder = "RezaXRama",   
    Title = "REZA IS HERE",
    Icon = "star",
    Author = "ringta",
    Theme = "Dark",
    Size = UDim2.fromOffset(500, 350),
    HasOutline = true,
})

Window:EditOpenButton({
    Title = "REZAXRAMA",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "star" }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "rocket" }),
    Bring = Window:Tab({ Title = "Bring Items", Icon = "package" }),
    Hitbox = Window:Tab({ Title = "Hitbox", Icon = "target" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "tool" }),
}


local infHungerActive = false
local infHungerThread

Tabs.Main:Toggle({
    Title = "Inf hunger",
    Default = false,
    Callback = function(state)
        infHungerActive = state
        if state then
            infHungerThread = task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local RequestConsumeItem = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestConsumeItem")
                while infHungerActive do
                    local args = {
                        Instance.new("Model", nil)
                    }
                    RequestConsumeItem:InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        else
            infHungerActive = false
        end
    end
})

local autoTreeFarmActive = false
local autoTreeFarmThread

Tabs.Main:Toggle({
    Title = "Auto Tree Farm",
    Default = false,
    Callback = function(state)
        autoTreeFarmActive = state
        if state then
            autoTreeFarmThread = task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local ToolDamageObject = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject")
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local Backpack = LocalPlayer:WaitForChild("Backpack")
                local function getAllTrees()
                    local map = workspace:FindFirstChild("Map")
                    if not map then return {} end
                    local landmarks = map:FindFirstChild("Landmarks") or map:FindFirstChild("Foliage")
                    if not landmarks then return {} end
                    local trees = {}
                    for _, tree in ipairs(landmarks:GetChildren()) do
                        if tree.Name == "Small Tree" and tree:IsA("Model") and tree.Parent then
                            local trunk = tree:FindFirstChild("Trunk") or tree.PrimaryPart
                            if trunk then
                                table.insert(trees, {tree = tree, trunk = trunk})
                            end
                        end
                    end
                    return trees
                end
                local function getAxe()
                    local inv = LocalPlayer:FindFirstChild("Inventory")
                    if not inv then return nil end
                    return inv:FindFirstChild("Old Axe") or inv:FindFirstChildWhichIsA("Tool")
                end
                while autoTreeFarmActive do
                    local trees = getAllTrees()
                    for _, t in ipairs(trees) do
                        if not autoTreeFarmActive then break end
                        if t.tree and t.tree.Parent then
                            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                            local hrp = char:FindFirstChild("HumanoidRootPart", 3)
                            if hrp and t.trunk then
                                local treeCFrame = t.trunk.CFrame
                                local rightVector = treeCFrame.RightVector
                                local targetPosition = treeCFrame.Position + rightVector * 3
                                hrp.CFrame = CFrame.new(targetPosition)
                                task.wait(0.25)
                                local axe = getAxe()
                                if axe then
                                    if axe.Parent == Backpack then
                                        axe.Parent = char
                                        task.wait(0.15)
                                    end
                                    while t.tree.Parent and autoTreeFarmActive do
                                        pcall(function() axe:Activate() end)
                                        local args = {
                                            t.tree,
                                            axe,
                                            "1_8264699301",
                                            t.trunk.CFrame
                                        }
                                        pcall(function() ToolDamageObject:InvokeServer(unpack(args)) end)
                                        task.wait(1)
                                    end
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                    task.wait(1)
                end
            end)
        else
            autoTreeFarmActive = false
        end
    end
})

local autoBreakActive = false
local autoBreakThread
local autoBreakSpeed = 1

Tabs.Main:Slider({
    Title = "Auto Hit Speed",
    Min = 0.1,
    Max = 2,
    Default = 1,
    Callback = function(val)
        autoBreakSpeed = val
    end
})

Tabs.Main:Toggle({
    Title = "Auto Hit (autoBreak)",
    Default = false,
    Callback = function(state)
        autoBreakActive = state
        if state then
            autoBreakThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local camera = workspace.CurrentCamera
                while autoBreakActive do
                    local function getWeapon()
                        local inv = player:FindFirstChild("Inventory")
                        return inv and (inv:FindFirstChild("Spear")
                            or inv:FindFirstChild("Strong Axe")
                            or inv:FindFirstChild("Good Axe")
                            or inv:FindFirstChild("Old Axe"))
                    end
                    local weapon = getWeapon()
                    if weapon then
                        local ray = workspace:Raycast(camera.CFrame.Position, camera.CFrame.LookVector * 15)
                        if ray and ray.Instance and ray.Instance.Name == "Trunk" then
                            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(
                                ray.Instance.Parent, weapon, "4_7591937906", CFrame.new(ray.Position)
                            )
                        end
                    end
                    task.wait(autoBreakSpeed)
                end
            end)
        else
            autoBreakActive = false
        end
    end
})



-----------------------------------------------------------------
-- TELEPORT TAB
-----------------------------------------------------------------
Tabs.Teleport:Button({
    Title="Teleport to Camp",
    Callback=function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(
                13.287363052368164, 3.999999761581421, 0.36212217807769775,
                0.6022269129753113, -2.275036159460342e-08, 0.7983249425888062,
                6.430457055728311e-09, 1, 2.364672191390582e-08,
                -0.7983249425888062, -9.1070981866892e-09, 0.6022269129753113
            )
        end
    end
})
Tabs.Teleport:Button({
    Title="Teleport to Trader",
    Callback=function()
        local pos = Vector3.new(-37.08, 3.98, -16.33)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end
})

Tabs.Teleport:Button({
    Title = "TP to Random Tree",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart", 3)
        if not hrp then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end
        -- Try to use Foliage or Landmarks for trees
        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end

        -- Gather all "Small Tree" models
        local trees = {}
        for _, obj in ipairs(foliage:GetChildren()) do
            if obj.Name == "Small Tree" and obj:IsA("Model") then
                local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                if trunk then
                    table.insert(trees, trunk)
                end
            end
        end

        -- Pick a random tree
        if #trees > 0 then
            local trunk = trees[math.random(1, #trees)]
            local treeCFrame = trunk.CFrame
            local rightVector = treeCFrame.RightVector
            local targetPosition = treeCFrame.Position + rightVector * 3
            hrp.CFrame = CFrame.new(targetPosition)
        end
    end
})



--// ============== SETTINGS ============== \\--

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
                
                -- Stop if we've collected enough (unless unlimited)
                if targetCount ~= -1 and collectedCount >= targetCount then
                    break
                end
            end
        end
    end
    
    statusLabel.Text = "âœ… " .. itemName .. ": " .. itemsMoved .. "/" .. itemsFound .. " collected"
    
    -- Rescan to update counts after short delay
    task.spawn(function()
        task.wait(0.5)
        scanWorkspaceItems()
    end)
end

-- Function to create item entry in the list
local function createItemEntry(itemName, found, target)
    local entry = Instance.new("TextButton")
    entry.Name = itemName .. "_Entry"
    entry.Size = UDim2.new(1, -10, 0, 36)
    entry.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    entry.BorderSizePixel = 0
    entry.Text = ""
    entry.AutoButtonColor = false
    entry.Parent = scrollFrame
    
    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 8)
    entryCorner.Parent = entry
    
    local itemData = targetItems[itemName] or {quantity = 1, category = "Miscellaneous"}
    local displayTarget = itemData.quantity
    
    -- Click to collect individual item
    entry.MouseButton1Click:Connect(function()
        if found > 0 then -- Only allow clicking if items are available
            bringSpecificItem(itemName)
        end
    end)
    
    local itemLabel = Instance.new("TextLabel")
    itemLabel.Parent = entry
    itemLabel.Size = UDim2.new(0.7, 0, 1, 0)
    itemLabel.Position = UDim2.new(0, 10, 0, 0)
    itemLabel.BackgroundTransparency = 1
    itemLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    itemLabel.Font = Enum.Font.SourceSans
    itemLabel.Text = itemName
    itemLabel.TextSize = 14
    itemLabel.TextXAlignment = Enum.TextXAlignment.Left
    itemLabel.ClipsDescendants = true
    
    local countLabel = Instance.new("TextLabel")
    countLabel.Parent = entry
    countLabel.Size = UDim2.new(0.3, -10, 1, 0)
    countLabel.Position = UDim2.new(0.7, 0, 0, 0)
    countLabel.BackgroundTransparency = 1
    countLabel.Font = Enum.Font.SourceSansSemibold
    countLabel.TextSize = 14
    countLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    -- Color coding based on target vs found
    if found == 0 then
        countLabel.Text = "0/" .. (displayTarget == -1 and "âˆž" or displayTarget)
        countLabel.TextColor3 = Color3.fromRGB(180, 180, 188)
        itemLabel.TextColor3 = Color3.fromRGB(120, 120, 128)
        entry.BackgroundColor3 = Color3.fromRGB(248, 248, 248)
    elseif displayTarget == -1 then
        countLabel.Text = found .. " (âˆž)"
        countLabel.TextColor3 = Color3.fromRGB(52, 199, 89)
    elseif found >= displayTarget then
        countLabel.Text = found .. "/" .. displayTarget .. " âœ“"
        countLabel.TextColor3 = Color3.fromRGB(52, 199, 89)
    else
        countLabel.Text = found .. "/" .. displayTarget
        countLabel.TextColor3 = Color3.fromRGB(0, 122, 255)
    end
    
    -- Highlight effect
    entry.MouseEnter:Connect(function()
        if found > 0 then
            entry.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
        end
    end)
    
    entry.MouseLeave:Connect(function()
        entry.BackgroundColor3 = found > 0 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(248, 248, 248)
    end)
    
    return entry
end

-- Function to update the item list display based on the current category
updateItemDisplay = function()
    -- Clear existing entries
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Name:match("_Entry$") then
            child:Destroy()
        end
    end
    
    -- Create new entries
    for itemName, itemData in pairs(targetItems) do
        if currentCategory == "All" or itemData.category == currentCategory then
            local foundCount = availableItems[itemName] or 0
            createItemEntry(itemName, foundCount, itemData.quantity)
        end
    end
    
    -- Update canvas size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

-- Function to scan workspace for items
function scanWorkspaceItems()
    if not canScan then return end
    canScan = false
    
    availableItems = {}
    local totalItems = 0
    
    statusLabel.Text = "ðŸ” Scanning workspace..."
    
    -- Look in workspace and common item containers
    local function scanContainer(container, containerName)
        for _, item in pairs(container:GetDescendants()) do
            if targetItems[item.Name] then
                availableItems[item.Name] = (availableItems[item.Name] or 0) + 1
                totalItems = totalItems + 1
            end
        end
    end
    
    -- Scan main workspace
    scanContainer(workspace, "Workspace")
    
    -- Scan common item container names
    local itemContainers = workspace:FindFirstChild("Items") or workspace:FindFirstChild("ItemSpawns") or workspace:FindFirstChild("Collectibles")
    if itemContainers then
        scanContainer(itemContainers, "Items Container")
    end
    
    statusLabel.Text = "ðŸ“Š Found " .. totalItems .. " target items"
    updateItemDisplay()
    
    task.spawn(function()
        task.wait(1)
        canScan = true
    end)
end

-- Function to bring items to player
local function bringItemsToPlayer()
    if not canGrab then return end
    canGrab = false
    
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        statusLabel.Text = "âŒ Character not found!"
        canGrab = true
        return
    end

    local targetPosition = character.HumanoidRootPart.CFrame
    local itemsFound = 0
    local itemsMoved = 0
    local itemsCounted = {}
    
    statusLabel.Text = "ðŸ“¦ Collecting items..."
    
    -- Initialize counters
    for itemName, _ in pairs(targetItems) do
        itemsCounted[itemName] = 0
    end
    
    -- Search through workspace
    for _, item in pairs(workspace:GetDescendants()) do
        if targetItems[item.Name] then
            local itemName = item.Name
            local targetCount = targetItems[itemName].quantity
            
            -- Check if we need more of this item
            if targetCount == -1 or itemsCounted[itemName] < targetCount then
                itemsFound = itemsFound + 1
                itemsCounted[itemName] = itemsCounted[itemName] + 1
                
                local success = false
                
                -- Handle different item types
                if item:IsA("BasePart") then
                    if item.Anchored then
                        item.Anchored = false
                    end
                    item.CFrame = targetPosition * CFrame.new(math.random(-5, 5), 2, math.random(-5, 5))
                    success = true
                elseif item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChildOfClass("BasePart")
                    if primaryPart then
                        if primaryPart.Anchored then
                            primaryPart.Anchored = false
                        end
                        if item.PrimaryPart then
                            item:SetPrimaryPartCFrame(targetPosition * CFrame.new(math.random(-5, 5), 2, math.random(-5, 5)))
                        else
                            primaryPart.CFrame = targetPosition * CFrame.new(math.random(-5, 5), 2, math.random(-5, 5))
                        end
                        success = true
                    end
                end
                
                if success then
                    itemsMoved = itemsMoved + 1
                end
            end
        end
    end
    
    statusLabel.Text = "ðŸŽ‰ Moved " .. itemsMoved .. "/" .. itemsFound .. " items!"
    
    -- Reset after cooldown
    task.spawn(function()
        task.wait(COOLDOWN)
        canGrab = true
        -- Rescan to update counts
        scanWorkspaceItems()
    end)
end

-- Category Buttons
local function createTabButton(name)
    local button = Instance.new("TextButton")
    button.Name = name .. "Tab"
    button.Size = UDim2.new(1/#categories, 0, 1, 0)
    button.BackgroundColor3 = name == "All" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(229, 229, 234)
    button.TextColor3 = name == "All" and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(120, 120, 128)
    button.Font = Enum.Font.SourceSansSemibold
    button.Text = name
    button.TextSize = 12
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Parent = tabContainer

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        for _, btn in pairs(tabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(229, 229, 234)
                btn.TextColor3 = Color3.fromRGB(120, 120, 128)
            end
        end
        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        button.TextColor3 = Color3.fromRGB(0, 122, 255) -- iOS blue
        
        currentCategory = name
        updateItemDisplay()
    end)
    
    return button
end

-- Create category tabs
for _, cat in ipairs(categories) do
    createTabButton(cat)
end

-- Action Buttons (Compact horizontal layout)
local buttonContainer = Instance.new("Frame")
buttonContainer.Parent = mainFrame
buttonContainer.Size = UDim2.new(1, -20, 0, 36)
buttonContainer.Position = UDim2.new(0, 10, 0, 85)
buttonContainer.BackgroundTransparency = 1

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.Parent = buttonContainer
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.Padding = UDim.new(0, 10)
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Scan Button
local scanButton = createiOSButton("ðŸ”", Color3.fromRGB(0, 122, 255)) -- Blue
scanButton.Parent = buttonContainer
scanButton.MouseButton1Click:Connect(scanWorkspaceItems)

-- Discover Button
local discoverButton = createiOSButton("ðŸ†•", Color3.fromRGB(255, 149, 0)) -- Orange
discoverButton.Parent = buttonContainer
discoverButton.MouseButton1Click:Connect(discoverNewItems)

-- Grab Button
local grabButton = createiOSButton("ðŸ“¦", Color3.fromRGB(52, 199, 89)) -- Green
grabButton.Parent = buttonContainer
grabButton.MouseButton1Click:Connect(bringItemsToPlayer)

-- Initial scan after a brief delay to ensure everything is loaded
task.spawn(function()
    task.wait(1)
    scanWorkspaceItems()
end)

print("loaded successfully!")
print("ðŸ“‹ Targeting " .. tostring(#targetItems) .. " different item types")
print("ðŸ” Use scan button to find items")
print("ðŸ“¦ Use grab button to collect items")
print("ðŸ‘† Tap individual items to collect them")
-----------------------------------------------------------------
-- HITBOX TAB
-----------------------------------------------------------------
local hitboxSettings = {Wolf=false, Bunny=false, Cultist=false, Show=false, Size=10}

local function updateHitboxForModel(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local name = model.Name:lower()
    local shouldResize =
        (hitboxSettings.Wolf and (name:find("wolf") or name:find("alpha"))) or
        (hitboxSettings.Bunny and name:find("bunny")) or
        (hitboxSettings.Cultist and (name:find("cultist") or name:find("cross")))
    if shouldResize then
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
    end
end

task.spawn(function()
    while true do
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                updateHitboxForModel(model)
            end
        end
        task.wait(2)
    end
end)

Tabs.Hitbox:Toggle({Title="Expand Wolf Hitbox", Default=false, Callback=function(val) hitboxSettings.Wolf=val end})
Tabs.Hitbox:Toggle({Title="Expand Bunny Hitbox", Default=false, Callback=function(val) hitboxSettings.Bunny=val end})
Tabs.Hitbox:Toggle({Title="Expand Cultist Hitbox", Default=false, Callback=function(val) hitboxSettings.Cultist=val end})
Tabs.Hitbox:Slider({Title="Hitbox Size", Value={Min=2, Max=30, Default=10}, Step=1, Callback=function(val) hitboxSettings.Size=val end})
Tabs.Hitbox:Toggle({Title="Show Hitbox (Transparency)", Default=false, Callback=function(val) hitboxSettings.Show=val end})

-----------------------------------------------------------------
-- MISC TAB
-----------------------------------------------------------------
getgenv().speedEnabled = false
getgenv().speedValue = 28
Tabs.Misc:Toggle({
    Title = "Speed Hack",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})
Tabs.Misc:Slider({
    Title = "Speed Value",
    Value = {Min = 16, Max = 600, Default = 28},
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 10), Color3.fromRGB(0,255,0), false, true, showFPS
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 30), Color3.fromRGB(0,255,0), false, true, showPing
local fpsCounter, fpsLastUpdate = 0, tick()

RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end
        if showPing then
            local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            msText.Text = "Ping: " .. ping .. " ms"
            if ping <= 60 then
                msText.Color = Color3.fromRGB(0, 255, 0)
            elseif ping <= 120 then
                msText.Color = Color3.fromRGB(255, 165, 0)
            else
                msText.Color = Color3.fromRGB(255, 0, 0)
            end
            msText.Visible = true
        else
            msText.Visible = false
        end
        fpsCounter = 0
        fpsLastUpdate = tick()
    end
end)
Tabs.Misc:Toggle({Title="Show FPS", Default=true, Callback=function(val) showFPS=val; fpsText.Visible=val end})
Tabs.Misc:Toggle({Title="Show Ping (ms)", Default=true, Callback=function(val) showPing=val; msText.Visible=val end})

Tabs.Misc:Button({
    Title = "FPS Boost",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 0
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        print("✅ FPS Boost Applied")
    end
})end})
Tabs.Bring:Button({Title="Bring Coal", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("coal") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})
Tabs.Bring:Button({Title="Bring Meat (Raw + Cooked)", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("meat") or name:find("cooked")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Flashlight", Callback=function() bringItemsByName("Flashlight") end})
Tabs.Bring:Button({Title="Bring Nails", Callback=function() bringItemsByName("Nails") end})
Tabs.Bring:Button({Title="Bring Fan", Callback=function() bringItemsByName("Fan") end})
Tabs.Bring:Button({Title="Bring Ammo", Callback=function()
    local keywords = {"ammo"}
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in ipairs(workspace.Items:GetChildren()) do
        for _, word in ipairs(keywords) do
            if item.Name:lower():find(word) then
                local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
                if part then
                    part.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
                end
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Sheet Metal", Callback=function()

end})

-----------------------------------------------------------------
-- HITBOX TAB
-----------------------------------------------------------------
local hitboxSettings = {Wolf=false, Bunny=false, Cultist=false, Show=false, Size=10}

local function updateHitboxForModel(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local name = model.Name:lower()
    local shouldResize =
        (hitboxSettings.Wolf and (name:find("wolf") or name:find("alpha"))) or
        (hitboxSettings.Bunny and name:find("bunny")) or
        (hitboxSettings.Cultist and (name:find("cultist") or name:find("cross")))
    if shouldResize then
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
    end
end

task.spawn(function()
    while true do
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                updateHitboxForModel(model)
            end
        end
        task.wait(2)
    end
end)

Tabs.Hitbox:Toggle({Title="Expand Wolf Hitbox", Default=false, Callback=function(val) hitboxSettings.Wolf=val end})
Tabs.Hitbox:Toggle({Title="Expand Bunny Hitbox", Default=false, Callback=function(val) hitboxSettings.Bunny=val end})
Tabs.Hitbox:Toggle({Title="Expand Cultist Hitbox", Default=false, Callback=function(val) hitboxSettings.Cultist=val end})
Tabs.Hitbox:Slider({Title="Hitbox Size", Value={Min=2, Max=30, Default=10}, Step=1, Callback=function(val) hitboxSettings.Size=val end})
Tabs.Hitbox:Toggle({Title="Show Hitbox (Transparency)", Default=false, Callback=function(val) hitboxSettings.Show=val end})

-----------------------------------------------------------------
-- MISC TAB
-----------------------------------------------------------------
getgenv().speedEnabled = false
getgenv().speedValue = 28
Tabs.Misc:Toggle({
    Title = "Speed Hack",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})
Tabs.Misc:Slider({
    Title = "Speed Value",
    Value = {Min = 16, Max = 600, Default = 28},
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 10), Color3.fromRGB(0,255,0), false, true, showFPS
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 30), Color3.fromRGB(0,255,0), false, true, showPing
local fpsCounter, fpsLastUpdate = 0, tick()

RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end
        if showPing then
            local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            msText.Text = "Ping: " .. ping .. " ms"
            if ping <= 60 then
                msText.Color = Color3.fromRGB(0, 255, 0)
            elseif ping <= 120 then
                msText.Color = Color3.fromRGB(255, 165, 0)
            else
                msText.Color = Color3.fromRGB(255, 0, 0)
            end
            msText.Visible = true
        else
            msText.Visible = false
        end
        fpsCounter = 0
        fpsLastUpdate = tick()
    end
end)
Tabs.Misc:Toggle({Title="Show FPS", Default=true, Callback=function(val) showFPS=val; fpsText.Visible=val end})
Tabs.Misc:Toggle({Title="Show Ping (ms)", Default=true, Callback=function(val) showPing=val; msText.Visible=val end})

Tabs.Misc:Button({
    Title = "FPS Boost",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 0
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        print("✅ FPS Boost Applied")
    end
})
