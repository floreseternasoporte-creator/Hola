-- SISTEMA DE HACHA PARA CORTAR LIANAS - VERSIÓN CORREGIDA
-- LocalScript en StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===================== CREAR ICONO UI (ARRIBA DE LA TIENDA) =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AxeUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Botón circular del hacha (MISMO TAMAÑO Y ESTILO QUE TIENDA)
local axeButton = Instance.new("ImageButton")
axeButton.Name = "AxeButton"
axeButton.Size = UDim2.new(0, 52, 0, 52)
axeButton.Position = UDim2.new(0, 15, 0, 95) -- ARRIBA DE LA TIENDA
axeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
axeButton.BackgroundTransparency = 0.2
axeButton.BorderSizePixel = 0
axeButton.AutoButtonColor = false
axeButton.Image = ""
axeButton.ZIndex = 10
axeButton.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0.5, 0)
btnCorner.Parent = axeButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(100, 100, 100)
btnStroke.Thickness = 1
btnStroke.Transparency = 0.3
btnStroke.Parent = axeButton

-- Icono del hacha MEJORADO
local axeIcon = Instance.new("Frame")
axeIcon.Name = "AxeIcon"
axeIcon.Size = UDim2.new(0, 28, 0, 28)
axeIcon.Position = UDim2.new(0.5, -14, 0.5, -14)
axeIcon.BackgroundTransparency = 1
axeIcon.ZIndex = 11
axeIcon.Parent = axeButton

-- Mango del hacha
local handle = Instance.new("Frame")
handle.Size = UDim2.new(0, 5, 0, 20)
handle.Position = UDim2.new(0.5, -2.5, 0.5, 0)
handle.BackgroundColor3 = Color3.fromRGB(101, 67, 33)
handle.BorderSizePixel = 0
handle.ZIndex = 12
handle.Parent = axeIcon

local handleCorner = Instance.new("UICorner")
handleCorner.CornerRadius = UDim.new(0, 2)
handleCorner.Parent = handle

-- Hoja del hacha
local blade = Instance.new("Frame")
blade.Size = UDim2.new(0, 20, 0, 14)
blade.Position = UDim2.new(0.5, -10, 0, -2)
blade.BackgroundColor3 = Color3.fromRGB(192, 192, 192)
blade.BorderSizePixel = 0
blade.ZIndex = 13
blade.Parent = axeIcon

local bladeCorner = Instance.new("UICorner")
bladeCorner.CornerRadius = UDim.new(0, 3)
bladeCorner.Parent = blade

-- Filo brillante
local edge = Instance.new("Frame")
edge.Size = UDim2.new(0, 16, 0, 3)
edge.Position = UDim2.new(0.5, -8, 0, 0)
edge.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
edge.BorderSizePixel = 0
edge.ZIndex = 14
edge.Parent = blade

local edgeCorner = Instance.new("UICorner")
edgeCorner.CornerRadius = UDim.new(0, 1)
edgeCorner.Parent = edge

-- Tecla
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0, 18, 0, 18)
keyLabel.Position = UDim2.new(1, -22, 1, -22)
keyLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
keyLabel.BackgroundTransparency = 0.3
keyLabel.Text = "X"
keyLabel.TextColor3 = Color3.new(1, 1, 1)
keyLabel.TextSize = 11
keyLabel.Font = Enum.Font.GothamBold
keyLabel.BorderSizePixel = 0
keyLabel.ZIndex = 14
keyLabel.Parent = axeButton

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0.5, 0)
keyCorner.Parent = keyLabel

-- Estado
local axeEquipped = false
local axeTool = nil

-- Efectos hover
axeButton.MouseEnter:Connect(function()
    TweenService:Create(axeButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 56, 0, 56),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
end)

axeButton.MouseLeave:Connect(function()
    TweenService:Create(axeButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 52, 0, 52),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }):Play()
    if not axeEquipped then
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
    end
end)

-- ===================== CREAR HERRAMIENTA HACHA =====================
local function createAxeTool()
    local tool = Instance.new("Tool")
    tool.Name = "Hacha"
    tool.RequiresHandle = true
    tool.CanBeDropped = false
    
    local handlePart = Instance.new("Part")
    handlePart.Name = "Handle"
    handlePart.Size = Vector3.new(0.3, 3, 0.3)
    handlePart.Material = Enum.Material.Wood
    handlePart.Color = Color3.fromRGB(101, 67, 33)
    handlePart.Parent = tool
    
    local bladePart = Instance.new("Part")
    bladePart.Name = "Blade"
    bladePart.Size = Vector3.new(0.2, 1.5, 1.2)
    bladePart.Material = Enum.Material.Metal
    bladePart.Color = Color3.fromRGB(180, 180, 190)
    bladePart.Parent = tool
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handlePart
    weld.Part1 = bladePart
    weld.Parent = bladePart
    
    bladePart.CFrame = handlePart.CFrame * CFrame.new(0, 1.2, 0)
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Wedge
    mesh.Scale = Vector3.new(1, 1, 1)
    mesh.Parent = bladePart
    
    return tool
end

-- ===================== EQUIPAR/DESEQUIPAR =====================
local function toggleAxe()
    local character = player.Character
    if not character then return end
    
    if axeEquipped then
        if axeTool and axeTool.Parent then
            axeTool.Parent = nil
        end
        axeEquipped = false
        axeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btnStroke.Transparency = 0.3
    else
        if not axeTool then
            axeTool = createAxeTool()
        end
        axeTool.Parent = character
        axeEquipped = true
        axeButton.BackgroundColor3 = Color3.fromRGB(50, 40, 30)
        btnStroke.Transparency = 0
        btnStroke.Color = Color3.fromRGB(255, 200, 100)
    end
end

axeButton.MouseButton1Click:Connect(toggleAxe)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        toggleAxe()
    end
end)

-- ===================== SISTEMA DE CORTE =====================
local cutEvent = Instance.new("RemoteEvent")
cutEvent.Name = "CutVineEvent"
cutEvent.Parent = ReplicatedStorage

local cutting = false
local lastCutTime = 0

local function cutVine()
    if not axeEquipped or cutting then return end
    if tick() - lastCutTime < 0.5 then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    cutting = true
    lastCutTime = tick()
    
    print("🪓 Intentando cortar...")
    
    -- Animación de corte
    task.spawn(function()
        for i = 1, 3 do
            TweenService:Create(axeIcon, TweenInfo.new(0.08), {Rotation = -25}):Play()
            task.wait(0.08)
            TweenService:Create(axeIcon, TweenInfo.new(0.08), {Rotation = 25}):Play()
            task.wait(0.08)
        end
        axeIcon.Rotation = 0
    end)
    
    -- Buscar lianas cercanas
    local maxDistance = 10
    local closestVine = nil
    local closestDistance = maxDistance
    
    local elianaNetwork = workspace:FindFirstChild("Eliana_Network")
    if elianaNetwork then
        for _, part in ipairs(elianaNetwork:GetDescendants()) do
            if part:IsA("BasePart") and part.Parent then
                local distance = (part.Position - humanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestVine = part
                end
            end
        end
    end
    
    if closestVine then
        print("✅ Liana encontrada a " .. math.floor(closestDistance) .. " studs")
        cutEvent:FireServer(closestVine)
    else
        print("❌ No hay lianas cerca")
    end
    
    task.wait(0.5)
    cutting = false
end

-- Activar corte con clic del mouse
local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
    if axeEquipped then
        cutVine()
    end
end)

-- Reconectar cuando se crea nuevo personaje
player.CharacterAdded:Connect(function()
    axeEquipped = false
    axeTool = nil
    axeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btnStroke.Transparency = 0.3
end)

print("✅ Sistema de hacha cargado")
