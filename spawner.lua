local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")
local playerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

-- Load Spawner module
local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/ataturk123/GardenSpawner/refs/heads/main/Spawner.lua"))()

-- UI Setup
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "PetSpawnerUI"
screenGui.ResetOnSpawn = false

-- Toggle Button
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 70, 0, 22)
toggleButton.Position = UDim2.new(0, 5, 0, 5)
toggleButton.Text = "Open UI"
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextSize = 12
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 4)

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 260)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

-- Fixed Dragging
local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 6)

-- Title and Credit
local title = Instance.new("TextLabel", header)
title.Text = "PET/SEED SPAWNER"
title.Size = UDim2.new(1, -30, 0, 20)
title.Position = UDim2.new(0, 0, 0, 8)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Center

local credit = Instance.new("TextLabel", header)
credit.Text = "by @zenxq"
credit.Size = UDim2.new(1, -30, 0, 15)
credit.Position = UDim2.new(0, 0, 0, 28)
credit.Font = Enum.Font.Gotham
credit.TextSize = 11
credit.TextColor3 = Color3.new(0.8, 0.8, 0.8)
credit.BackgroundTransparency = 1
credit.TextXAlignment = Enum.TextXAlignment.Center

-- Fixed Close Button (Circular X)
local closeBtn = Instance.new("ImageButton", header)
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.Image = "rbxassetid://3926305904"
closeBtn.ImageRectOffset = Vector2.new(284, 4)
closeBtn.ImageRectSize = Vector2.new(24, 24)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
closeBtn.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- Tab Buttons
local tabContainer = Instance.new("Frame", header)
tabContainer.Size = UDim2.new(1, -20, 0, 22)
tabContainer.Position = UDim2.new(0, 10, 1, -25)
tabContainer.BackgroundTransparency = 1

local petTab = Instance.new("TextButton", tabContainer)
petTab.Text = "PETS"
petTab.Size = UDim2.new(0.5, -5, 1, 0)
petTab.Position = UDim2.new(0, 0, 0, 0)
petTab.Font = Enum.Font.GothamBold
petTab.TextColor3 = Color3.new(1, 1, 1)
petTab.TextSize = 12
petTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", petTab).CornerRadius = UDim.new(0, 4)

local seedTab = Instance.new("TextButton", tabContainer)
seedTab.Text = "SEEDS"
seedTab.Size = UDim2.new(0.5, -5, 1, 0)
seedTab.Position = UDim2.new(0.5, 5, 0, 0)
seedTab.Font = Enum.Font.GothamBold
seedTab.TextColor3 = Color3.new(1, 1, 1)
seedTab.TextSize = 12
seedTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", seedTab).CornerRadius = UDim.new(0, 4)

-- Tab Frames
local petTabFrame = Instance.new("Frame", mainFrame)
petTabFrame.Position = UDim2.new(0, 0, 0, 60)
petTabFrame.Size = UDim2.new(1, 0, 1, -60)
petTabFrame.BackgroundTransparency = 1

local seedTabFrame = petTabFrame:Clone()
seedTabFrame.Parent = mainFrame
seedTabFrame.Visible = false

-- PET Tab UI
local petNameBox = Instance.new("TextBox", petTabFrame)
petNameBox.Size = UDim2.new(0.9, 0, 0, 25)
petNameBox.Position = UDim2.new(0.05, 0, 0.05, 0)
petNameBox.PlaceholderText = "Pet Name"
petNameBox.Font = Enum.Font.Gotham
petNameBox.TextSize = 12
petNameBox.TextColor3 = Color3.new(1, 1, 1)
petNameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", petNameBox).CornerRadius = UDim.new(0, 4)

local weightBox = petNameBox:Clone()
weightBox.Parent = petTabFrame
weightBox.Position = UDim2.new(0.05, 0, 0.22, 0)
weightBox.PlaceholderText = "Weight (kg)"

local ageBox = petNameBox:Clone()
ageBox.Parent = petTabFrame
ageBox.Position = UDim2.new(0.05, 0, 0.39, 0)
ageBox.PlaceholderText = "Age"

local spawnBtn = Instance.new("TextButton", petTabFrame)
spawnBtn.Size = UDim2.new(0.9, 0, 0, 25)
spawnBtn.Position = UDim2.new(0.05, 0, 0.56, 0)
spawnBtn.Text = "SPAWN PET"
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextSize = 12
spawnBtn.TextColor3 = Color3.new(1, 1, 1)
spawnBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0, 4)

local dupeBtn = spawnBtn:Clone()
dupeBtn.Parent = petTabFrame
dupeBtn.Position = UDim2.new(0.05, 0, 0.73, 0)
dupeBtn.Text = "DUPE PET"

-- SEED Tab UI
local seedScroll = Instance.new("ScrollingFrame", seedTabFrame)
seedScroll.Size = UDim2.new(1, 0, 1, 0)
seedScroll.BackgroundTransparency = 1
seedScroll.ScrollingDirection = Enum.ScrollingDirection.Y
seedScroll.ScrollBarThickness = 4

local seedNames = Spawner.GetSeeds() or {"Apple", "Avocado", "Bamboo", "Banana", "Beanstalk"}
seedScroll.CanvasSize = UDim2.new(0, 0, 0, #seedNames * 32)

for i, seedName in ipairs(seedNames) do
    local seedBtn = Instance.new("TextButton")
    seedBtn.Size = UDim2.new(0.9, 0, 0, 28)
    seedBtn.Position = UDim2.new(0.05, 0, 0, (i-1)*32)
    seedBtn.Text = seedName
    seedBtn.Font = Enum.Font.Gotham
    seedBtn.TextSize = 12
    seedBtn.TextColor3 = Color3.new(1, 1, 1)
    seedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    seedBtn.Parent = seedScroll
    Instance.new("UICorner", seedBtn).CornerRadius = UDim.new(0, 4)
    
    seedBtn.MouseButton1Click:Connect(function()
        Spawner.SpawnSeed(seedName)
    end)
end

-- Tab Switching
petTab.MouseButton1Click:Connect(function()
    petTabFrame.Visible = true
    seedTabFrame.Visible = false
    petTab.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    seedTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

seedTab.MouseButton1Click:Connect(function()
    petTabFrame.Visible = false
    seedTabFrame.Visible = true
    seedTab.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    petTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Initialize tabs
petTab.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
seedTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- Spawn Pet Functionality
spawnBtn.MouseButton1Click:Connect(function()
    local petName = petNameBox.Text
    local petWeight = tonumber(weightBox.Text) or 1
    local petAge = tonumber(ageBox.Text) or 1
    
    if petName and #petName >= 2 then
        Spawner.SpawnPet(petName, petWeight, petAge)
    end
end)

-- Dupe Pet Functionality
dupeBtn.MouseButton1Click:Connect(function()
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool") or backpack:FindFirstChildOfClass("Tool")
    if not tool then return end

    local fakeClone = tool:Clone()
    
    -- Preserve animations
    if fakeClone:FindFirstChildOfClass("Humanoid") then
        local humanoid = fakeClone:FindFirstChildOfClass("Humanoid")
        if not humanoid:FindFirstChildOfClass("Animator") then
            Instance.new("Animator").Parent = humanoid
        end
    end

    fakeClone.Parent = backpack
    task.wait(0.1)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid:EquipTool(fakeClone)
    end
end)