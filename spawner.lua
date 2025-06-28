local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedSpawnerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local isPC = UIS.MouseEnabled
local uiScale = isPC and 1.15 or 1

local discordBlack = Color3.fromRGB(32, 34, 37)
local lavender = Color3.fromRGB(180, 140, 235)
local darkLavender = Color3.fromRGB(160, 120, 215)
local headerColor = Color3.fromRGB(47, 49, 54)
local textColor = Color3.fromRGB(220, 220, 220)

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 80*uiScale, 0, 25*uiScale)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Toggle UI"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 14
toggleButton.BackgroundColor3 = lavender
toggleButton.TextColor3 = Color3.new(0,0,0)
toggleButton.Parent = screenGui
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250*uiScale, 0, 240*uiScale)
mainFrame.Position = UDim2.new(0.5, -125*uiScale, 0.5, -120*uiScale)
mainFrame.BackgroundColor3 = discordBlack
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Visible = true
mainFrame.Parent = screenGui
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

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = headerColor
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local versionText = Instance.new("TextLabel")
versionText.Text = "v1.9.4"
versionText.Size = UDim2.new(0, 40, 0, 12)
versionText.Position = UDim2.new(0, 5, 0, 5)
versionText.Font = Enum.Font.SourceSans
versionText.TextSize = 10
versionText.TextColor3 = textColor
versionText.BackgroundTransparency = 1
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.Parent = header

local title = Instance.new("TextLabel")
title.Text = "PET/SEED/EGG SPAWNER"
title.Size = UDim2.new(1, -10, 0, 20)
title.Position = UDim2.new(0, 5, 0, 5)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = textColor
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = header

local credit = Instance.new("TextLabel")
credit.Text = "by @zenxq"
credit.Size = UDim2.new(1, -10, 0, 12)
credit.Position = UDim2.new(0, 5, 0, 22)
credit.Font = Enum.Font.SourceSans
credit.TextSize = 10
credit.TextColor3 = textColor
credit.BackgroundTransparency = 1
credit.TextXAlignment = Enum.TextXAlignment.Center
credit.Parent = header

local tabBackground = Instance.new("Frame")
tabBackground.Size = UDim2.new(1, 0, 0, 20)
tabBackground.Position = UDim2.new(0, 0, 0, 35)
tabBackground.BackgroundColor3 = headerColor
tabBackground.BorderSizePixel = 0
tabBackground.Parent = header
Instance.new("UICorner", tabBackground).CornerRadius = UDim.new(0, 4)

local function makeTab(name, pos)
    local b = Instance.new("TextButton")
    b.Text = name
    b.Size = UDim2.new(0.33, -2, 1, 0)
    b.Position = UDim2.new(pos, 0, 0, 0)
    b.Font = Enum.Font.SourceSansBold
    b.TextColor3 = textColor
    b.TextSize = 14
    b.BackgroundColor3 = (name == "PET") and darkLavender or headerColor
    b.BorderSizePixel = 0
    b.Parent = tabBackground
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 0)
    
    b.MouseEnter:Connect(function()
        if b.BackgroundColor3 ~= darkLavender then
            b.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end)
    
    b.MouseLeave:Connect(function()
        if b.BackgroundColor3 ~= darkLavender then
            b.BackgroundColor3 = headerColor
        end
    end)
    
    return b
end

local petTab = makeTab("PET", 0.00)
local seedTab = makeTab("SEED", 0.33)
local eggTab = makeTab("EGG", 0.66)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSans
closeBtn.TextSize = 16
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = textColor
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local petTabFrame = Instance.new("Frame")
local seedTabFrame = Instance.new("Frame")
local eggTabFrame = Instance.new("Frame")
local notesFrame = Instance.new("Frame")

for _, f in ipairs({petTabFrame, seedTabFrame, eggTabFrame, notesFrame}) do
    f.Position = UDim2.new(0, 0, 0, 55)
    f.Size = UDim2.new(1, 0, 1, -55)
    f.BackgroundTransparency = 1
    f.Parent = mainFrame
end

seedTabFrame.Visible = false
eggTabFrame.Visible = false
notesFrame.Visible = false

local function createTextBox(parent, placeholder, pos)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.9, 0, 0, 25)
    box.Position = pos
    box.PlaceholderText = placeholder
    box.Text = ""
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14
    box.TextColor3 = textColor
    box.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    box.BorderSizePixel = 0
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    return box
end

local petNameBox = createTextBox(petTabFrame, "Pet Name", UDim2.new(0.05, 0, 0.05, 0))
local weightBox = createTextBox(petTabFrame, "Weight", UDim2.new(0.05, 0, 0.25, 0))
local ageBox = createTextBox(petTabFrame, "Age", UDim2.new(0.05, 0, 0.45, 0))
local seedNameBox = createTextBox(seedTabFrame, "Seed Name", UDim2.new(0.05, 0, 0.05, 0))
local amountBox = createTextBox(seedTabFrame, "Amount", UDim2.new(0.05, 0, 0.25, 0))
local eggNameBox = createTextBox(eggTabFrame, "Egg Name", UDim2.new(0.05, 0, 0.05, 0))
local spinBox = createTextBox(eggTabFrame, "Plant to Spin", UDim2.new(0.05, 0, 0.25, 0))

local function validateDecimal(box)
    box:GetPropertyChangedSignal("Text"):Connect(function()
        local t = box.Text:gsub("[^%d.]", "")
        if select(2, t:gsub("%.", "")) > 1 then
            local p1, p2 = t:match("([^%.]+)%.?(.*)")
            t = p1.."."..p2
        end
        if t:sub(1,1) == "." then t = "0"..t end
        if t ~= box.Text then box.Text = t end
    end)
end

for _, b in ipairs({weightBox, ageBox, amountBox}) do 
    validateDecimal(b) 
end

local function createButton(parent, label, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 25)
    btn.Position = UDim2.new(0.05, 0, posY, 0)
    btn.Text = label
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(0,0,0)
    btn.BackgroundColor3 = lavender
    btn.BorderSizePixel = 0
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = darkLavender
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = lavender
    end)
    
    return btn
end

local spawnBtn = createButton(petTabFrame, "SPAWN PET", 0.65)
local spawnSeedBtn = createButton(seedTabFrame, "SPAWN SEED", 0.45)
local spawnEggBtn = createButton(eggTabFrame, "SPAWN EGG", 0.45)
local spinBtn = createButton(eggTabFrame, "SPIN PLANT", 0.65)

-- Add NOTES button in bottom right corner
local notesBtn = Instance.new("TextButton")
notesBtn.Name = "NotesButton"
notesBtn.Text = "<u>NOTES</u>"
notesBtn.Size = UDim2.new(0, 60, 0, 20)
notesBtn.Position = UDim2.new(1, -65, 1, -25)
notesBtn.Font = Enum.Font.SourceSans
notesBtn.TextSize = 12
notesBtn.TextColor3 = textColor
notesBtn.BackgroundTransparency = 1
notesBtn.TextXAlignment = Enum.TextXAlignment.Right
notesBtn.RichText = true
notesBtn.Parent = mainFrame

-- Add back button to notes frame
local backBtn = createButton(notesFrame, "BACK", 0.85)
backBtn.Size = UDim2.new(0.3, 0, 0, 25)
backBtn.Position = UDim2.new(0.05, 0, 0.85, 0)

-- Create scrolling frame for notes
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.9, 0, 0.75, 0)
scrollFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.Parent = notesFrame

-- Add notes text
local notesText = Instance.new("TextLabel")
notesText.Text = "An actual working pet spawner script. Since the one from my youtube always gets broken. Keep this a secret.\n\nloadstring(game:HttpGet(\"https://raw.githubusercontent.com/thatsepical/spawner/refs/heads/main/growagardenspawner.lua\"))()\n\nCopy the script and rejoin\nExecute the script\nMake sure to execute the script with PURPLE UI, for it to work everytime.\nYou need to do these steps for the script with YELLOW UI to work."
notesText.Size = UDim2.new(1, 0, 1, 0)
notesText.Font = Enum.Font.SourceSans
notesText.TextSize = 14
notesText.TextColor3 = textColor
notesText.BackgroundTransparency = 1
notesText.TextWrapped = true
notesText.TextXAlignment = Enum.TextXAlignment.Left
notesText.TextYAlignment = Enum.TextYAlignment.Top
notesText.Parent = scrollFrame

-- Make text label size fit content
notesText:GetPropertyChangedSignal("TextBounds"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, notesText.TextBounds.Y + 10)
end)

local function showNotification(message)
    local notification = Instance.new("Frame")
    notification.Name = "SpawnNotification"
    notification.Size = UDim2.new(0, 250, 0, 60)
    notification.Position = UDim2.new(1, -260, 1, -70)
    notification.BackgroundColor3 = headerColor
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    Instance.new("UICorner", notification).CornerRadius = UDim.new(0, 8)
    
    local notificationText = Instance.new("TextLabel")
    notificationText.Text = message
    notificationText.Size = UDim2.new(1, -10, 1, -10)
    notificationText.Position = UDim2.new(0, 5, 0, 5)
    notificationText.Font = Enum.Font.SourceSans
    notificationText.TextSize = 14
    notificationText.TextColor3 = textColor
    notificationText.BackgroundTransparency = 1
    notificationText.TextWrapped = true
    notificationText.Parent = notification
    
    notification.Position = UDim2.new(1, 300, 1, -70)
    notification:TweenPosition(
        UDim2.new(1, -260, 1, -70),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.3,
        true
    )
    
    task.delay(3, function()
        notification:TweenPosition(
            UDim2.new(1, 300, 1, -70),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Quad,
            0.3,
            true,
            function()
                notification:Destroy()
            end
        )
    end)
end

spawnBtn.MouseButton1Click:Connect(function()
    showNotification("Pet spawning functionality has been removed")
end)

spawnSeedBtn.MouseButton1Click:Connect(function()
    showNotification("Seed spawning functionality has been removed")
end)

spawnEggBtn.MouseButton1Click:Connect(function()
    showNotification("Egg spawning functionality has been removed")
end)

spinBtn.MouseButton1Click:Connect(function()
    showNotification("Plant spinning functionality has been removed")
end)

local function switch(tab)
    petTabFrame.Visible = (tab == "pet")
    seedTabFrame.Visible = (tab == "seed")
    eggTabFrame.Visible = (tab == "egg")
    notesFrame.Visible = (tab == "notes")
    
    petTab.BackgroundColor3 = (tab == "pet") and darkLavender or headerColor
    seedTab.BackgroundColor3 = (tab == "seed") and darkLavender or headerColor
    eggTab.BackgroundColor3 = (tab == "egg") and darkLavender or headerColor
    
    -- Toggle notes text visibility
    if tab == "notes" then
        scrollFrame.Visible = true
    else
        scrollFrame.Visible = false
    end
end

petTab.MouseButton1Click:Connect(function() switch("pet") end)
seedTab.MouseButton1Click:Connect(function() switch("seed") end)
eggTab.MouseButton1Click:Connect(function() switch("egg") end)

-- NOTES button functionality
notesBtn.MouseButton1Click:Connect(function()
    switch("notes")
end)

backBtn.MouseButton1Click:Connect(function()
    switch("pet")
end)

closeBtn.MouseButton1Click:Connect(function() 
    mainFrame.Visible = false 
end)

toggleButton.MouseButton1Click:Connect(function() 
    mainFrame.Visible = not mainFrame.Visible 
end)

switch("pet")

mainFrame.Visible = true
screenGui.Enabled = true