local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Aura Hub",
    Icon = "palette",
    Author = "Thanawat_9999",
    Folder = "Premium",
    Size = UDim2.fromOffset(550, 320),
    Theme = "Light",
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
        end
    },
    SideBarWidth = 200,
})

local Tabs = {
    Main = Window:Section({ Title = "Player", Opened = true }),
    Play = Window:Section({ Title = "Play Game", Opened = true }),
    Misc = Window:Section({ Title = "Misc", Opened = true }),

}
local TabHandles = {
    Player = Tabs.Main:Tab({ Title = "Speed & Jump", Icon = "layout-grid", Desc = "" }),
    Esp = Tabs.Main:Tab({ Title = "Esp & Item", Icon = "layout-grid", Desc = "" }),
    Chest = Tabs.Main:Tab({ Title = "Auto Chest", Icon = "layout-grid", Desc = "" }),
    Camp = Tabs.Play:Tab({ Title = "Camp Fire", Icon = "layout-grid", Desc = "" }),
    Create = Tabs.Play:Tab({ Title = "Create", Icon = "layout-grid", Desc = "" }),
    Tree = Tabs.Play:Tab({ Title = "Tree Farm", Icon = "layout-grid", Desc = "" }),
    Noclip = Tabs.Misc:Tab({ Title = "Noclip", Icon = "layout-grid", Desc = "" }),
    FlyUp = Tabs.Misc:Tab({ Title = "Fly Up", Icon = "layout-grid", Desc = "" }),

}
local SpeedBoost = TabHandles.Player:Toggle({
    Title = "Speed Boost",
    Locked = false,
    Value = false,
    Callback = function(state) 
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = state and 130 or 16
    end
})
local SpeedBoost50 = TabHandles.Player:Toggle({
    Title = "Speed Boost (Speed 60)",
    Locked = true,
    Value = false,
    Callback = function(state) 
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = state and 60 or 16
    end
})
local InfJumpToggle = TabHandles.Player:Toggle({
    Title = "Inf Jump",
    Locked = false,
    Value = false,
    Callback = function(state)
        local UserInputService = game:GetService("UserInputService")
        if state then
            _G.InfJumpConn = UserInputService.JumpRequest:Connect(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            if _G.InfJumpConn then
                _G.InfJumpConn:Disconnect()
                _G.InfJumpConn = nil
            end
        end
    end
})
local CustomSpeedSlider = TabHandles.Player:Slider({
    Title = "Custom Speed Value",
    Locked = false,
    Value = { Min = 1, Max = 300, Default = 16 },
    Callback = function(value)
        _G.CustomSpeedValue = value
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid and CustomSpeedToggle.Value then
                humanoid.WalkSpeed = value
            end
        end
    end
})

local CustomSpeedToggle = TabHandles.Player:Toggle({
    Title = "Custom Speed",
    Locked = false,
    Value = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        if state then
            humanoid.WalkSpeed = _G.CustomSpeedValue or 16
        else
            humanoid.WalkSpeed = 16
        end
    end
})
TabHandles.Esp:Paragraph({
    Title = "Esp Player",
})
local EspPlayerToggle = TabHandles.Esp:Toggle({
    Title = "Start Esp Player",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local function applyEsp(char)
                    local head = char:FindFirstChild("Head")
                    if head then
                        local billboard = head:FindFirstChild("EspBillboard")
                        if state then
                            if not billboard then
                                billboard = Instance.new("BillboardGui")
                                billboard.Name = "EspBillboard"
                                billboard.AlwaysOnTop = true
                                billboard.Size = UDim2.new(0, 200, 0, 50)
                                billboard.StudsOffset = Vector3.new(0, 3, 0)
                                billboard.MaxDistance = 0
                                billboard.Parent = head

                                local label = Instance.new("TextLabel")
                                label.Name = "EspLabel"
                                label.BackgroundTransparency = 1
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.TextColor3 = Color3.fromRGB(0, 255, 0)
                                label.TextStrokeTransparency = 0
                                label.Font = Enum.Font.SourceSansBold
                                label.TextSize = 14
                                label.TextScaled = false
                                label.Text = ""
                                label.Parent = billboard
                            end
                        else
                            if billboard then
                                billboard:Destroy()
                            end
                        end
                    end
                end

                if player.Character then
                    applyEsp(player.Character)
                end
                player.CharacterAdded:Connect(applyEsp)
            end
        end
    end
})

local EspNameToggle = TabHandles.Esp:Toggle({
    Title = "ESP Name",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local billboard = head:FindFirstChild("EspBillboard")
                    if billboard and billboard:FindFirstChild("EspLabel") then
                        local label = billboard.EspLabel
                        if state then
                            if not string.find(label.Text, "Name:") then
                                label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Name: " .. player.Name
                            end
                        else
                            label.Text = label.Text:gsub("Name: [^|]*|? ?", "")
                        end
                    end
                end
            end
        end
    end
})

local EspDistanceToggle = TabHandles.Esp:Toggle({
    Title = "ESP Distance",
    Locked = false,
    Value = false,
    Callback = function(state)
        local localPlayer = game.Players.LocalPlayer
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local billboard = head:FindFirstChild("EspBillboard")
                    if billboard and billboard:FindFirstChild("EspLabel") then
                        local label = billboard.EspLabel
                        if state then
                            local dist = math.floor((player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)
                            if not string.find(label.Text, "Location:") then
                                label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Location: " .. dist
                            end
                        else
                            label.Text = label.Text:gsub("Location: [^|]*|? ?", "")
                        end
                    end
                end
            end
        end
    end
})

local EspHealthToggle = TabHandles.Esp:Toggle({
    Title = "ESP Health",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if head and humanoid then
                    local billboard = head:FindFirstChild("EspBillboard")
                    if billboard and billboard:FindFirstChild("EspLabel") then
                        local label = billboard.EspLabel
                        if state then
                            if not string.find(label.Text, "Health:") then
                                label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Health: " .. math.floor(humanoid.Health)
                            end
                        else
                            label.Text = label.Text:gsub("Health: [^|]*|? ?", "")
                        end
                    end
                end
            end
        end
    end
})
TabHandles.Esp:Paragraph({
    Title = "Esp NPC",
})
local EspNpcToggle = TabHandles.Esp:Toggle({
    Title = "Start Esp NPC",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, npc in pairs(workspace:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("Head") and not game.Players:GetPlayerFromCharacter(npc) then
                local head = npc:FindFirstChild("Head")
                local billboard = head:FindFirstChild("EspNpcBillboard")
                if state then
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "EspNpcBillboard"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.MaxDistance = 0
                        billboard.Parent = head

                        local label = Instance.new("TextLabel")
                        label.Name = "EspNpcLabel"
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.TextColor3 = Color3.fromRGB(255, 255, 0)
                        label.TextStrokeTransparency = 0
                        label.Font = Enum.Font.SourceSansBold
                        label.TextSize = 14
                        label.TextScaled = false
                        label.Text = ""
                        label.Parent = billboard
                    end
                else
                    if billboard then
                        billboard:Destroy()
                    end
                end
            end
        end
    end
})

local EspNpcNameToggle = TabHandles.Esp:Toggle({
    Title = "ESP NPC Name",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, npc in pairs(workspace:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("Head") and not game.Players:GetPlayerFromCharacter(npc) then
                local head = npc.Head
                local billboard = head:FindFirstChild("EspNpcBillboard")
                if billboard and billboard:FindFirstChild("EspNpcLabel") then
                    local label = billboard.EspNpcLabel
                    if state then
                        if not string.find(label.Text, "Name:") then
                            label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Name: " .. npc.Name
                        end
                    else
                        label.Text = label.Text:gsub("Name: [^|]*|? ?", "")
                    end
                end
            end
        end
    end
})

local EspNpcDistanceToggle = TabHandles.Esp:Toggle({
    Title = "ESP NPC Distance",
    Locked = false,
    Value = false,
    Callback = function(state)
        local localPlayer = game.Players.LocalPlayer
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

        for _, npc in pairs(workspace:GetChildren()) do
            if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Head") and not game.Players:GetPlayerFromCharacter(npc) then
                local head = npc.Head
                local billboard = head:FindFirstChild("EspNpcBillboard")
                if billboard and billboard:FindFirstChild("EspNpcLabel") then
                    local label = billboard.EspNpcLabel
                    if state then
                        local dist = math.floor((npc.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)
                        if not string.find(label.Text, "Location:") then
                            label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Location: " .. dist
                        end
                    else
                        label.Text = label.Text:gsub("Location: [^|]*|? ?", "")
                    end
                end
            end
        end
    end
})

local EspNpcHealthToggle = TabHandles.Esp:Toggle({
    Title = "ESP NPC Health",
    Locked = false,
    Value = false,
    Callback = function(state)
        for _, npc in pairs(workspace:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("Head") and not game.Players:GetPlayerFromCharacter(npc) then
                local head = npc.Head
                local humanoid = npc.Humanoid
                local billboard = head:FindFirstChild("EspNpcBillboard")
                if billboard and billboard:FindFirstChild("EspNpcLabel") then
                    local label = billboard.EspNpcLabel
                    if state then
                        if not string.find(label.Text, "Health:") then
                            label.Text = (label.Text ~= "" and label.Text .. " | " or "") .. "Health: " .. math.floor(humanoid.Health)
                        end
                    else
                        label.Text = label.Text:gsub("Health: [^|]*|? ?", "")
                    end
                end
            end
        end
    end
})
TabHandles.Esp:Paragraph({
    Title = "Item",
})
local Models = {}
for _, obj in pairs(workspace:GetChildren()) do
    if obj:IsA("Model") and obj:FindFirstChild("PrimaryPart") then
        table.insert(Models, obj.Name)
    end
end
local SelectedModel = nil
local BroughtModels = {}

local Dropdown = TabHandles.Esp:Dropdown({
    Title = "Select Item",
    Values = Models,
    Locked = false,
    Value = Models[1] or "",
    Callback = function(option)
        SelectedModel = option
    end
})

TabHandles.Esp:Button({
    Title = "Bring Model",
    Icon = "bell",
    Callback = function()
        if SelectedModel and not BroughtModels[SelectedModel] then
            local model = workspace:FindFirstChild(SelectedModel)
            local player = game.Players.LocalPlayer
            if model and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                model:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, -5))
                BroughtModels[SelectedModel] = true
            end
        end
    end
})

local AutoChestToggle = TabHandles.Chest:Toggle({
    Title = "Auto Open Chest (Auto)",
    Locked = false,
    Value = false,
    Callback = function(v)
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        if not _G.AutoChestData then
            _G.AutoChestData = {running = false, originalCFrame = nil}
        end

        local function getChests()
            local chests = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and string.find(obj.Name, "Item Chest") then
                    table.insert(chests, obj)
                end
            end
            return chests
        end

        local function getPrompt(model)
            local prompts = {}
            for _, obj in ipairs(model:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    table.insert(prompts, obj)
                end
            end
            return prompts
        end

        if v then
            if _G.AutoChestData.running then return end
            _G.AutoChestData.running = true
            _G.AutoChestData.originalCFrame = humanoidRootPart.CFrame
            task.spawn(function()
                while _G.AutoChestData.running do
                    local chests = getChests()
                    for _, chest in ipairs(chests) do
                        if not _G.AutoChestData.running then break end
                        local part = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
                        if part then
                            humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 6, 0)
                            local prompts = getPrompt(chest)
                            for _, prompt in ipairs(prompts) do
                                fireproximityprompt(prompt, math.huge)
                            end
                            local t = tick()
                            while _G.AutoChestData.running and tick() - t < 4 do task.wait() end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            _G.AutoChestData.running = false
            if _G.AutoChestData.originalCFrame then
                humanoidRootPart.CFrame = _G.AutoChestData.originalCFrame
            end
        end
    end
})
local chestRange = 50

local ChestRangeSlider = TabHandles.Chest:Slider({
    Title = "Range Open Chest",
    Locked = false,
    Value = { Min = 1, Max = 100, Default = 50 },
    Callback = function(val)
        chestRange = val
    end
})

local AutoChestNearToggle = TabHandles.Chest:Toggle({
    Title = "Auto Open Chest (Near)",
    Locked = false,
    Value = false,
    Callback = function(v)
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        if not _G.AutoChestNearby then
            _G.AutoChestNearby = {running = false}
        end

        local function getPromptsInRange(range)
            local prompts = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and string.find(obj.Name, "Item Chest") then
                    local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local dist = (humanoidRootPart.Position - part.Position).Magnitude
                        if dist <= range then
                            for _, p in ipairs(obj:GetDescendants()) do
                                if p:IsA("ProximityPrompt") then
                                    table.insert(prompts, p)
                                end
                            end
                        end
                    end
                end
            end
            return prompts
        end

        if v then
            if _G.AutoChestNearby.running then return end
            _G.AutoChestNearby.running = true
            task.spawn(function()
                while _G.AutoChestNearby.running do
                    local prompts = getPromptsInRange(chestRange)
                    for _, prompt in ipairs(prompts) do
                        fireproximityprompt(prompt, math.huge)
                    end
                    task.wait(0.5)
                end
            end)
        else
            _G.AutoChestNearby.running = false
        end
    end
})

local TeleportChestButton = TabHandles.Chest:Button({
    Title = "Teleport To Chest",
    Icon = "box",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local nearestChest, nearestDist, targetPart
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and string.find(obj.Name, "Item Chest") then
                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local dist = (humanoidRootPart.Position - part.Position).Magnitude
                    if not nearestDist or dist < nearestDist then
                        nearestDist = dist
                        nearestChest = obj
                        targetPart = part
                    end
                end
            end
        end

        if targetPart then
            humanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, targetPart.Size.Y/2 + 6, 0)
        end
    end
})




local AutoCampTeleportLog = TabHandles.Camp:Toggle({
    Title = "Auto Camp (Teleport - Log)",
    Locked = false,
    Value = false,
    Callback = function(v)
        if v then
            _G.AutoLog = true
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local originalPos = hrp and hrp.CFrame
            task.spawn(function()
                while _G.AutoLog do
                    task.wait()
                    for _, m in pairs(workspace:GetDescendants()) do
                        if not _G.AutoLog then break end
                        if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                            if hrp then
                                hrp.CFrame = m.PrimaryPart.CFrame
                                m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                                task.wait(0.2)
                            end
                        end
                    end
                end
                if hrp and originalPos then
                    hrp.CFrame = originalPos
                end
            end)
        else
            _G.AutoLog = false
        end
    end
})

local AutoCampTeleportCoal = TabHandles.Camp:Toggle({
    Title = "Auto Camp (Teleport - Coal)",
    Locked = false,
    Value = false,
    Callback = function(v)
        if v then
            _G.AutoCoal = true
            local player = game.Players.LocalPlayer
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local originalPos = hrp and hrp.CFrame
            task.spawn(function()
                while _G.AutoCoal do
                    task.wait()
                    for _, m in pairs(workspace:GetDescendants()) do
                        if not _G.AutoCoal then break end
                        if m:IsA("Model") and m.Name == "Coal" and m.PrimaryPart then
                            if hrp then
                                hrp.CFrame = m.PrimaryPart.CFrame
                                m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                                task.wait(0.2)
                            end
                        end
                    end
                end
                if hrp and originalPos then
                    hrp.CFrame = originalPos
                end
            end)
        else
            _G.AutoCoal = false
        end
    end
})

local AutoCampTeleportCooked = TabHandles.Camp:Toggle({
    Title = "Auto Cooked (Teleport)",
    Locked = false,
    Value = false,
    Callback = function(v)
        if v then
            _G.AutoMorsel = true
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local originalPos = hrp and hrp.CFrame
            task.spawn(function()
                while _G.AutoMorsel do
                    task.wait()
                    for _, m in pairs(workspace:GetDescendants()) do
                        if not _G.AutoMorsel then break end
                        if m:IsA("Model") and m.Name == "Morsel" and m.PrimaryPart then
                            if hrp then
                                hrp.CFrame = m.PrimaryPart.CFrame
                                m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                                task.wait(0.2)
                            end
                        end
                    end
                end
                if hrp and originalPos then
                    hrp.CFrame = originalPos
                end
            end)
        else
            _G.AutoMorsel = false
        end
    end
})

local AutoCampBringLogs = TabHandles.Camp:Toggle({
    Title = "Auto Camp (Bring - Logs)",
    Locked = false,
    Value = false,
    Callback = function(v)
        if v then
            _G.BringLogs = true
            task.spawn(function()
                while _G.BringLogs do
                    task.wait()
                    for _, m in pairs(workspace:GetDescendants()) do
                        if not _G.BringLogs then break end
                        if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                            m:SetPrimaryPartCFrame(CFrame.new(-0.5468149185180664, 7.632332801818848, 0.11174965649843216))
                            task.wait(0.2)
                        end
                    end
                end
            end)
        else
            _G.BringLogs = false
        end
    end
})

local AutoCampBringCooked = TabHandles.Camp:Toggle({
    Title = "Auto Cooked (Bring)",
    Locked = false,
    Value = false,
    Callback = function(v)
        if v then
            _G.BringMorsels = true
            task.spawn(function()
                while _G.BringMorsels do
                    task.wait()
                    for _, m in pairs(workspace:GetDescendants()) do
                        if not _G.BringMorsels then break end
                        if m:IsA("Model") and m.Name == "Morsel" and m.PrimaryPart then
                            m:SetPrimaryPartCFrame(CFrame.new(-0.5468149185180664, 7.632332801818848, 0.11174965649843216))
                            task.wait(0.2)
                        end
                    end
                end
            end)
        else
            _G.BringMorsels = false
        end
    end
})

local TeleportToCamp = TabHandles.Camp:Button({
    Title = "Teleport To Camp",
    Callback = function()
        local player = game.Players.LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207)
        end
    end
})
local Toggle_LogBring = TabHandles.Create:Toggle({
    Title = "Auto Log (Bring)",
    Locked = false,
    Value = false,
    Callback = function(state)
        if state then
            _G.CollectLogs = true  
            task.spawn(function()
                while _G.CollectLogs do  
                    task.wait()  
                    for _, m in pairs(workspace:GetDescendants()) do  
                        if not _G.CollectLogs then break end  
                        if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then  
                            m:SetPrimaryPartCFrame(CFrame.new(20.8234, 7.7533, -5.5350))  
                            task.wait(0.2)  
                        end  
                    end  
                end  
            end)
        else
            _G.CollectLogs = false  
        end
    end
})

local Toggle_BoltBring = TabHandles.Create:Toggle({
    Title = "Auto Bolt (Bring)",
    Locked = false,
    Value = false,
    Callback = function(state)
        if state then
            _G.CollectBolt = true  
            task.spawn(function()
                while _G.CollectBolt do  
                    task.wait()  
                    for _, m in pairs(workspace:GetDescendants()) do  
                        if not _G.CollectBolt then break end  
                        if m:IsA("Model") and m.Name == "Bolt" and m.PrimaryPart then  
                            m:SetPrimaryPartCFrame(CFrame.new(20.8234, 7.7533, -5.5350))  
                            task.wait(0.2)  
                        end  
                    end  
                end  
            end)
        else
            _G.CollectBolt = false  
        end
    end
})

local Toggle_LogTeleport = TabHandles.Create:Toggle({
    Title = "Auto Log (Teleport)",
    Locked = false,
    Value = false,
    Callback = function(state)
        if state then
            _G.AutoLogs = true  
            local player = game.Players.LocalPlayer  
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")  
            local originalPos = hrp and hrp.CFrame  
            task.spawn(function()
                while _G.AutoLogs do  
                    task.wait()  
                    for _, m in pairs(workspace:GetDescendants()) do  
                        if not _G.AutoLogs then break end  
                        if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then  
                            if hrp then  
                                hrp.CFrame = m.PrimaryPart.CFrame  
                                m:SetPrimaryPartCFrame(CFrame.new(20.8234, 7.7533, -5.5350))  
                                task.wait(0.2)  
                            end  
                        end  
                    end  
                end  
                if hrp and originalPos then  
                    hrp.CFrame = originalPos  
                end  
            end)
        else
            _G.AutoLogs = false  
        end
    end
})

local Toggle_BoltTeleport = TabHandles.Create:Toggle({
    Title = "Auto Bolt (Teleport)",
    Locked = false,
    Value = false,
    Callback = function(state)
        if state then
            _G.AutoBolts = true  
            local player = game.Players.LocalPlayer  
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")  
            local originalPos = hrp and hrp.CFrame  
            task.spawn(function()
                while _G.AutoBolts do  
                    task.wait()  
                    for _, m in pairs(workspace:GetDescendants()) do  
                        if not _G.AutoBolts then break end  
                        if m:IsA("Model") and m.Name == "Bolt" and m.PrimaryPart then  
                            if hrp then  
                                hrp.CFrame = m.PrimaryPart.CFrame  
                                m:SetPrimaryPartCFrame(CFrame.new(20.8234, 7.7533, -5.5350))  
                                task.wait(0.2)  
                            end  
                        end  
                    end  
                end  
                if hrp and originalPos then  
                    hrp.CFrame = originalPos  
                end  
            end)
        else
            _G.AutoBolts = false  
        end
    end
})
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

local ChopToggle = TabHandles.Tree:Toggle({
    Title = "Auto Chop Tree",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.AutoChop = v
        if v then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local originalPos = hrp and hrp.CFrame
            while _G.AutoChop do
                task.wait()
                local trees = {}
                for _, m in pairs(workspace:GetDescendants()) do
                    if m:IsA("Model") and m.Name == "Small Tree" and m.PrimaryPart then
                        table.insert(trees, m)
                    end
                end
                if #trees == 0 then break end
                for _, tree in ipairs(trees) do
                    if not _G.AutoChop then break end
                    if hrp and tree.PrimaryPart then
                        hrp.CFrame = tree.PrimaryPart.CFrame + Vector3.new(0, 0, -3)
                        UIS.InputBegan:Fire({UserInputType = Enum.UserInputType.MouseButton1}, false)
                        task.wait(1)
                    end
                end
            end
            if hrp and originalPos then
                hrp.CFrame = originalPos
            end
        else
            _G.AutoChop = false
        end
    end
})

local ChopTPToggle = TabHandles.Tree:Toggle({
    Title = "Auto Chop Tree (Teleport + Click)",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.AutoChopTP = v
        if v then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local originalPos = hrp and hrp.CFrame
            while _G.AutoChopTP do
                task.wait(0.3)
                local trees = {}
                for _, tree in pairs(workspace:GetDescendants()) do
                    if tree:IsA("Model") and tree.Name == "Small Tree" and tree.PrimaryPart then
                        table.insert(trees, tree)
                    end
                end
                for _, tree in ipairs(trees) do
                    if not _G.AutoChopTP then break end
                    if hrp and tree.PrimaryPart then
                        hrp.CFrame = tree.PrimaryPart.CFrame + Vector3.new(0,0,-3)
                        UIS.InputBegan:Fire({UserInputType=Enum.UserInputType.MouseButton1, Position=tree.PrimaryPart.Position}, false)
                        task.wait(0.1)
                        UIS.InputEnded:Fire({UserInputType=Enum.UserInputType.MouseButton1, Position=tree.PrimaryPart.Position}, false)
                        task.wait(0.5)
                    end
                end
            end
            if hrp and originalPos then
                hrp.CFrame = originalPos
            end
        else
            _G.AutoChopTP = false
        end
    end
})

local ChopFakeToggle = TabHandles.Tree:Toggle({
    Title = "Auto Chop Tree (Testing)",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.AutoChopFake = v
        if v then
            while _G.AutoChopFake do
                task.wait(0.3)
                for _, tree in pairs(workspace:GetDescendants()) do
                    if not _G.AutoChopFake then break end
                    if tree:IsA("Model") and tree.Name == "Small Tree" and tree.PrimaryPart then
                        local fakeCFrame = tree.PrimaryPart.CFrame * CFrame.new(0,0,-3)
                        UIS.InputBegan:Fire({UserInputType = Enum.UserInputType.MouseButton1, Position = fakeCFrame.Position}, false)
                        task.wait(0.1)
                        UIS.InputEnded:Fire({UserInputType = Enum.UserInputType.MouseButton1, Position = fakeCFrame.Position}, false)
                    end
                end
            end
        else
            _G.AutoChopFake = false
        end
    end
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local Noclip1 = TabHandles.Noclip:Toggle({
    Title = "Basic Noclip",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip1 = v
        while _G.Noclip1 do
            task.wait()
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
})

local Noclip2 = TabHandles.Noclip:Toggle({
    Title = "Smooth Noclip",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip2 = v
        while _G.Noclip2 do
            task.wait()
            hrp.Velocity = Vector3.new(0,0,0)
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
})

local Noclip3 = TabHandles.Noclip:Toggle({
    Title = "Noclip Jump",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip3 = v
        while _G.Noclip3 do
            task.wait()
            hrp.CFrame = hrp.CFrame + Vector3.new(0,0.2,0)
        end
    end
})

local Noclip4 = TabHandles.Noclip:Toggle({
    Title = "Noclip Slide",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip4 = v
        while _G.Noclip4 do
            task.wait()
            hrp.CFrame = hrp.CFrame + Vector3.new(0.5,0,0)
        end
    end
})

local Noclip5 = TabHandles.Noclip:Toggle({
    Title = "Noclip Fly",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip5 = v
        while _G.Noclip5 do
            task.wait()
            hrp.CFrame = hrp.CFrame + Vector3.new(0,1,0)
        end
    end
})

local Noclip6 = TabHandles.Noclip:Toggle({
    Title = "Noclip Down",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip6 = v
        while _G.Noclip6 do
            task.wait()
            hrp.CFrame = hrp.CFrame + Vector3.new(0,-1,0)
        end
    end
})

local Noclip7 = TabHandles.Noclip:Toggle({
    Title = "Wall Phase",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip7 = v
        while _G.Noclip7 do
            task.wait()
            hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 1
        end
    end
})

local Noclip8 = TabHandles.Noclip:Toggle({
    Title = "Noclip Dash",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip8 = v
        while _G.Noclip8 do
            task.wait()
            hrp.CFrame = hrp.CFrame + hrp.CFrame.RightVector * 1
        end
    end
})

local Noclip9 = TabHandles.Noclip:Toggle({
    Title = "Noclip Drift",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip9 = v
        while _G.Noclip9 do
            task.wait()
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(5),0)
        end
    end
})

local Noclip10 = TabHandles.Noclip:Toggle({
    Title = "Noclip Spin",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.Noclip10 = v
        while _G.Noclip10 do
            task.wait()
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(15),0)
        end
    end
})

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer

_G.FlyUpAllTime = false
_G.FlyUpNightOnly = false

local ToggleAllTime = TabHandles.FlyUp:Toggle({
    Title = "Fly Up (All Time)",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.FlyUpAllTime = v
        local character = player.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        humanoid.PlatformStand = v

        if v then
            task.spawn(function()
                while _G.FlyUpAllTime do
                    local ray = Ray.new(hrp.Position, Vector3.new(0, -1000, 0))
                    local part, pos = workspace:FindPartOnRay(ray, hrp.Parent)
                    local targetY = (part and pos.Y or hrp.Position.Y) + 300
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
                    task.wait()
                end
                humanoid.PlatformStand = false
            end)
        end
    end
})

local ToggleNightOnly = TabHandles.FlyUp:Toggle({
    Title = "Fly Up (Night Only)",
    Locked = false,
    Value = false,
    Callback = function(v)
        _G.FlyUpNightOnly = v
        local character = player.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        humanoid.PlatformStand = v

        if v then
            task.spawn(function()
                while _G.FlyUpNightOnly do
                    local currentTime = Lighting.ClockTime
                    if currentTime >= 18 or currentTime < 6 then
                        local ray = Ray.new(hrp.Position, Vector3.new(0, -1000, 0))
                        local part, pos = workspace:FindPartOnRay(ray, hrp.Parent)
                        local targetY = (part and pos.Y or hrp.Position.Y) + 300
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
                    end
                    task.wait()
                end
                humanoid.PlatformStand = false
            end)
        end
    end
})    ChestFinder = tabs.Chest:AddSection({Title = "Chest Detection", Description = "Find and teleport to chests", Defualt = true, Locked = false}),
    HitboxControls = tabs.Hitbox:AddSection({Title = "Hitbox Expansion", Description = "Expand enemy hitboxes", Defualt = true, Locked = false}),
    MiscFeatures = tabs.Misc:AddSection({Title = "Miscellaneous", Description = "Various utility features", Defualt = true, Locked = false}),
    Performance = tabs.Misc:AddSection({Title = "Performance", Description = "FPS and performance tools", Defualt = false, Locked = false}),
}

-- Variables
local var = {}
local selectedItemToBring = {}
local selectedPosition = {}
local selectedChestToTeleport = {}
local selectedScrapItem = {}
local selectedScrapPosition = {}
local selectedFuelItem = {}
local selectedFuelPosition = {}
local selectedFoodItem = {}

-- Auto Eat Variables
local autoEatActive = false
local autoEatThreshold = 30
local maxHunger = 200

-- Auto Drag Variables
local autoDragActive = false
local autoDragScrapActive = false
local autoDragFuelActive = false

-- Initialize welcome paragraph
var.WelcomeParagraph = sections.Welcome:AddParagraph({
    Title = gradient("Loading..."), 
    Description = "Please wait..\nIf you've been stuck on this for a long time please join our discord and report it.\nYou could also try:\n- Re-execute\n- Rejoin"
})

var.WelcomeParagraph:SetTitle(gradient("Welcome to Avantrix SCRIPTS!"))
var.WelcomeParagraph:SetDesc([[<font color="rgb(255,255,255)">NEWS:</font>
[+] Auto Eat System Added
[+] Chest Finder System Added
[+] Teleport to Chest Locations
[+] Scrappable Items Management

<b><font color='rgb(255, 255, 255)'>----------------------------------------[Features]--------------------------------------</font></b>

<font color="rgb(255,255,255)">Version:</font> ]] .. formatVersion(LRM_ScriptVersion) .. [[

<font color="rgb(255,255,255)">Features:</font>
• Kill aura (attacks all mobs simultaneously with minimal delay)
• Auto Eat System (continues until max hunger)
• Teleportation System
• Item Bringing/Collection to Multiple Destinations
• Auto Detect Items from workspace
• Auto Drag Items Loop to Multiple Destinations
• Scrappable Items Management
• Auto Drag Scrap Items Loop to Multiple Destinations
• Fuel Items Management
• Auto Drag Fuel Items Loop to Multiple Destinations
• Chest Finder & Teleport System
• Hitbox Expansion
• Speed Hack
• FPS/Ping Display
• Performance Optimization

<font color="rgb(255,255,255)">Instructions:</font>
1. Configure your preferences in each tab
2. Enable desired features
3. Use Auto Eat to manage hunger automatically until max
4. Use Auto Detect Items to find and drag items in workspace
5. Use Scrap Items to manage and drag scrappable items
6. Use Fuel Items to manage and drag fuel items
7. Use Chest Finder to locate and teleport to chests
8. Use responsibly to avoid detection

<font color="rgb(255,255,255)">Discord:</font> discord.gg/cF8YeDPt2G]])

-- Add Discord button
sections.Welcome:AddButton({
    Title = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/cF8YeDPt2G")
        lib:Dialog({
            Title = "Success",
            Content = "Discord link copied to clipboard!",
            Buttons = {
                {
                    Title = "OK",
                    Variant = "Primary",
                    Callback = function() end,
                }
            }
        })
    end,
})

-- Game Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local infHungerActive = false
local ToolDamageObject = ReplicatedStorage.RemoteEvents.ToolDamageObject
local RequestConsumeItem = ReplicatedStorage.RemoteEvents.RequestConsumeItem
local RequestStartDraggingItem = ReplicatedStorage.RemoteEvents.RequestStartDraggingItem
local StopDraggingItem = ReplicatedStorage.RemoteEvents.StopDraggingItem
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local itemsFolder = workspace:WaitForChild("Items")
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

-- Main Farm Section - IMPROVED KILL AURA
local killAuraActive = false
local killAuraRange = 100
local killAuraSpeed = 0.5

local safezoneBaseplates = {}
local baseplateSize = Vector3.new(2048, 5, 2048)
local baseY = 130
local centerPos = Vector3.new(0, baseY, 0) -- original center

for dx = -1, 1 do
    for dz = -1, 1 do
        local pos = centerPos + Vector3.new(dx * baseplateSize.X, 0, dz * baseplateSize.Z)
        local baseplate = Instance.new("Part")
        baseplate.Name = "SafeZoneBaseplate"
        baseplate.Size = baseplateSize
        baseplate.Position = pos
        baseplate.Anchored = true
        baseplate.CanCollide = true
        baseplate.Transparency = 1
        baseplate.Color = Color3.fromRGB(255, 255, 255)
        baseplate.Parent = workspace
        table.insert(safezoneBaseplates, baseplate)
    end
end

local function teleportToTarget(cf, duration)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if duration and duration > 0 then
        local ts = game:GetService("TweenService")
        local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local goal = { CFrame = cf }
        local tween = ts:Create(hrp, info, goal)
        tween:Play()
    else
        hrp.CFrame = cf
    end
end

local function stringToCFrame(str)
    local x, y, z = str:match("([^,]+),%s*([^,]+),%s*([^,]+)")
    return CFrame.new(tonumber(x), tonumber(y), tonumber(z))
end

local storyCoords = {
    { "[campsite] camp site", "0, 8, -0"},
    { "[safezone] safe zone", "0, 140, -0" }
}

local toolsDamageIDs = {
    ["Old Axe"] = "1_8982038982",
    ["Good Axe"] = "112_8982038982",
    ["Strong Axe"] = "116_8982038982",
    ["Chainsaw"] = "647_8992824875",
    ["Spear"] = "196_8999010016"
}

local function getAnyToolWithDamageID()
    for toolName, damageID in pairs(toolsDamageIDs) do
        local tool = player.Inventory:FindFirstChild(toolName)
        if tool then
            return tool, damageID
        end
    end
    return nil, nil
end

local function getEquippedWeapon()
    local character = LocalPlayer.Character
    if character then
        for _, child in pairs(character:GetChildren()) do
            if child:IsA("Tool") and child:GetAttribute("WeaponDamage") then
                return child
            end
        end
    end
    return nil
end

local function getAllWeapons()
    local weapons = {}
    local player = Players.LocalPlayer
    local inventory = player:FindFirstChild("Inventory")
    if inventory then
        for _, item in pairs(inventory:GetChildren()) do
            if item:GetAttribute("WeaponDamage") then
                table.insert(weapons, item)
            end
        end
    end
    return weapons
end

-- Auto Eat Functions
local function getCurrentHunger()
    local player = LocalPlayer
    local hunger = player:GetAttribute("Hunger") or 0
    return hunger
end

local function getFoodItems()
    local foodItems = {"Apple","Carrot", "Berry", "Cooked Morsel", "Cooked Steak"}
    table.sort(foodItems)
    return foodItems
end

local function findFoodItem(foodName)
    if not foodName then return {} end
    local itemsFolder = workspace:FindFirstChild("Items")
    local foundItems = {}
    if itemsFolder then
        for _, item in pairs(itemsFolder:GetChildren()) do
            if item.Name == foodName then
                table.insert(foundItems, item)
            end
        end
    end
    return foundItems
end

local function autoEatLoop()
    task.spawn(function()
        while autoEatActive do
            local currentHunger = getCurrentHunger()
            
            if currentHunger <= autoEatThreshold and #selectedFoodItem > 0 then
                while currentHunger < maxHunger and autoEatActive do
                    local ateSomething = false
                    for _, foodName in ipairs(selectedFoodItem) do
                        local foodItems = findFoodItem(foodName)
                        for _, food in ipairs(foodItems) do
                            if food and food.Parent then
                                pcall(function()
                                    RequestConsumeItem:InvokeServer(food)
                                    ateSomething = true
                                end)
                                task.wait(0.0000005)
                                currentHunger = getCurrentHunger()
                                if currentHunger >= maxHunger then
                                    break
                                end
                            end
                        end
                        if currentHunger >= maxHunger then
                            break
                        end
                    end
                    if not ateSomething then
                        break
                    end
                    task.wait(0.000001)
                end
            end
            task.wait(0.000001)
        end
    end)
end

-- Function to get all items from workspace.Items
local function getAllItemsFromWorkspace()
    local items = {}
    local itemsFolder = workspace:FindFirstChild("Items")
    if itemsFolder then
        for _, item in pairs(itemsFolder:GetChildren()) do
            if not table.find(items, item.Name) then
                table.insert(items, item.Name)
            end
        end
    end
    table.sort(items)
    return items
end



-- Function to get scrappable items
local function getScrappableItems()
    local scrapItems = {"UFO Junk", "UFO Component", "Old Car Engine", "Broken Fan", "Old Microwave", "Bolt", "Log", "Cultist Gem", "Sheet Metal", "Old Radio","Tyre","Washing Machine", "Cultist Experiment", "Cultist Component", "Gem of the Forest Fragment", "Broken Microwave"}
    table.sort(scrapItems)
    return scrapItems
end



-- Function to get fuel items
local function getFuelItems()
    local fuelItems = {"Log", "Coal", "Fuel Canister", "Oil Barrel", "Biofuel"}
    table.sort(fuelItems)
    return fuelItems
end

-- Function to get all chests from workspace
local function getAllChestsFromWorkspace()
    local chests = {}
    local chestsData = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("chest") or obj.Name:lower():find("crate") or obj.Name:lower():find("box")) then
            local position = nil
            local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
            
            if rootPart then
                position = rootPart.Position
                local displayName = obj.Name .. " (" .. math.floor(position.X) .. ", " .. math.floor(position.Y) .. ", " .. math.floor(position.Z) .. ")"
                
                if not table.find(chests, displayName) then
                    table.insert(chests, displayName)
                    chestsData[displayName] = {
                        model = obj,
                        position = position,
                        name = obj.Name
                    }
                end
            end
        end
    end
    
    table.sort(chests)
    return chests, chestsData
end

local function moveItemToPos(item, position)
    if not item or not item:IsDescendantOf(workspace) then return end

    local part = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")
    if not part then return end

    -- Pastikan PrimaryPart diset
    if not item.PrimaryPart then
        pcall(function() item.PrimaryPart = part end)
    end

    -- Tunggu sampai item benar-benar ready
    local function waitForPhysics()
        local start = tick()
        repeat
            task.wait()
        until part:IsDescendantOf(workspace) and part:IsA("BasePart") and part:IsDescendantOf(item) or tick() - start > 3
    end

    waitForPhysics()

    -- Coba ambil ownership
    pcall(function()
        remoteEvents.RequestStartDraggingItem:FireServer(item)
    end)

    task.wait(0.1)

    -- Coba set posisi
    pcall(function()
        if item.PrimaryPart then
            item:SetPrimaryPartCFrame(CFrame.new(position))
        end
    end)

    task.wait(0.1)

    -- Hentikan dragging
    pcall(function()
        remoteEvents.StopDraggingItem:FireServer(item)
    end)
end


-- Modified function for bringing items using moveItemToPos
local function bringItemsByName(names, positions)
    local count = 0
    if not names or #names == 0 or not positions or #positions == 0 then
        return 0
    end

    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        return 0
    end

    for _, item in ipairs(itemsFolder:GetChildren()) do
        for _, name in ipairs(names) do
            if item.Name == name then
                for _, position in ipairs(positions) do
                    local targetPosition
                    if position == "LocalPlayer" then
                        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            return 0
                        end
                        targetPosition = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
                    elseif position == "Campfire" then
                        targetPosition = Vector3.new(0, 19, 0)
                    elseif position == "Scrapper" then
                        local scrapper = workspace.Map.Campground.Scrapper
                        if scrapper and scrapper:FindFirstChild("GlowEffect") then
                            targetPosition = scrapper.GlowEffect.Position + Vector3.new(0, 19, 0)
                        else
                            return 0
                        end
                    elseif position == "Freezer" then
                        local freezer = workspace:FindFirstChild("Structures") and workspace.Structures:FindFirstChild("Freezer")
                        if freezer and freezer:IsA("Model") then
                            local autoStack = freezer:FindFirstChild("AutoStack")
                            if autoStack then
                                local touchZone = autoStack:FindFirstChild("TouchZone")
                                if touchZone and touchZone:IsA("BasePart") then
                                    targetPosition = touchZone.Position + Vector3.new(0, 3, 0)
                                else
                                    return 0
                                end
                            else
                                return 0
                            end
                        else
                            return 0
                        end
                    else
                        return 0
                    end
                    moveItemToPos(item, targetPosition)
                    count = count + 1
                    task.wait(0.1)
                end
            end
        end
    end
    return count
end

-- Modified function for drag and drop
local function dragAndDropItem(itemNames, positions)
    if not itemNames or #itemNames == 0 or not positions or #positions == 0 then
        return
    end

    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        return
    end

    for _, item in ipairs(itemsFolder:GetChildren()) do
        for _, itemName in ipairs(itemNames) do
            if item.Name == itemName then
                for _, position in ipairs(positions) do
                    local targetPosition
                    if position == "LocalPlayer" then
                        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            return
                        end
                        targetPosition = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
                    elseif position == "Campfire" then
                        targetPosition = Vector3.new(0, 19, 0)
                    elseif position == "Scrapper" then
                        local scrapper = workspace.Map.Campground.Scrapper
                        if scrapper and scrapper:FindFirstChild("GlowEffect") then
                            targetPosition = scrapper.GlowEffect.Position + Vector3.new(0, 19, 0)
                        else
                            return
                        end
                    elseif position == "Freezer" then
                        local freezer = workspace:FindFirstChild("Structures") and workspace.Structures:FindFirstChild("Freezer")
                        if freezer and freezer:IsA("Model") then
                            local autoStack = freezer:FindFirstChild("AutoStack")
                            if autoStack then
                                local touchZone = autoStack:FindFirstChild("TouchZone")
                                if touchZone and touchZone:IsA("BasePart") then
                                    targetPosition = touchZone.Position + Vector3.new(0, 3, 0)
                                else
                                    return
                                end
                            else
                                return
                            end
                        else
                            return
                        end
                    else
                        return
                    end
                    moveItemToPos(item, targetPosition)
                    task.wait(0.1)
                end
            end
        end
    end
end

-- Auto drag loop for all items
local function autoDragLoop()
    task.spawn(function()
        while autoDragActive do
            if #selectedItemToBring > 0 and #selectedPosition > 0 then
                dragAndDropItem(selectedItemToBring, selectedPosition)
            else
                autoDragActive = false
                sections.AutoDetectItems:GetToggle("AutoDragItems"):Set(false)
                break
            end
            task.wait(0.1)
        end
    end)
end

-- Auto drag loop for scrap items
local function autoDragScrapLoop()
    task.spawn(function()
        while autoDragScrapActive do
            if #selectedScrapItem > 0 and #selectedScrapPosition > 0 then
                dragAndDropItem(selectedScrapItem, selectedScrapPosition)
            else
                autoDragScrapActive = false
                sections.ScrapItems:GetToggle("AutoDragScrapItems"):Set(false)
                break
            end
            task.wait(0.1)
        end
    end)
end

-- Auto drag loop for fuel items
local function autoDragFuelLoop()
    task.spawn(function()
        while autoDragFuelActive do
            if #selectedFuelItem > 0 and #selectedFuelPosition > 0 then
                dragAndDropItem(selectedFuelItem, selectedFuelPosition)
            else
                autoDragFuelActive = false
                sections.FuelItems:GetToggle("AutoDragFuelItems"):Set(false)
                break
            end
            task.wait(0.1)
        end
    end)
end

local function equipTool(tool)
    if tool then
        RemoteEvents.EquipItemHandle:FireServer("FireAllClients", tool)
    end
end

local function unequipTool(tool)
    if tool then
        RemoteEvents.UnequipItemHandle:FireServer("FireAllClients", tool)
    end
end

-- Modified Kill Aura to attack all mobs simultaneously with minimal delay
local function killAuraLoop()
    while killAuraActive do
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, damageID = getAnyToolWithDamageID()
            if tool and damageID then
                equipTool(tool)
                local mobs = Workspace.Characters:GetChildren()
                for _, mob in ipairs(mobs) do
                    if mob:IsA("Model") then
                        local part = mob:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= killAuraRange then
                            pcall(function()
                                RemoteEvents.ToolDamageObject:InvokeServer(
                                    mob,
                                    tool,
                                    damageID,
                                    CFrame.new(part.Position)
                                )
                            end)
                        end
                    end
                end
            else
                warn("No supported tool found in inventory")
                task.wait(0.03)
            end
        else
            task.wait(0.05)
        end
        task.wait(0.03) -- Minimal delay for next loop iteration
    end
end

local originalTreeCFrames = {}
local treesBrought = false

local function getAllSmallTrees()
    local trees = {}
    local function scan(folder)
        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("Model") and obj.Name == "Small Tree" then
                table.insert(trees, obj)
            end
        end
    end

    local map = Workspace:FindFirstChild("Map")
    if map then
        if map:FindFirstChild("Foliage") then scan(map.Foliage) end
        if map:FindFirstChild("Landmarks") then scan(map.Landmarks) end
    end
    return trees
end

local function findTrunk(tree)
    for _, part in ipairs(tree:GetDescendants()) do
        if part:IsA("BasePart") and part.Name == "Trunk" then return part end
    end
end

local function bringAllTrees()
    local target = CFrame.new(rootPart.Position + rootPart.CFrame.LookVector * 10)
    for _, tree in ipairs(getAllSmallTrees()) do
        local trunk = findTrunk(tree)
        if trunk then
            if not originalTreeCFrames[tree] then originalTreeCFrames[tree] = trunk.CFrame end
            tree.PrimaryPart = trunk
            trunk.Anchored = false
            trunk.CanCollide = false
            task.wait()
            tree:SetPrimaryPartCFrame(target + Vector3.new(math.random(-5,5), 0, math.random(-5,5)))
            trunk.Anchored = true
        end
    end
    treesBrought = true
end

local function restoreTrees()
    for tree, cframe in pairs(originalTreeCFrames) do
        local trunk = findTrunk(tree)
        if trunk then
            tree.PrimaryPart = trunk
            tree:SetPrimaryPartCFrame(cframe)
            trunk.Anchored = true
            trunk.CanCollide = true
        end
    end
    originalTreeCFrames = {}
    treesBrought = false
end

sections.MainFarm:AddToggle("KillAura", {
    Title = "Kill Aura",
    Default = false,
    Description = "Simultaneously attack ALL nearby animals with equipped weapon",
    Callback = function(state)
        killAuraActive = state
        if state then
            task.spawn(killAuraLoop)
        else
            local tool, _ = getAnyToolWithDamageID()
            unequipTool(tool)
        end
    end,
})

sections.MainFarm:AddSlider("KillAuraRange", {
    Title = "Kill Aura Range",
    Description = "Range to detect and attack animals",
    Default = killAuraRange,
    Min = 5,
    Max = 500,
    Increment = 1,
    Callback = function(value)
        killAuraRange = value
    end,
})

sections.MainFarm:AddButton({
    Title = "Show All Weapons",
    Description = "Display information about all detected weapons",
    Callback = function()
        local weapons = getAllWeapons()
        local equippedWeapon = getEquippedWeapon()
        if #weapons > 0 then
            local weaponInfo = "Found " .. #weapons .. " weapon(s):\n\n"
            for i, weapon in pairs(weapons) do
                local damage = weapon:GetAttribute("WeaponDamage") or "Unknown"
                local equippedStatus = equippedWeapon and equippedWeapon == weapon and " (Equipped)" or ""
                weaponInfo = weaponInfo .. i .. ". " .. weapon.Name .. " (Damage: " .. tostring(damage) .. ")" .. equippedStatus .. "\n"
            end
            lib:Dialog({
                Title = "All Weapons",
                Content = weaponInfo,
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        else
            lib:Dialog({
                Title = "No Weapon",
                Content = "No weapons with WeaponDamage attribute found in inventory!",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        end
    end,
})
autoBreakEnabled = false

sections.MainFarm:AddToggle("KillAura", {
    Title = "Bring All Trees",
    Default = false,
    Description = "Simultaneously bring all small trees to your location",
    Callback = function(state)
    autoBreakEnabled = state
    if state and not treesBrought then
        bringAllTrees()
    elseif not state and treesBrought then
        restoreTrees()
    end
    end,
})




local toggleActive = false

sections.MainFarm:AddToggle("TweenToBoundaries", {
    Title = "Tween Player to Boundary Parts",
    Default = false,
    Description = "Tween LocalPlayer to each part in Boundaries one by one.",
    Callback = function(state)
        toggleActive = state

        if state then
            task.spawn(function()
                local boundaries = workspace:WaitForChild("Map"):WaitForChild("Boundaries")
                for _, part in ipairs(boundaries:GetDescendants()) do
                    if not toggleActive then break end
                    if part:IsA("BasePart") then
                        teleportToTarget(CFrame.new(part.Position + Vector3.new(0, 5, 0)), 0.4)
                        task.wait(0.5)
                    end
                end
            end)
        end
    end,
})

-- Auto Eat Section
local foodDropdown = sections.AutoEat:AddDropdown("FoodSelect", {
    Title = "Select Food to Eat",
    Description = "Choose food items for auto eating",
    Options = getFoodItems(),
    Default = {},
    PlaceHolder = "Select food",
    Multiple = true,
    Callback = function(selected)
        selectedFoodItem = selected or {}
    end
})

sections.AutoEat:AddButton({
    Title = "Refresh Food List",
    Description = "Update the dropdown with current food items",
    Callback = function()
        local foodItems = getFoodItems()
        selectedFoodItem = {}
        if #foodItems > 0 then
            foodDropdown:Refresh(foodItems, true)
            lib:Dialog({
                Title = "Food List Refreshed",
                Content = "Successfully refreshed. Found " .. #foodItems .. " food items.\nPlease reselect food items from the dropdown.",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        else
            foodDropdown:Refresh({}, true)
            lib:Dialog({
                Title = "No Food Items",
                Content = "No food items found in workspace!",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        end
    end
})

sections.AutoEat:AddToggle("AutoEat", {
    Title = "Auto Eat",
    Default = false,
    Description = "Automatically eat selected food when hunger is low until max hunger",
    Callback = function(value)
        autoEatActive = value
        if value then
            if #selectedFoodItem == 0 then
                autoEatActive = false
                sections.AutoEat:GetToggle("AutoEat"):Set(false)
                lib:Dialog({
                    Title = "Error",
                    Content = "Please select at least one food item first!",
                    Buttons = {
                        {
                            Title = "OK",
                            Variant = "Primary",
                            Callback = function() end,
                        }
                    }
                })
                return
            end
            autoEatLoop()
            lib:Dialog({
                Title = "Auto Eat Enabled",
                Content = "Auto eat will activate when hunger drops to " .. autoEatThreshold .. " or below.\nIt will eat until hunger reaches " .. maxHunger .. ".",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        end
    end,
})

sections.AutoEat:AddSlider("EatThreshold", {
    Title = "Auto Eat Threshold",
    Description = "Hunger level to start auto eating",
    Default = 30,
    Min = 0,
    Max = maxHunger,
    Increment = 5,
    Callback = function(value)
        autoEatThreshold = math.clamp(value, 0, maxHunger)
    end,
})

sections.AutoEat:AddButton({
    Title = "Check Current Hunger",
    Description = "Display current hunger level",
    Callback = function()
        local currentHunger = getCurrentHunger()
        local status = ""
        if currentHunger <= autoEatThreshold then
            status = " (Will auto eat until max)"
        elseif currentHunger >= maxHunger then
            status = " (Full)"
        else
            status = " (Normal)"
        end
        lib:Dialog({
            Title = "Hunger Status",
            Content = "Current Hunger: " .. currentHunger .. "/" .. maxHunger .. status .. "\n\nAuto Eat Threshold: " .. autoEatThreshold .. "\nSelected Food: " .. table.concat(selectedFoodItem, ", "),
            Buttons = {
                {
                    Title = "OK",
                    Variant = "Primary",
                    Callback = function() end,
                }
            }
        })
    end,
})


sections.TeleportControls:AddButton({
    Title = "Safe Zone",
    Description = "Teleport to Safe Zone location",
    Callback = function()
        for _, entry in ipairs(storyCoords) do
            local name, coord = entry[1], entry[2]
            if name:lower():find("safezone") then
                teleportToTarget(stringToCFrame(coord), 0.1)
                break -- stop setelah teleport
            end
        end
    end,
})
-- Teleport Controls Section
sections.TeleportControls:AddButton({
    Title = "Teleport to Camp",
    Description = "Teleport to the camp location",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(
                13.287363052368164, 3.999999761581421, 0.36212217807769775,
                0.6022269129753113, -2.275036159460342e-08, 0.7983249425888062,
                6.430457055728311e-09, 1, 2.364672191390582e-08,
                -0.7983249425888062, -9.1070981866892e-09, 0.6022269129753113
            )
        end
    end,
})

sections.TeleportControls:AddButton({
    Title = "Teleport to Trader",
    Description = "Teleport to the trader location",
    Callback = function()
        local pos = Vector3.new(-37.08, 3.98, -16.33)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end,
})

sections.TeleportControls:AddButton({
    Title = "TP to Random Tree",
    Description = "Teleport to a random tree",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart", 3)
        if not hrp then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end
        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end

        local trees = {}
        for _, obj in ipairs(foliage:GetChildren()) do
            if obj.Name == "Small Tree" and obj:IsA("Model") then
                local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                if trunk then
                    table.insert(trees, trunk)
                end
            end
        end

        if #trees > 0 then
            local trunk = trees[math.random(1, #trees)]
            local treeCFrame = trunk.CFrame
            local rightVector = treeCFrame.RightVector
            local targetPosition = treeCFrame.Position + rightVector * 3
            hrp.CFrame = CFrame.new(targetPosition)
        end
    end,
})

-- Bring Items Section
sections.BringItems:AddButton({
    Title = "Bring Everything",
    Description = "Bring all items to your location",
    Callback = function()
        local count = 0
        for _, item in ipairs(workspace.Items:GetChildren()) do
            local targetPosition = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
            moveItemToPos(item, targetPosition)
            count = count + 1
            task.wait(0.1)
        end
        lib:Dialog({
            Title = "Success",
            Content = "Brought " .. count .. " items to your location!",
            Buttons = {
                {
                    Title = "OK",
                    Variant = "Primary",
                    Callback = function() end,
                }
            }
        })
    end,
})

sections.BringItems:AddButton({
    Title = "Auto Cook Meat",
    Description = "Bring meat to campfire for cooking",
    Callback = function()
        local campfirePos = Vector3.new(1.87, 4.33, -3.67)
        local count = 0
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") or item:IsA("BasePart") then
                local name = item.Name:lower()
                if name:find("meat") then
                    local targetPosition = campfirePos + Vector3.new(math.random(-2, 2), 0.5, math.random(-2, 2))
                    moveItemToPos(item, targetPosition)
                    count = count + 1
                    task.wait(0.1)
                end
            end
        end
        lib:Dialog({
            Title = "Success",
            Content = "Brought " .. count .. " meat items to campfire!",
            Buttons = {
                {
                    Title = "OK",
                    Variant = "Primary",
                    Callback = function() end,
                }
            }
        })
    end,
})

sections.BringItems:AddButton({
    Title = "Bring Lost Child",
    Description = "Bring lost child NPCs",
    Callback = function()
        local count = 0
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name:lower():find("lost") and model:FindFirstChild("HumanoidRootPart") then
                local targetPosition = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 2, 0)
                moveItemToPos(model, targetPosition)
                count = count + 1
                task.wait(0.1)
            end
        end
    end,
})

-- Auto Detect Items Section
local itemDropdown = sections.AutoDetectItems:AddDropdown("ItemSelect", {
    Title = "Select Items to Bring",
    Description = "Choose items from workspace.Items",
    Options = getAllItemsFromWorkspace(),
    Default = {},
    PlaceHolder = "Select items",
    Multiple = true,
    Callback = function(selected)
        selectedItemToBring = selected or {}
    end
})

local positionDropdown = sections.AutoDetectItems:AddDropdown("PositionSelect", {
    Title = "Select Destinations",
    Description = "Choose where to bring the selected items",
    Options = {"LocalPlayer", "Campfire", "Scrapper", "Freezer"},
    Default = {"LocalPlayer"},
    PlaceHolder = "Select positions",
    Multiple = true,
    Callback = function(selected)
        selectedPosition = selected or {"LocalPlayer"}
    end
})

sections.AutoDetectItems:AddToggle("AutoDragItems", {
    Title = "Auto Drag Items",
    Default = false,
    Description = "Automatically drag and drop selected items to chosen positions",
    Callback = function(value)
        autoDragActive = value
        if value then
            if #selectedItemToBring == 0 or #selectedPosition == 0 then
                autoDragActive = false
                sections.AutoDetectItems:GetToggle("AutoDragItems"):Set(false)
                lib:Dialog({
                    Title = "Error",
                    Content = "Please select at least one item and position first!",
                    Buttons = {
                        {
                            Title = "OK",
                            Variant = "Primary",
                            Callback = function() end,
                        }
                    }
                })
                return
            end
            autoDragLoop()
        end
    end,
})

sections.AutoDetectItems:AddButton({
    Title = "Refresh Item List",
    Description = "Update the dropdown with current items in workspace",
    Callback = function()
        local items = getAllItemsFromWorkspace()
        selectedItemToBring = {}
        if #items > 0 then
            itemDropdown:Refresh(items, true)
            lib:Dialog({
                Title = "Items Refreshed",
                Content = "Successfully refreshed. Found " .. #items .. " items.\nPlease reselect items from the dropdown.",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        else
            itemDropdown:Refresh({}, true)
            lib:Dialog({
                Title = "No Items",
                Content = "No items found!",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        end
    end
})

sections.AutoDetectItems:AddButton({
    Title = "Bring Selected Items",
    Description = "Bring all instances of the selected items to selected positions",
    Callback = function()
        if #selectedItemToBring > 0 and #selectedPosition > 0 then
            local count = bringItemsByName(selectedItemToBring, selectedPosition)
            lib:Dialog({
                Title = "Success",
                Content = "Brought " .. count .. " items (" .. table.concat(selectedItemToBring, ", ") .. ") to " .. table.concat(selectedPosition, ", ") .. "!",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        else
            lib:Dialog({
                Title = "Error",
                Content = "Please select at least one item and position first!\nCurrent items: " .. table.concat(selectedItemToBring, ", ") .. "\nCurrent positions: " .. table.concat(selectedPosition, ", "),
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        end
    end,
})

-- Scrap Items Section
local scrapDropdown = sections.ScrapItems:AddDropdown("ScrapSelect", {
    Title = "Select Scrappable Items",
    Description = "Choose scrappable items from workspace.Items",
    Options = getScrappableItems(),
    Default = {},
    PlaceHolder = "Select scrap items",
    Multiple = true,
    Callback = function(selected)
        selectedScrapItem = selected or {}
    end
})

local scrapPositionDropdown = sections.ScrapItems:AddDropdown("ScrapPositionSelect", {
    Title = "Select Destinations",
    Description = "Choose where to bring the scrappable items",
    Options = {"Scrapper"},
    Default = {"Scrapper"},
    PlaceHolder = "Select positions",
    Multiple = true,
    Callback = function(selected)
        selectedScrapPosition = selected or {"Scrapper"}
    end
})

sections.ScrapItems:AddToggle("AutoDragScrapItems", {
    Title = "Auto Drag Scrap Items",
    Default = false,
    Description = "Automatically drag and drop selected scrap items to chosen positions",
    Callback = function(value)
        autoDragScrapActive = value
        if value then
            if #selectedScrapItem == 0 or #selectedScrapPosition == 0 then
                autoDragScrapActive = false
                sections.ScrapItems:GetToggle("AutoDragScrapItems"):Set(false)
                lib:Dialog({
                    Title = "Error",
                    Content = "Please select at least one scrap item and position first!",
                    Buttons = {
                        {
                            Title = "OK",
                            Variant = "Primary",
                            Callback = function() end,
                        }
                    }
                })
                return
            end
            autoDragScrapLoop()
        end
    end,
})

local scrapItems = getScrappableItems()
selectedScrapItem = {}
if #scrapItems > 0 then
    scrapDropdown:Refresh(scrapItems, true)
    else
    scrapDropdown:Refresh({}, true)
end
sections.ScrapItems:AddButton({
    Title = "Bring Selected Scrap Items",
    Description = "Bring all instances of the selected scrappable items",
    Callback = function()
        if #selectedScrapItem > 0 and #selectedScrapPosition > 0 then
            local count = bringItemsByName(selectedScrapItem, selectedScrapPosition)
            lib:Dialog({
                Title = "Success",
                Content = "Brought " .. count .. " scrappable items (" .. table.concat(selectedScrapItem, ", ") .. ") to " .. table.concat(selectedScrapPosition, ", ") .. "!",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        else
            lib:Dialog({
                Title = "Error",
                Content = "Please select at least one scrappable item and position first!\nCurrent items: " .. table.concat(selectedScrapItem, ", ") .. "\nCurrent positions: " .. table.concat(selectedScrapPosition, ", "),
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        end
    end,
})

-- Fuel Items Section
local fuelDropdown = sections.FuelItems:AddDropdown("FuelSelect", {
    Title = "Select Fuel Items",
    Description = "Choose fuel items from workspace.Items",
    Options = getFuelItems(),
    Default = {},
    PlaceHolder = "Select fuel items",
    Multiple = true,
    Callback = function(selected)
        selectedFuelItem = selected or {}
    end
})

local fuelPositionDropdown = sections.FuelItems:AddDropdown("FuelPositionSelect", {
    Title = "Select Destinations",
    Description = "Choose where to bring the fuel items",
    Options = {"Campfire", "Scrapper"},
    Default = {"Campfire"},
    PlaceHolder = "Select positions",
    Multiple = true,
    Callback = function(selected)
        selectedFuelPosition = selected or {"Campfire"}
    end
})

sections.FuelItems:AddToggle("AutoDragFuelItems", {
    Title = "Auto Drag Fuel Items",
    Default = false,
    Description = "Automatically drag and drop selected fuel items to chosen positions",
    Callback = function(value)
        autoDragFuelActive = value
        if value then
            if #selectedFuelItem == 0 or #selectedFuelPosition == 0 then
                autoDragFuelActive = false
                sections.FuelItems:GetToggle("AutoDragFuelItems"):Set(false)
                lib:Dialog({
                    Title = "Error",
                    Content = "Please select at least one fuel item and position first!",
                    Buttons = {
                        {
                            Title = "OK",
                            Variant = "Primary",
                            Callback = function() end,
                        }
                    }
                })
                return
            end
            autoDragFuelLoop()
        end
    end,
})
local fuelItems = getFuelItems()
selectedFuelItem = {}
if #fuelItems > 0 then
 fuelDropdown:Refresh(fuelItems, true)
else
 fuelDropdown:Refresh({}, true)
end


sections.FuelItems:AddButton({
    Title = "Bring Selected Fuel Items",
    Description = "Bring all instances of the selected fuel items",
    Callback = function()
        if #selectedFuelItem > 0 and #selectedFuelPosition > 0 then
            local count = bringItemsByName(selectedFuelItem, selectedFuelPosition)
            lib:Dialog({
                Title = "Success",
                Content = "Brought " .. count .. " fuel items (" .. table.concat(selectedFuelItem, ", ") .. ") to " .. table.concat(selectedFuelPosition, ", ") .. "!",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        else
            lib:Dialog({
                Title = "Error",
                Content = "Please select at least one fuel item and position first!\nCurrent items: " .. table.concat(selectedFuelItem, ", ") .. "\nCurrent positions: " .. table.concat(selectedFuelPosition, ", "),
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        end
    end,
})

-- Chest Finder Section
local chestDropdown
local chestsData = {}

chestDropdown = sections.ChestFinder:AddDropdown("ChestSelect", {
    Title = "Select Chests to Teleport",
    Description = "Choose chests from workspace to teleport to",
    Options = {},
    Default = {},
    PlaceHolder = "Select chests",
    Multiple = true,
    Callback = function(selected)
        selectedChestToTeleport = selected or {}
    end
})

sections.ChestFinder:AddButton({
    Title = "Refresh Chest List",
    Description = "Update the dropdown with current chests in workspace",
    Callback = function()
        local chests, chestData = getAllChestsFromWorkspace()
        chestsData = chestData
        selectedChestToTeleport = {}
        if #chests > 0 then
            chestDropdown:Refresh(chests, true)
            lib:Dialog({
                Title = "Chests Refreshed",
                Content = "Successfully refreshed. Found " .. #chests .. " chests.\nPlease select chests from the dropdown.",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        else
            chestDropdown:Refresh({}, true)
            lib:Dialog({
                Title = "No Chests",
                Content = "No chests found in workspace!",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        end
    end
})

sections.ChestFinder:AddButton({
    Title = "Teleport to Selected Chests",
    Description = "Teleport to the selected chest locations",
    Callback = function()
        if #selectedChestToTeleport > 0 and chestsData[selectedChestToTeleport[1]] then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                for _, chestName in ipairs(selectedChestToTeleport) do
                    local chestData = chestsData[chestName]
                    if chestData and chestData.position then
                        local teleportPosition = chestData.position + Vector3.new(0, 2, 3)
                        character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
                        task.wait(0.5)
                    end
                end
                lib:Dialog({
                    Title = "Success",
                    Content = "Teleported to selected chests!",
                    Buttons = {
                        {
                            Title = "OK",
                            Variant = "Primary",
                            Callback = function() end,
                        }
                    }
                })
            else
                lib:Dialog({
                    Title = "Error",
                    Content = "Could not teleport to chests. Character not found!",
                    Buttons = {
                        {
                            Title = "OK",
                            Variant = "Primary",
                            Callback = function() end,
                        }
                    }
                })
            end
        else
            lib:Dialog({
                Title = "Error",
                Content = "Please select at least one chest first!\nCurrent selection: " .. table.concat(selectedChestToTeleport, ", "),
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        end
    end,
})

sections.ChestFinder:AddButton({
    Title = "Teleport to Nearest Chest",
    Description = "Automatically teleport to the closest chest",
    Callback = function()
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            lib:Dialog({
                Title = "Error",
                Content = "Character not found!",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
            return
        end

        local playerPosition = character.HumanoidRootPart.Position
        local nearestChest = nil
        local nearestDistance = math.huge

        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("chest") or obj.Name:lower():find("crate") or obj.Name:lower():find("box")) then
                local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                if rootPart then
                    local distance = (rootPart.Position - playerPosition).Magnitude
                    if distance < nearestDistance then
                        nearestDistance = distance
                        nearestChest = {
                            model = obj,
                            position = rootPart.Position,
                            name = obj.Name
                        }
                    end
                end
            end
        end

        if nearestChest then
            local teleportPosition = nearestChest.position + Vector3.new(0, 2, 3)
            character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
            lib:Dialog({
                Title = "Success",
                Content = "Teleported to nearest chest: " .. nearestChest.name .. "\nDistance: " .. math.floor(nearestDistance) .. " studs",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        else
            lib:Dialog({
                Title = "Error",
                Content = "No chests found in workspace!",
                Buttons = {
                    {
                        Title = "OK",
                        Variant = "Primary",
                        Callback = function() end,
                    }
                }
            })
        end
    end,
})

-- Hitbox Controls Section
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

sections.HitboxControls:AddToggle("WolfHitbox", {
    Title = "Expand Wolf Hitbox",
    Default = false,
    Description = "Expand wolf enemy hitboxes",
    Callback = function(value)
        hitboxSettings.Wolf = value
    end,
})

sections.HitboxControls:AddToggle("BunnyHitbox", {
    Title = "Expand Bunny Hitbox",
    Default = false,
    Description = "Expand bunny enemy hitboxes",
    Callback = function(value)
        hitboxSettings.Bunny = value
    end,
})

sections.HitboxControls:AddToggle("CultistHitbox", {
    Title = "Expand Cultist Hitbox",
    Default = false,
    Description = "Expand cultist enemy hitboxes",
    Callback = function(value)
        hitboxSettings.Cultist = value
    end,
})

sections.HitboxControls:AddSlider("HitboxSize", {
    Title = "Hitbox Size",
    Description = "Size of expanded hitboxes",
    Default = 10,
    Min = 2,
    Max = 30,
    Increment = 1,
    Callback = function(value)
        hitboxSettings.Size = value
    end,
})

sections.HitboxControls:AddToggle("ShowHitbox", {
    Title = "Show Hitbox (Transparency)",
    Default = false,
    Description = "Make hitboxes visible",
    Callback = function(value)
        hitboxSettings.Show = value
    end,
})

-- Misc Features Section
getgenv().speedEnabled = false
getgenv().speedValue = 28

sections.MiscFeatures:AddToggle("SpeedHack", {
    Title = "Speed Hack",
    Default = false,
    Description = "Increase movement speed",
    Callback = function(value)
        getgenv().speedEnabled = value
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then 
            hum.WalkSpeed = value and getgenv().speedValue or 16 
        end
    end,
})

sections.MiscFeatures:AddSlider("SpeedValue", {
    Title = "Speed Value",
    Description = "Speed multiplier value",
    Default = 28,
    Min = 16,
    Max = 600,
    Increment = 1,
    Callback = function(value)
        getgenv().speedValue = value
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then 
                hum.WalkSpeed = value 
            end
        end
    end,
})

-- Performance Section
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

sections.Performance:AddToggle("ShowFPS", {
    Title = "Show FPS",
    Default = true,
    Description = "Display FPS counter",
    Callback = function(value)
        showFPS = value
        fpsText.Visible = value
    end,
})

sections.Performance:AddToggle("ShowPing", {
    Title = "Show Ping (ms)",
    Default = true,
    Description = "Display ping counter",
    Callback = function(value)
        showPing = value
        msText.Visible = value
    end,
})

sections.Performance:AddButton({
    Title = "FPS Boost",
    Description = "Apply performance optimizations",
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
        lib:Dialog({
            Title = "Success",
            Content = "FPS Boost has been applied successfully!",
            Buttons = {
                {
                    Title = "OK",
                    Variant = "Primary",
                    Callback = function() end,
                }
            }
        })
    end,
})

-- Config System
FlagsManager:SetLibrary(lib)
FlagsManager:SetIgnoreIndexes({})
FlagsManager:SetFolder("Avantrix/99NF")
FlagsManager:InitSaveSystem(tabs.Settings)
