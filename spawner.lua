-- Client-Sided Visual Pet System
-- By github.com/zenxq
-- Allows players to spawn, hold, and place visual pets in their garden (client-side only)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local backpack = player:WaitForChild("Backpack")

-- =============================================
-- CONFIGURATION - EDIT THESE VALUES
-- =============================================
local PET_DATABASE = {
    Bee = {
        Model = "rbxassetid://YOUR_BEE_MODEL_ID",
        HoldOffset = CFrame.new(0, -1, 1.5) * CFrame.Angles(0, math.pi, 0),
        Scale = Vector3.new(0.5, 0.5, 0.5),
        Animations = {
            Idle = "rbxassetid://YOUR_IDLE_ANIM_ID",
            Place = "rbxassetid://YOUR_PLACE_ANIM_ID"
        }
    },
    Slime = {
        Model = "rbxassetid://YOUR_SLIME_MODEL_ID",
        HoldOffset = CFrame.new(0, -1.5, 1.5),
        Scale = Vector3.new(1.2, 1.2, 1.2),
        Animations = {
            Idle = "rbxassetid://YOUR_IDLE_ANIM_ID",
            Place = "rbxassetid://YOUR_PLACE_ANIM_ID"
        }
    }
    -- Add more pets as needed
}

local PLACEMENT_INDICATOR_COLOR = Color3.fromRGB(100, 255, 100)
local PLACEMENT_INDICATOR_SIZE = Vector3.new(4, 0.2, 4)
local MAX_PLACEMENT_DISTANCE = 30
-- =============================================

-- System variables
local clientInventory = {}
local currentHeldPet = nil
local placementMode = false
local placementIndicator = nil
local petCache = {}

-- Initialize system
local function init()
    -- Create placement indicator
    placementIndicator = Instance.new("Part")
    placementIndicator.Name = "PetPlacementIndicator"
    placementIndicator.Size = PLACEMENT_INDICATOR_SIZE
    placementIndicator.Transparency = 0.7
    placementIndicator.Color = PLACEMENT_INDICATOR_COLOR
    placementIndicator.Anchored = true
    placementIndicator.CanCollide = false
    placementIndicator.CastShadow = false
    placementIndicator.Parent = workspace
    placementIndicator.Transparency = 1

    -- Create folder for placed pets
    local petsFolder = Instance.new("Folder")
    petsFolder.Name = "ClientPets"
    petsFolder.Parent = workspace

    -- Character handling
    character:WaitForChild("Humanoid").Died:Connect(function()
        if currentHeldPet then
            currentHeldPet:Destroy()
            currentHeldPet = nil
        end
        placementMode = false
    end)
end

-- Load pet model with caching
local function loadPetModel(petName)
    if petCache[petName] then
        return petCache[petName]:Clone()
    end

    local petData = PET_DATABASE[petName]
    if not petData then return nil end

    local success, model = pcall(function()
        return game:GetObjects(petData.Model)[1]
    end)

    if not success or not model then
        warn("Failed to load pet model: "..petName)
        return nil
    end

    -- Apply scaling if needed
    if petData.Scale then
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * petData.Scale
            end
        end
    end

    -- Cache the model
    petCache[petName] = model
    return model:Clone()
end

-- Animation controller
local function setupPetAnimations(petModel, petName)
    local petData = PET_DATABASE[petName]
    if not petData then return end

    local humanoid = petModel:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    -- Load idle animation
    if petData.Animations.Idle then
        local idleAnim = Instance.new("Animation")
        idleAnim.AnimationId = petData.Animations.Idle
        local idleTrack = animator:LoadAnimation(idleAnim)
        idleTrack.Looped = true
        idleTrack:Play()
    end
end

-- Pet holding system
local function holdPet(petName)
    if currentHeldPet then
        currentHeldPet:Destroy()
        currentHeldPet = nil
    end

    local petModel = loadPetModel(petName)
    if not petModel then return end

    petModel.Name = petName
    petModel.PrimaryPart = petModel:FindFirstChild("HumanoidRootPart") or petModel:FindFirstChildWhichIsA("BasePart")

    -- Attach to player's hand
    local rightHand = character:WaitForChild("RightHand")
    local alignPosition = Instance.new("AlignPosition")
    local alignOrientation = Instance.new("AlignOrientation")
    local attachment1 = Instance.new("Attachment", rightHand)
    local attachment2 = Instance.new("Attachment", petModel.PrimaryPart)

    alignPosition.Attachment0 = attachment1
    alignPosition.Attachment1 = attachment2
    alignPosition.RigidityEnabled = false
    alignPosition.MaxForce = 40000
    alignPosition.Responsiveness = 200
    alignPosition.Parent = petModel

    alignOrientation.Attachment0 = attachment1
    alignOrientation.Attachment1 = attachment2
    alignOrientation.RigidityEnabled = false
    alignOrientation.MaxTorque = 40000
    alignOrientation.Responsiveness = 200
    alignOrientation.Parent = petModel

    -- Apply hold offset
    local petData = PET_DATABASE[petName]
    attachment2.CFrame = petData.HoldOffset

    -- Make only visible to player
    for _, part in ipairs(petModel:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = 0
        end
    end

    petModel.Parent = workspace
    currentHeldPet = petModel
    setupPetAnimations(petModel, petName)
end

-- Pet placement system
local function placePet()
    if not currentHeldPet or not placementMode then return end

    local petName = currentHeldPet.Name
    local petData = PET_DATABASE[petName]
    if not petData then return end

    -- Play placement animation if available
    if petData.Animations.Place then
        local humanoid = currentHeldPet:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                local placeAnim = Instance.new("Animation")
                placeAnim.AnimationId = petData.Animations.Place
                local placeTrack = animator:LoadAnimation(placeAnim)
                placeTrack:Play()
                placeTrack.Stopped:Wait()
            end
        end
    end

    -- Detach from player
    for _, constraint in ipairs(currentHeldPet:GetChildren()) do
        if constraint:IsA("AlignPosition") or constraint:IsA("AlignOrientation") then
            constraint:Destroy()
        end
    end

    -- Remove attachments
    for _, attachment in ipairs(currentHeldPet:GetDescendants()) do
        if attachment:IsA("Attachment") then
            attachment:Destroy()
        end
    end

    -- Make visible to everyone (or keep client-only if preferred)
    for _, part in ipairs(currentHeldPet:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = 0
        end
    end

    -- Anchor in place
    if currentHeldPet.PrimaryPart then
        currentHeldPet.PrimaryPart.Anchored = true
    end

    -- Add to garden collection
    table.insert(clientInventory, {
        Name = petName,
        Model = currentHeldPet,
        Position = currentHeldPet:GetPivot().Position
    })

    -- Parent to pets folder
    currentHeldPet.Parent = workspace:FindFirstChild("ClientPets") or workspace

    currentHeldPet = nil
    placementMode = false
end

-- Input handling
local function setupInput()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        -- Toggle placement mode with E key
        if input.KeyCode == Enum.KeyCode.E and currentHeldPet then
            placementMode = not placementMode
            placementIndicator.Transparency = placementMode and 0.7 or 1
        end

        -- Place pet with left click
        if input.UserInputType == Enum.UserInputType.MouseButton1 and placementMode then
            placePet()
        end
    end)
end

-- Placement indicator system
local function updatePlacementIndicator()
    if not placementMode or not currentHeldPet then
        placementIndicator.Transparency = 1
        return
    end

    -- Raycast to find placement position
    local camera = workspace.CurrentCamera
    local rayOrigin = camera.CFrame.Position
    local rayDirection = camera.CFrame.LookVector * MAX_PLACEMENT_DISTANCE
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character, placementIndicator}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if raycastResult then
        local placementCFrame = CFrame.new(raycastResult.Position) * CFrame.Angles(0, camera.CFrame.Rotation.Y, 0)
        placementIndicator.Position = raycastResult.Position + Vector3.new(0, 0.1, 0)
        placementIndicator.Transparency = 0.7

        -- Update pet position
        if currentHeldPet and currentHeldPet.PrimaryPart then
            currentHeldPet:SetPrimaryPartCFrame(placementCFrame * PET_DATABASE[currentHeldPet.Name].HoldOffset:Inverse())
        end
    else
        placementIndicator.Transparency = 1
    end
end

-- Initialize systems
init()
setupInput()

-- Main update loop
RunService.Heartbeat:Connect(function(deltaTime)
    updatePlacementIndicator()
end)

-- =============================================
-- UI INTEGRATION FUNCTIONS
-- =============================================

-- Modified spawn function for UI
local function spawnPet(petName)
    if not PET_DATABASE[petName] then
        warn("Pet not in database: "..petName)
        return false
    end

    -- Add to client inventory
    table.insert(clientInventory, {Name = petName})
    return true
end

-- Function to equip pet from inventory
local function equipFromInventory(petName)
    for _, pet in ipairs(clientInventory) do
        if pet.Name == petName then
            holdPet(petName)
            return true
        end
    end
    warn("Pet not in inventory: "..petName)
    return false
end

-- Example function to create inventory UI
local function createInventoryUI(parentFrame)
    for petName, _ in pairs(PET_DATABASE) do
        local btn = Instance.new("TextButton")
        btn.Text = "Equip "..petName
        btn.Size = UDim2.new(0.9, 0, 0, 30)
        btn.Position = UDim2.new(0.05, 0, 0, (#parentFrame:GetChildren() * 35))
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        
        btn.MouseButton1Click:Connect(function()
            equipFromInventory(petName)
        end)
        
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.Parent = parentFrame
    end
end

-- Return public functions
return {
    spawnPet = spawnPet,
    equipFromInventory = equipFromInventory,
    createInventoryUI = createInventoryUI,
    getCurrentPet = function() return currentHeldPet end,
    getInventory = function() return clientInventory end
}