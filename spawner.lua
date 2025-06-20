-- Pet/Spawner UI Script
-- Cleaned and optimized version with the requested fix

local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")
local playerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

-- Add the requested fix
getgenv().Executed = nil

-- Load Spawner module with fallback
local Spawner
local success, err = pcall(function()
    Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/ataturk123/GardenSpawner/refs/heads/main/Spawner.lua", true))()
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

-- UI Creation Functions
local function createInstance(className, props)
    local instance = Instance.new(className)
    for prop, value in pairs(props) do
        instance[prop] = value
    end
    return instance
end

local function createUICorner(parent, radius)
    local corner = createInstance("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(0, radius or 6)
    })
    return corner
end

-- Create main UI elements
local screenGui = createInstance("ScreenGui", {
    Name = "PetSpawnerUI",
    Parent = playerGui,
    ResetOnSpawn = false
})

local isPC = UIS.MouseEnabled
local uiScale = isPC and 1.15 or 1

-- Toggle button
local toggleButton = createInstance("TextButton", {
    Name = "ToggleButton",
    Parent = screenGui,
    Size = UDim2.new(0, 80 * uiScale, 0, 25 * uiScale),
    Position = UDim2.new(0, 10, 0, 10),
    Text = "Open UI",
    Font = Enum.Font.SourceSans,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
    TextColor3 = Color3.new(1, 1, 1)
})
createUICorner(toggleButton)

-- Main frame
local mainFrame = createInstance("Frame", {
    Name = "MainFrame",
    Parent = screenGui,
    Size = UDim2.new(0, 250 * uiScale, 0, 280 * uiScale),
    Position = UDim2.new(0.5, -125 * uiScale, 0.5, -140 * uiScale),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BorderSizePixel = 0,
    Active = true,
    Visible = false
})
createUICorner(mainFrame, 8)

-- Dragging functionality
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                connection:Disconnect()
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
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

-- Header section
local header = createInstance("Frame", {
    Name = "Header",
    Parent = mainFrame,
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    BorderSizePixel = 0
})
createUICorner(header, 8)

local title = createInstance("TextLabel", {
    Name = "Title",
    Parent = header,
    Text = "PET/SEED SPAWNER",
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 5),
    Font = Enum.Font.SourceSansBold,
    TextSize = 16,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundTransparency = 1
})

local credit = createInstance("TextLabel", {
    Name = "Credit",
    Parent = header,
    Text = "by @zenxq",
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 0, 22),
    Font = Enum.Font.SourceSans,
    TextSize = 10,
    TextColor3 = Color3.new(0.8, 0.8, 0.8),
    BackgroundTransparency = 1
})

-- Tab system
local tabBackground = createInstance("Frame", {
    Name = "TabBackground",
    Parent = header,
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 35),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    BorderSizePixel = 0
})
createUICorner(tabBackground, 4)

local petTab = createInstance("TextButton", {
    Name = "PetTab",
    Parent = tabBackground,
    Text = "PET",
    Size = UDim2.new(0.5, -2, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    Font = Enum.Font.SourceSans,
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(70, 70, 70),
    BorderSizePixel = 0
})
createUICorner(petTab, 4)

local seedTab = createInstance("TextButton", {
    Name = "SeedTab",
    Parent = tabBackground,
    Text = "SEED",
    Size = UDim2.new(0.5, -2, 1, 0),
    Position = UDim2.new(0.5, 0, 0, 0),
    Font = Enum.Font.SourceSans,
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    BorderSizePixel = 0
})
createUICorner(seedTab, 4)

local closeBtn = createInstance("TextButton", {
    Name = "CloseButton",
    Parent = header,
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -30, 0, 5),
    Text = "X",
    Font = Enum.Font.SourceSans,
    TextSize = 16,
    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
    TextColor3 = Color3.new(1, 1, 1)
})
createUICorner(closeBtn)

-- Tab frames
local petTabFrame = createInstance("Frame", {
    Name = "PetTabFrame",
    Parent = mainFrame,
    Position = UDim2.new(0, 0, 0, 55),
    Size = UDim2.new(1, 0, 1, -55),
    BackgroundTransparency = 1
})

local seedTabFrame = createInstance("Frame", {
    Name = "SeedTabFrame",
    Parent = mainFrame,
    Position = UDim2.new(0, 0, 0, 55),
    Size = UDim2.new(1, 0, 1, -55),
    BackgroundTransparency = 1,
    Visible = false
})

-- Text box creation function
local function createTextBox(parent, placeholder, position)
    local box = createInstance("TextBox", {
        Parent = parent,
        Size = UDim2.new(0.9, 0, 0, 25),
        Position = position,
        PlaceholderText = placeholder,
        Text = "",
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextColor3 = Color3.new(1, 1, 1),
        PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
        BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    })
    createUICorner(box, 5)
    return box
end

-- Pet tab inputs
local petNameBox = createTextBox(petTabFrame, "Pet Name", UDim2.new(0.05, 0, 0.05, 0))
local weightBox = createTextBox(petTabFrame, "Weight", UDim2.new(0.05, 0, 0.25, 0))
local ageBox = createTextBox(petTabFrame, "Age", UDim2.new(0.05, 0, 0.45, 0))

-- Input validation
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

-- Button creation function
local function createButton(parent, text, posY)
    local btn = createInstance("TextButton", {
        Parent = parent,
        Size = UDim2.new(0.9, 0, 0, 25),
        Position = UDim2.new(0.05, 0, posY, 0),
        Text = text,
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    })
    createUICorner(btn)
    return btn
end

-- Pet tab buttons
local spawnBtn = createButton(petTabFrame, "SPAWN PET", 0.65)
local dupeBtn = createButton(petTabFrame, "DUPE PET", 0.8)

-- Seed tab scroll frame
local seedScroll = createInstance("ScrollingFrame", {
    Name = "SeedScroll",
    Parent = seedTabFrame,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ScrollBarThickness = 6,
    ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
    CanvasSize = UDim2.new(0, 0, 0, 0)
})

local seedListLayout = createInstance("UIListLayout", {
    Parent = seedScroll,
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
})

seedListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    seedScroll.CanvasSize = UDim2.new(0, 0, 0, seedListLayout.AbsoluteContentSize.Y + 10)
end)

-- Seed button template
local seedButtonTemplate = createInstance("TextButton", {
    Size = UDim2.new(0.9, 0, 0, 30),
    Position = UDim2.new(0.05, 0, 0, 0),
    Font = Enum.Font.SourceSans,
    TextSize = 14,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
    AutoButtonColor = true
})
createUICorner(seedButtonTemplate)

-- Seed buttons setup
local function setupSeedButtons()
    local seedNames = Spawner.GetSeeds() or {"Candy Blossom", "Sunflower", "Moonflower"}
    
    for _, child in ipairs(seedScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, seedName in ipairs(seedNames) do
        local seedBtn = seedButtonTemplate:Clone()
        seedBtn.Parent = seedScroll
        seedBtn.Text = seedName
        seedBtn.LayoutOrder = _
        
        seedBtn.MouseButton1Click:Connect(function()
            local success, result = pcall(function()
                local spawned = Spawner.SpawnSeed(seedName)
                if not spawned then
                    error("Failed to spawn seed")
                end
                return spawned
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

-- Tab switching
local function switchToTab(tab)
    if tab == "pet" then
        petTabFrame.Visible = true
        seedTabFrame.Visible = false
        petTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        seedTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        petTabFrame.Visible = false
        seedTabFrame.Visible = true
        petTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        seedTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end

petTab.MouseButton1Click:Connect(function()
    switchToTab("pet")
end)

seedTab.MouseButton1Click:Connect(function()
    switchToTab("seed")
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Spawn pet functionality
spawnBtn.MouseButton1Click:Connect(function()
    local petName = petNameBox.Text
    local petWeight = tonumber(weightBox.Text) or 1
    local petAge = tonumber(ageBox.Text) or 1
    
    if not petName or string.len(petName) < 2 then
        warn("Please enter a valid pet name")
        return
    end

    local success, result = pcall(function()
        local spawned = Spawner.SpawnPet(petName, petWeight, petAge)
        if not spawned then
            error("Failed to spawn pet")
        end
        return spawned
    end)
    
    if not success then
        warn("Failed to spawn pet: "..tostring(result))
    else
        print("Successfully spawned pet:", petName)
        
        if isPC and result and typeof(result) == "Instance" then
            task.wait(0.2)
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:EquipTool(result)
            end
        end
    end
end)

-- Dupe pet functionality
dupeBtn.MouseButton1Click:Connect(function()
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool") or backpack:FindFirstChildOfClass("Tool")
    
    if not tool then
        warn("No pet found equipped or in backpack")
        return
    end

    local fakeClone = tool:Clone()
    
    -- Clean up unnecessary scripts
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

    -- Handle animations
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

    -- Configure clone properties
    fakeClone.Enabled = true
    fakeClone.ManualActivationOnly = false
    fakeClone.RequiresHandle = true
    
    if fakeClone:FindFirstChild("CanBeDropped") then
        fakeClone.CanBeDropped = false
    end
    
    fakeClone.Name = tool.Name
    fakeClone.Parent = backpack

    -- Equip and animate
    task.wait(0.2)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid:EquipTool(fakeClone)
        
        task.wait(0.1)
        if fakeClone:FindFirstChildOfClass("Humanoid") then
            for _,track in pairs(fakeClone.Humanoid.Animator:GetPlayingAnimationTracks()) do
                track:Play()
            end
        end
    end
    
    print("Created animated duplicate of: "..tool.Name)
end)

-- Initialize UI
switchToTab("pet")