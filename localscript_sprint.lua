-- SISTEMA DE SPRINT
-- LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Configuración
local SPRINT_SPEED = 32
local NORMAL_SPEED = 16
local SPRINT_DURATION = 10
local COOLDOWN_TIME = 5

local isSprinting = false
local canSprint = true
local sprintEndTime = 0

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SprintUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 20
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Botón de Sprint (al lado del botón de saltar)
local sprintButton = Instance.new("ImageButton")
sprintButton.Name = "SprintButton"
sprintButton.Size = UDim2.new(0, 70, 0, 70)
sprintButton.Position = UDim2.new(1, -165, 1, -95)
sprintButton.AnchorPoint = Vector2.new(0, 1)
sprintButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sprintButton.BackgroundTransparency = 0.3
sprintButton.BorderSizePixel = 0
sprintButton.ZIndex = 10000
sprintButton.Parent = screenGui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0.2, 0)
buttonCorner.Parent = sprintButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(0, 200, 255)
buttonStroke.Thickness = 2
buttonStroke.Transparency = 0.3
buttonStroke.Parent = sprintButton

-- Icono de correr (persona corriendo)
local sprintIcon = Instance.new("TextLabel")
sprintIcon.Size = UDim2.new(1, 0, 0.7, 0)
sprintIcon.Position = UDim2.new(0, 0, 0, 0)
sprintIcon.BackgroundTransparency = 1
sprintIcon.Text = "🏃"
sprintIcon.TextSize = 40
sprintIcon.TextColor3 = Color3.fromRGB(0, 200, 255)
sprintIcon.ZIndex = 10001
sprintIcon.Parent = sprintButton

-- Texto de tiempo
local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(1, 0, 0.3, 0)
timeLabel.Position = UDim2.new(0, 0, 0.7, 0)
timeLabel.BackgroundTransparency = 1
timeLabel.Text = ""
timeLabel.Font = Enum.Font.GothamBold
timeLabel.TextSize = 14
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeLabel.ZIndex = 10001
timeLabel.Parent = sprintButton

-- Overlay de cooldown
local cooldownOverlay = Instance.new("Frame")
cooldownOverlay.Name = "CooldownOverlay"
cooldownOverlay.Size = UDim2.new(1, 0, 0, 0)
cooldownOverlay.Position = UDim2.new(0, 0, 1, 0)
cooldownOverlay.AnchorPoint = Vector2.new(0, 1)
cooldownOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
cooldownOverlay.BackgroundTransparency = 0.5
cooldownOverlay.BorderSizePixel = 0
cooldownOverlay.ZIndex = 10002
cooldownOverlay.Parent = sprintButton

local overlayCorner = Instance.new("UICorner")
overlayCorner.CornerRadius = UDim.new(0.2, 0)
overlayCorner.Parent = cooldownOverlay

-- Función para activar sprint
local function activateSprint()
    if not canSprint or isSprinting then return end
    
    isSprinting = true
    canSprint = false
    sprintEndTime = tick() + SPRINT_DURATION
    
    -- Cambiar velocidad
    humanoid.WalkSpeed = SPRINT_SPEED
    
    -- Efectos visuales
    sprintButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    buttonStroke.Color = Color3.fromRGB(0, 255, 255)
    buttonStroke.Transparency = 0
    
    -- Animación de overlay
    cooldownOverlay.Size = UDim2.new(1, 0, 1, 0)
    TweenService:Create(cooldownOverlay, TweenInfo.new(SPRINT_DURATION, Enum.EasingStyle.Linear), {
        Size = UDim2.new(1, 0, 0, 0)
    }):Play()
    
    -- Contador de tiempo
    task.spawn(function()
        while isSprinting and tick() < sprintEndTime do
            local remaining = math.ceil(sprintEndTime - tick())
            timeLabel.Text = tostring(remaining) .. "s"
            task.wait(0.1)
        end
    end)
    
    -- Esperar duración
    task.wait(SPRINT_DURATION)
    
    -- Desactivar sprint
    isSprinting = false
    humanoid.WalkSpeed = NORMAL_SPEED
    timeLabel.Text = ""
    
    -- Cooldown
    sprintButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    buttonStroke.Color = Color3.fromRGB(150, 150, 150)
    sprintIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    -- Animación de cooldown
    cooldownOverlay.Size = UDim2.new(1, 0, 1, 0)
    TweenService:Create(cooldownOverlay, TweenInfo.new(COOLDOWN_TIME, Enum.EasingStyle.Linear), {
        Size = UDim2.new(1, 0, 0, 0)
    }):Play()
    
    -- Contador de cooldown
    local cooldownEnd = tick() + COOLDOWN_TIME
    while tick() < cooldownEnd do
        local remaining = math.ceil(cooldownEnd - tick())
        timeLabel.Text = tostring(remaining) .. "s"
        timeLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(0.1)
    end
    
    -- Restaurar
    canSprint = true
    timeLabel.Text = ""
    timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sprintButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    buttonStroke.Color = Color3.fromRGB(0, 200, 255)
    buttonStroke.Transparency = 0.3
    sprintIcon.TextColor3 = Color3.fromRGB(0, 200, 255)
end

-- Eventos del botón
sprintButton.MouseButton1Down:Connect(function()
    activateSprint()
end)

-- Soporte táctil
sprintButton.TouchTap:Connect(function()
    activateSprint()
end)

-- Tecla Shift para PC
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        activateSprint()
    end
end)

-- Actualizar cuando cambia el personaje
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = NORMAL_SPEED
    isSprinting = false
    canSprint = true
end)

print("✅ Sistema de Sprint activo!")
