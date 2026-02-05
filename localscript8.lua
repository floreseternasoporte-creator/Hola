-- LocalScript para mostrar UI de madera
-- Coloca este script en StarterPlayer > StarterPlayerScripts
 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
 
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
 
-- Esperar al RemoteEvent
local woodEvent = ReplicatedStorage:WaitForChild("WoodEvent")
 
-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WoodUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui
 
-- Frame CUADRADO y compacto
local mainFrame = Instance.new("Frame")
mainFrame.Name = "WoodFrame"
mainFrame.Size = UDim2.new(0, 70, 0, 70)  -- CUADRADO
mainFrame.Position = UDim2.new(0, 15, 0.5, -35)  -- Lado izquierdo
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- NEGRO
mainFrame.BackgroundTransparency = 0.5  -- Semi-transparente
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
 
-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame
 
-- Icono de madera (MEJOR DISEÑO - marrón)
local iconFrame = Instance.new("Frame")
iconFrame.Name = "IconFrame"
iconFrame.Size = UDim2.new(0, 30, 0, 30)
iconFrame.Position = UDim2.new(0.5, -15, 0, 8)  -- Centrado arriba
iconFrame.BackgroundColor3 = Color3.fromRGB(160, 82, 45)  -- Marrón claro madera
iconFrame.BorderSizePixel = 0
iconFrame.Parent = mainFrame
 
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 3)
iconCorner.Parent = iconFrame
 
-- Vetas verticales de madera
local veta1 = Instance.new("Frame")
veta1.Size = UDim2.new(0, 2, 1, 0)
veta1.Position = UDim2.new(0, 8, 0, 0)
veta1.BackgroundColor3 = Color3.fromRGB(101, 67, 33)
veta1.BorderSizePixel = 0
veta1.Parent = iconFrame
 
local veta2 = Instance.new("Frame")
veta2.Size = UDim2.new(0, 2, 1, 0)
veta2.Position = UDim2.new(0, 14, 0, 0)
veta2.BackgroundColor3 = Color3.fromRGB(101, 67, 33)
veta2.BorderSizePixel = 0
veta2.Parent = iconFrame
 
local veta3 = Instance.new("Frame")
veta3.Size = UDim2.new(0, 2, 1, 0)
veta3.Position = UDim2.new(0, 20, 0, 0)
veta3.BackgroundColor3 = Color3.fromRGB(101, 67, 33)
veta3.BorderSizePixel = 0
veta3.Parent = iconFrame
 
-- Anillos del árbol (dos círculos)
local ring1 = Instance.new("Frame")
ring1.Name = "Ring1"
ring1.Size = UDim2.new(0, 10, 0, 10)
ring1.Position = UDim2.new(0.5, -5, 0.5, -5)
ring1.BackgroundColor3 = Color3.fromRGB(101, 67, 33)
ring1.BorderSizePixel = 0
ring1.Parent = iconFrame
 
local ring1Corner = Instance.new("UICorner")
ring1Corner.CornerRadius = UDim.new(1, 0)
ring1Corner.Parent = ring1
 
local ring2 = Instance.new("Frame")
ring2.Name = "Ring2"
ring2.Size = UDim2.new(0, 4, 0, 4)
ring2.Position = UDim2.new(0.5, -2, 0.5, -2)
ring2.BackgroundColor3 = Color3.fromRGB(70, 40, 20)
ring2.BorderSizePixel = 0
ring2.Parent = iconFrame
 
local ring2Corner = Instance.new("UICorner")
ring2Corner.CornerRadius = UDim.new(1, 0)
ring2Corner.Parent = ring2
 
-- Contador de madera (abajo, centrado)
local woodLabel = Instance.new("TextLabel")
woodLabel.Name = "WoodCount"
woodLabel.Size = UDim2.new(1, 0, 0, 25)
woodLabel.Position = UDim2.new(0, 0, 1, -30)
woodLabel.BackgroundTransparency = 1
woodLabel.Text = "0"
woodLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
woodLabel.TextSize = 20
woodLabel.Font = Enum.Font.GothamBold
woodLabel.TextXAlignment = Enum.TextXAlignment.Center
woodLabel.Parent = mainFrame
 
-- Función para actualizar el contador
local function updateWoodDisplay()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local woodValue = leaderstats:FindFirstChild("Wood")
        if woodValue then
            woodLabel.Text = tostring(woodValue.Value)
        end
    end
end
 
-- Función de animación cuando se añade madera
local function playAddWoodAnimation(amount)
    -- Efecto de escala
    local scaleTween = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 75, 0, 75)}
    )
    scaleTween:Play()
    
    task.wait(0.1)
    
    local scaleBackTween = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    {Size = UDim2.new(0, 70, 0, 70)}
    )
    scaleBackTween:Play()
    
    -- Texto flotante "+3"
    local floatingText = Instance.new("TextLabel")
    floatingText.Size = UDim2.new(1, 0, 0, 20)
    floatingText.Position = UDim2.new(0, 0, 0, 20)
    floatingText.BackgroundTransparency = 1
    floatingText.Text = "+" .. amount
    floatingText.TextColor3 = Color3.fromRGB(100, 255, 100)
    floatingText.TextSize = 18
    floatingText.Font = Enum.Font.GothamBold
    floatingText.TextXAlignment = Enum.TextXAlignment.Center
    floatingText.Parent = mainFrame
    
    -- Animar
    local floatTween = TweenService:Create(
    floatingText,
    TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {
    Position = UDim2.new(0, 0, 0, -10),
    TextTransparency = 1
    }
    )
    floatTween:Play()
    
    task.delay(0.7, function()
        floatingText:Destroy()
    end)
    
    -- Actualizar contador
    updateWoodDisplay()
end
 
-- Escuchar eventos de madera
woodEvent.OnClientEvent:Connect(function(amount)
    print("🪵 ¡Recibiste " .. amount .. " madera!")
    playAddWoodAnimation(amount)
end)
 
-- Actualizar cuando cambie el valor
local leaderstats = player:WaitForChild("leaderstats")
local woodValue = leaderstats:WaitForChild("Wood")
 
woodValue.Changed:Connect(function()
    updateWoodDisplay()
end)
 
-- Inicializar display
updateWoodDisplay()
 
print("✅ UI de madera cargada correctamente")
