local Spawner = loadstring(game:HttpGet("https://gitlab.com/darkiedarkie/dark/-/raw/main/Spawner.lua"))()

local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedPetSpawner"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(33, 34, 38)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "PET SPAWNER v3.0"
title.Size = UDim2.new(1, 0, 1, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = header

local petNameBox = Instance.new("TextBox")
petNameBox.Size = UDim2.new(0.9, 0, 0, 30)
petNameBox.Position = UDim2.new(0.05, 0, 0.2, 0)
petNameBox.PlaceholderText = "Enter Pet Name"
petNameBox.ClearTextOnFocus = false
petNameBox.Font = Enum.Font.SourceSans
petNameBox.TextSize = 14
petNameBox.TextColor3 = Color3.new(1,1,1)
petNameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
petNameBox.Parent = mainFrame

local weightBox = Instance.new("TextBox")
weightBox.Size = UDim2.new(0.4, 0, 0, 30)
weightBox.Position = UDim2.new(0.05, 0, 0.4, 0)
weightBox.PlaceholderText = "Weight"
weightBox.Text = "1"
weightBox.Font = Enum.Font.SourceSans
weightBox.TextSize = 14
weightBox.TextColor3 = Color3.new(1,1,1)
weightBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
weightBox.Parent = mainFrame

local ageBox = Instance.new("TextBox")
ageBox.Size = UDim2.new(0.4, 0, 0, 30)
ageBox.Position = UDim2.new(0.55, 0, 0.4, 0)
ageBox.PlaceholderText = "Age"
ageBox.Text = "1"
ageBox.Font = Enum.Font.SourceSans
ageBox.TextSize = 14
ageBox.TextColor3 = Color3.new(1,1,1)
ageBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
ageBox.Parent = mainFrame

local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(0.9, 0, 0, 35)
spawnBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
spawnBtn.Text = "SPAWN PET"
spawnBtn.Font = Enum.Font.SourceSansBold
spawnBtn.TextSize = 16
spawnBtn.TextColor3 = Color3.new(1,1,1)
spawnBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
spawnBtn.Parent = mainFrame

local dupeBtn = Instance.new("TextButton")
dupeBtn.Size = UDim2.new(0.9, 0, 0, 35)
dupeBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
dupeBtn.Text = "DUPLICATE PET"
dupeBtn.Font = Enum.Font.SourceSansBold
dupeBtn.TextSize = 16
dupeBtn.TextColor3 = Color3.new(1,1,1)
dupeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
dupeBtn.Parent = mainFrame

local function validateNumber(box)
    box:GetPropertyChangedSignal("Text"):Connect(function()
        box.Text = box.Text:gsub("[^%d]", "")
    end)
end

validateNumber(weightBox)
validateNumber(ageBox)

spawnBtn.MouseButton1Click:Connect(function()
    local petName = petNameBox.Text
    local weight = tonumber(weightBox.Text) or 1
    local age = tonumber(ageBox.Text) or 1
    
    if petName == "" then
        warn("Please enter a pet name")
        return
    end
    
    Spawner.SpawnPet(petName, weight, age)
end)

dupeBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    if not character then return end
    
    local tool = character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
    if not tool then
        warn("No pet found in inventory")
        return
    end
    
    local clone = tool:Clone()
    clone.Parent = player.Backpack
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)