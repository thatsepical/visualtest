local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")
local playerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

local Spawner
local success, err = pcall(function()
    Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/ataturk123/GardenSpawner/refs/heads/main/Spawner.lua"))()
end)

if not success then
    warn("Failed to load Spawner module: "..tostring(err))
    Spawner = {
        SpawnPet = function(name, weight, age)
            warn("Spawner not loaded - Using fallback for pet: "..name)
            return true
        end,
        SpawnSeed = function(name)
            warn("Spawner not loaded - Using fallback for seed: "..name)
            return true
        end,
        GetPets = function() return {"Bee", "Slime", "Chick", "Bat", "Pupper", "Mole"} end,
        GetSeeds = function() return {"Candy Blossom", "Sunflower", "Moonflower"} end
    }
end

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "PetSpawnerUI"
screenGui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 80, 0, 25)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Open UI"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 14
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 280)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
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

local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", header)
title.Text = "PET/SEED SPAWNER"
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 5)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

local credit = Instance.new("TextLabel", header)
credit.Text = "by @zenxq"
credit.Size = UDim2.new(1, 0, 0, 12)
credit.Position = UDim2.new(0, 0, 0, 22)
credit.Font = Enum.Font.SourceSans
credit.TextSize = 10
credit.TextColor3 = Color3.new(0.8, 0.8, 0.8)
credit.BackgroundTransparency = 1

local petTab = Instance.new("TextButton", header)
petTab.Text = "PET"
petTab.Size = UDim2.new(0.5, 0, 0, 20)
petTab.Position = UDim2.new(0, 0, 0, 35)
petTab.Font = Enum.Font.SourceSans
petTab.TextColor3 = Color3.new(1, 1, 1)
petTab.TextSize = 14
petTab.BackgroundTransparency = 1

local seedTab = Instance.new("TextButton", header)
seedTab.Text = "SEED"
seedTab.Size = UDim2.new(0.5, 0, 0, 20)
seedTab.Position = UDim2.new(0.5, 0, 0, 35)
seedTab.Font = Enum.Font.SourceSans
seedTab.TextColor3 = Color3.new(1, 1, 1)
seedTab.TextSize = 14
seedTab.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSans
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local petTabFrame = Instance.new("Frame", mainFrame)
petTabFrame.Position = UDim2.new(0, 0, 0, 55)
petTabFrame.Size = UDim2.new(1, 0, 1, -55)
petTabFrame.BackgroundTransparency = 1

local seedTabFrame = petTabFrame:Clone()
seedTabFrame.Parent = mainFrame
seedTabFrame.Visible = false

local function createTextBox(parent, placeholder, position)
	local box = Instance.new("TextBox", parent)
	box.Size = UDim2.new(0.9, 0, 0, 25)
	box.Position = position
	box.PlaceholderText = placeholder
	box.Text = ""
	box.Font = Enum.Font.SourceSans
	box.TextSize = 14
	box.TextColor3 = Color3.new(1, 1, 1)
	box.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
	box.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
	return box
end

local petNameBox = createTextBox(petTabFrame, "Pet Name", UDim2.new(0.05, 0, 0.05, 0))
local weightBox = createTextBox(petTabFrame, "Weight", UDim2.new(0.05, 0, 0.25, 0))
local ageBox = createTextBox(petTabFrame, "Age", UDim2.new(0.05, 0, 0.45, 0))

local function validateDecimalInput(textBox)
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        local newText = textBox.Text:gsub("[^%d.]", "")
        local decimalCount = select(2, newText:gsub("%.", ""))
        if decimalCount > 1 then
            local parts = {}
            for part in newText:gmatch("[^.]+") do
                table.insert(parts, part)
            end
            newText = parts[1].."."..(parts[2] or "")
        end
        if newText:sub(1,1) == "." then
            newText = "0"..newText
        end
        textBox.Text = newText
    end)
end

validateDecimalInput(weightBox)
validateDecimalInput(ageBox)

local function createButton(parent, text, posY)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0.9, 0, 0, 25)
	btn.Position = UDim2.new(0.05, 0, posY, 0)
	btn.Text = text
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local spawnBtn = createButton(petTabFrame, "SPAWN PET", 0.65)
local dupeBtn = createButton(petTabFrame, "DUPE PET", 0.8)

local seedScroll = Instance.new("ScrollingFrame", seedTabFrame)
seedScroll.Size = UDim2.new(1, 0, 1, 0)
seedScroll.BackgroundTransparency = 1
seedScroll.ScrollingDirection = Enum.ScrollingDirection.Y
seedScroll.ScrollBarThickness = 5

local seedButtonTemplate = Instance.new("TextButton")
seedButtonTemplate.Size = UDim2.new(0.9, 0, 0, 30)
seedButtonTemplate.Font = Enum.Font.SourceSans
seedButtonTemplate.TextSize = 14
seedButtonTemplate.TextColor3 = Color3.new(1, 1, 1)
seedButtonTemplate.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", seedButtonTemplate).CornerRadius = UDim.new(0, 6)

local function setupSeedButtons()
    local seedNames = Spawner.GetSeeds() or {"Candy Blossom", "Sunflower", "Moonflower"}
    local buttonHeight = 35
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

petTab.MouseButton1Click:Connect(function()
	petTabFrame.Visible = true
	seedTabFrame.Visible = false
end)

seedTab.MouseButton1Click:Connect(function()
	petTabFrame.Visible = false
	seedTabFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

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