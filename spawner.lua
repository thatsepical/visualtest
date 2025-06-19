local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")
local playerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

-- Load Spawner module
local Spawner
local success, err = pcall(function()
    Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/ataturk123/GardenSpawner/refs/heads/main/Spawner.lua"))()
end)

if not success then
    warn("Failed to load Spawner module: "..tostring(err))
    Spawner = {
        SpawnPet = function(name, weight, age) return true end,
        SpawnSeed = function(name) return true end,
        GetPets = function() return {"Bee", "Slime", "Chick", "Bat", "Pupper", "Mole"} end,
        GetSeeds = function() return {"Candy Blossom", "Sunflower", "Moonflower"} end
    }
end

-- UI Setup
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "PetSpawnerUI"
screenGui.ResetOnSpawn = false

-- Toggle Button
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 80, 0, 25)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Open UI"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 280, 0, 350) -- Slightly taller to accommodate header
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Draggable logic
local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
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

toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Header with proper spacing
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 90) -- Taller header
header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

-- Title (centered)
local title = Instance.new("TextLabel", header)
title.Text = "PET/SEED SPAWNER"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 10)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Center

-- Credit (centered below title)
local credit = Instance.new("TextLabel", header)
credit.Text = "by @zenxq"
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 0, 40)
credit.Font = Enum.Font.Gotham
credit.TextSize = 14
credit.TextColor3 = Color3.new(0.8, 0.8, 0.8)
credit.BackgroundTransparency = 1
credit.TextXAlignment = Enum.TextXAlignment.Center

-- Close Button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Tab Buttons Container (positioned lower)
local tabContainer = Instance.new("Frame", header)
tabContainer.Size = UDim2.new(1, -20, 0, 30)
tabContainer.Position = UDim2.new(0, 10, 0, 60) -- Positioned below credit
tabContainer.BackgroundTransparency = 1

-- Tab Buttons
local petTab = Instance.new("TextButton", tabContainer)
petTab.Text = "PETS"
petTab.Size = UDim2.new(0.5, -5, 1, 0)
petTab.Position = UDim2.new(0, 0, 0, 0)
petTab.Font = Enum.Font.GothamBold
petTab.TextColor3 = Color3.new(1, 1, 1)
petTab.TextSize = 14
petTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", petTab).CornerRadius = UDim.new(0, 6)

local seedTab = Instance.new("TextButton", tabContainer)
seedTab.Text = "SEEDS"
seedTab.Size = UDim2.new(0.5, -5, 1, 0)
seedTab.Position = UDim2.new(0.5, 5, 0, 0)
seedTab.Font = Enum.Font.GothamBold
seedTab.TextColor3 = Color3.new(1, 1, 1)
seedTab.TextSize = 14
seedTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", seedTab).CornerRadius = UDim.new(0, 6)

-- Tab Frames
local petTabFrame = Instance.new("Frame", mainFrame)
petTabFrame.Position = UDim2.new(0, 0, 0, 90) -- Adjusted for taller header
petTabFrame.Size = UDim2.new(1, 0, 1, -90)
petTabFrame.BackgroundTransparency = 1

local seedTabFrame = petTabFrame:Clone()
seedTabFrame.Parent = mainFrame
seedTabFrame.Visible = false

-- Helper functions for UI elements
local function createTextBox(parent, placeholder, position)
	local box = Instance.new("TextBox", parent)
	box.Size = UDim2.new(0.9, 0, 0, 30)
	box.Position = position
	box.PlaceholderText = placeholder
	box.Text = ""
	box.Font = Enum.Font.Gotham
	box.TextSize = 14
	box.TextColor3 = Color3.new(1, 1, 1)
	box.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
	return box
end

local function createButton(parent, text, position)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0.9, 0, 0, 30)
	btn.Position = position
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

-- PET Tab UI
local petNameBox = createTextBox(petTabFrame, "Pet Name", UDim2.new(0.05, 0, 0.05, 0))
local weightBox = createTextBox(petTabFrame, "Weight (kg)", UDim2.new(0.05, 0, 0.20, 0))
local ageBox = createTextBox(petTabFrame, "Age", UDim2.new(0.05, 0, 0.35, 0))

local spawnBtn = createButton(petTabFrame, "SPAWN PET", UDim2.new(0.05, 0, 0.50, 0))
local dupeBtn = createButton(petTabFrame, "DUPE PET", UDim2.new(0.05, 0, 0.65, 0))

-- SEED Tab UI
local seedScroll = Instance.new("ScrollingFrame", seedTabFrame)
seedScroll.Size = UDim2.new(1, 0, 1, 0)
seedScroll.BackgroundTransparency = 1
seedScroll.ScrollingDirection = Enum.ScrollingDirection.Y
seedScroll.ScrollBarThickness = 6
seedScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local seedButtonTemplate = Instance.new("TextButton")
seedButtonTemplate.Size = UDim2.new(0.9, 0, 0, 35)
seedButtonTemplate.Position = UDim2.new(0.05, 0, 0, 0)
seedButtonTemplate.Font = Enum.Font.Gotham
seedButtonTemplate.TextSize = 14
seedButtonTemplate.TextColor3 = Color3.new(1, 1, 1)
seedButtonTemplate.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", seedButtonTemplate).CornerRadius = UDim.new(0, 6)

local function setupSeedButtons()
    local seedNames = Spawner.GetSeeds() or {"Apple", "Avocado", "Bamboo", "Banana", "Beanstalk"}
    local buttonHeight = 40
    local padding = 5
    
    seedScroll.CanvasSize = UDim2.new(0, 0, 0, #seedNames * (buttonHeight + padding))
    
    for i, seedName in ipairs(seedNames) do
        local seedBtn = seedButtonTemplate:Clone()
        seedBtn.Parent = seedScroll
        seedBtn.Position = UDim2.new(0.05, 0, 0, (i-1)*(buttonHeight + padding))
        seedBtn.Text = seedName
        
        seedBtn.MouseButton1Click:Connect(function()
            local success, result = pcall(function()
                return Spawner.SpawnSeed(seedName)
            end)
            
            if not success then
                warn("Failed to spawn seed: "..tostring(result))
            else
                print("Successfully spawned seed:", seedName)
            end
        end)
    end
end

setupSeedButtons()

-- Tab Switching with visual feedback
petTab.MouseButton1Click:Connect(function()
	petTabFrame.Visible = true
	seedTabFrame.Visible = false
	petTab.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	seedTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

seedTab.MouseButton1Click:Connect(function()
	petTabFrame.Visible = false
	seedTabFrame.Visible = true
	seedTab.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	petTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

-- Initialize tabs
petTab.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
seedTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Spawn Pet Functionality
spawnBtn.MouseButton1Click:Connect(function()
    local petName = petNameBox.Text
    local petWeight = tonumber(weightBox.Text) or 1
    local petAge = tonumber(ageBox.Text) or 1
    
    if not petName or string.len(petName) < 2 then
        warn("Please enter a valid pet name")
        return
    end

    local success, result = pcall(function()
        return Spawner.SpawnPet(petName, petWeight, petAge)
    end)
    
    if not success then
        warn("Failed to spawn pet: "..tostring(result))
    else
        print("Successfully spawned pet:", petName)
    end
end)

-- Dupe Pet Functionality with animations
dupeBtn.MouseButton1Click:Connect(function()
    local player = game:GetService("Players").LocalPlayer
    local backpack = player:WaitForChild("Backpack")
    local char = player.Character or player.CharacterAdded:Wait()
    
    if not char then return end
    
    local tool = char:FindFirstChildOfClass("Tool") or backpack:FindFirstChildOfClass("Tool")
    if not tool then
        warn("No pet found equipped or in backpack")
        return
    end

    local fakeClone = tool:Clone()
    
    for _,v in pairs(fakeClone:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            if not (v.Name:match("Animate")) 
               and not (v.Name:match("Animation"))
               and not (v.Name:match("Animator"))
               and not (v.Name:match("Grip"))
               and not (v.Name:match("Control"))
               and not (v.Name:match("Motor")) then
                v:Destroy()
            end
        end
    end

    if fakeClone:FindFirstChildOfClass("Humanoid") then
        local humanoid = fakeClone:FindFirstChildOfClass("Humanoid")
        if not humanoid:FindFirstChildOfClass("Animator") then
            Instance.new("Animator").Parent = humanoid
        end
        
        local originalHumanoid = tool:FindFirstChildOfClass("Humanoid")
        if originalHumanoid and originalHumanoid:FindFirstChildOfClass("Animator") then
            for _,track in pairs(originalHumanoid.Animator:GetPlayingAnimationTracks()) do
                humanoid.Animator:LoadAnimation(track.Animation):Play()
            end
        end
    else
        local animateScript = tool:FindFirstChild("Animate") 
        if animateScript then
            animateScript:Clone().Parent = fakeClone
        end
        
        for _,anim in pairs(tool:GetDescendants()) do
            if anim:IsA("Animation") then
                anim:Clone().Parent = fakeClone
            end
        end
    end

    fakeClone.Enabled = true
    fakeClone.ManualActivationOnly = false
    fakeClone.RequiresHandle = true
    
    if fakeClone:FindFirstChild("CanBeDropped") then
        fakeClone.CanBeDropped = false
    end
    
    fakeClone.Name = tool.Name
    fakeClone.Parent = backpack

    task.wait(0.2)
    if char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid:EquipTool(fakeClone)
        
        task.wait(0.1)
        if fakeClone:FindFirstChildOfClass("Humanoid") then
            for _,track in pairs(fakeClone.Humanoid.Animator:GetPlayingAnimationTracks()) do
                track:Play()
            end
        end
    end
    
    print("Created animated duplicate of: "..tool.Name)
end)