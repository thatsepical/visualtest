local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpawnerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local isPC = UIS.MouseEnabled
local uiScale = isPC and 1.15 or 1

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250*uiScale, 0, 280*uiScale)
mainFrame.Position = UDim2.new(0.5, -125*uiScale, 0.5, -140*uiScale)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,8)

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 80*uiScale, 0, 25*uiScale)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Toggle UI"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 14
toggleButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Parent = screenGui
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0,6)

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
header.BackgroundColor3 = Color3.fromRGB(30,30,30)
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel")
title.Text = "SPAWNER UI"
title.Size = UDim2.new(1, -10, 1, -10)
title.Position = UDim2.new(0, 5, 0, 5)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSans
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

local tabBackground = Instance.new("Frame")
tabBackground.Size = UDim2.new(1, 0, 0, 20)
tabBackground.Position = UDim2.new(0, 0, 0, 35)
tabBackground.BackgroundColor3 = Color3.fromRGB(50,50,50)
tabBackground.BorderSizePixel = 0
tabBackground.Parent = header
Instance.new("UICorner", tabBackground).CornerRadius = UDim.new(0,4)

local petTab = Instance.new("TextButton")
petTab.Text = "PET"
petTab.Size = UDim2.new(0.33, -2, 1, 0)
petTab.Position = UDim2.new(0, 0, 0, 0)
petTab.Font = Enum.Font.SourceSans
petTab.TextColor3 = Color3.new(1,1,1)
petTab.TextSize = 14
petTab.BackgroundColor3 = Color3.fromRGB(70,70,70)
petTab.Parent = tabBackground
Instance.new("UICorner", petTab).CornerRadius = UDim.new(0,4)

local seedTab = Instance.new("TextButton")
seedTab.Text = "SEED"
seedTab.Size = UDim2.new(0.33, -2, 1, 0)
seedTab.Position = UDim2.new(0.33, 0, 0, 0)
seedTab.Font = Enum.Font.SourceSans
seedTab.TextColor3 = Color3.new(1,1,1)
seedTab.TextSize = 14
seedTab.BackgroundColor3 = Color3.fromRGB(50,50,50)
seedTab.Parent = tabBackground
Instance.new("UICorner", seedTab).CornerRadius = UDim.new(0,4)

local eggTab = Instance.new("TextButton")
eggTab.Text = "EGG"
eggTab.Size = UDim2.new(0.33, -2, 1, 0)
eggTab.Position = UDim2.new(0.66, 0, 0, 0)
eggTab.Font = Enum.Font.SourceSans
eggTab.TextColor3 = Color3.new(1,1,1)
eggTab.TextSize = 14
eggTab.BackgroundColor3 = Color3.fromRGB(50,50,50)
eggTab.Parent = tabBackground
Instance.new("UICorner", eggTab).CornerRadius = UDim.new(0,4)

local petTabFrame = Instance.new("Frame")
petTabFrame.Size = UDim2.new(1, 0, 1, -55)
petTabFrame.Position = UDim2.new(0, 0, 0, 55)
petTabFrame.BackgroundTransparency = 1
petTabFrame.Parent = mainFrame

local seedTabFrame = Instance.new("Frame")
seedTabFrame.Size = UDim2.new(1, 0, 1, -55)
seedTabFrame.Position = UDim2.new(0, 0, 0, 55)
seedTabFrame.BackgroundTransparency = 1
seedTabFrame.Visible = false
seedTabFrame.Parent = mainFrame

local eggTabFrame = Instance.new("Frame")
eggTabFrame.Size = UDim2.new(1, 0, 1, -55)
eggTabFrame.Position = UDim2.new(0, 0, 0, 55)
eggTabFrame.BackgroundTransparency = 1
eggTabFrame.Visible = false
eggTabFrame.Parent = mainFrame

local function switch(tab)
    petTabFrame.Visible = (tab == "pet")
    seedTabFrame.Visible = (tab == "seed")
    eggTabFrame.Visible = (tab == "egg")
    
    petTab.BackgroundColor3 = (tab == "pet") and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
    seedTab.BackgroundColor3 = (tab == "seed") and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
    eggTab.BackgroundColor3 = (tab == "egg") and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
end

petTab.MouseButton1Click:Connect(function() switch("pet") end)
seedTab.MouseButton1Click:Connect(function() switch("seed") end)
eggTab.MouseButton1Click:Connect(function() switch("egg") end)

closeBtn.MouseButton1Click:Connect(function() 
    mainFrame.Visible = false 
end)

toggleButton.MouseButton1Click:Connect(function() 
    mainFrame.Visible = not mainFrame.Visible 
end)

switch("pet")