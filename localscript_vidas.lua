-- SISTEMA DE VIDAS CON 3 CORAZONES
-- LocalScript en StarterPlayer > StarterPlayerScripts

local Players = game:GetService(\"Players\")
local TweenService = game:GetService(\"TweenService\")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild(\"Humanoid\")

-- Crear ScreenGui
local screenGui = Instance.new(\"ScreenGui\")
screenGui.Name = \"HealthUI\"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild(\"PlayerGui\")

-- Contenedor de corazones (alineado con los iconos de Roblox)
local heartsContainer = Instance.new(\"Frame\")
heartsContainer.Name = \"HeartsContainer\"
heartsContainer.Size = UDim2.new(0, 180, 0, 52)
heartsContainer.Position = UDim2.new(1, -195, 0, 15) -- Arriba a la derecha, alineado con iconos
heartsContainer.BackgroundTransparency = 1
heartsContainer.Parent = screenGui

-- Crear 3 corazones
local hearts = {}
local HEART_SIZE = 52
local HEART_SPACING = 8

for i = 1, 3 do
    -- Botón circular de fondo
    local heartButton = Instance.new(\"ImageButton\")
    heartButton.Name = \"Heart\" .. i
    heartButton.Size = UDim2.new(0, HEART_SIZE, 0, HEART_SIZE)
    heartButton.Position = UDim2.new(0, (i - 1) * (HEART_SIZE + HEART_SPACING), 0, 0)
    heartButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    heartButton.BackgroundTransparency = 0.2
    heartButton.BorderSizePixel = 0
    heartButton.AutoButtonColor = false
    heartButton.Image = \"\"
    heartButton.ZIndex = 10
    heartButton.Parent = heartsContainer
    
    local btnCorner = Instance.new(\"UICorner\")
    btnCorner.CornerRadius = UDim.new(0.5, 0)
    btnCorner.Parent = heartButton
    
    local btnStroke = Instance.new(\"UIStroke\")
    btnStroke.Color = Color3.fromRGB(100, 100, 100)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.3
    btnStroke.Parent = heartButton
    
    -- Icono de corazón
    local heartIcon = Instance.new(\"TextLabel\")
    heartIcon.Name = \"HeartIcon\"
    heartIcon.Size = UDim2.new(1, 0, 1, 0)
    heartIcon.BackgroundTransparency = 1
    heartIcon.Text = \"❤\"
    heartIcon.TextColor3 = Color3.fromRGB(255, 50, 50)
    heartIcon.TextScaled = true
    heartIcon.Font = Enum.Font.GothamBold
    heartIcon.ZIndex = 11
    heartIcon.Parent = heartButton
    
    -- Padding para el corazón
    local padding = Instance.new(\"UIPadding\")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = heartIcon
    
    table.insert(hearts, {
        button = heartButton,
        icon = heartIcon,
        stroke = btnStroke,
        state = \"full\" -- full, half, empty
    })
end

-- Función para actualizar los corazones según la vida
local function updateHearts()
    local health = humanoid.Health
    local maxHealth = humanoid.MaxHealth
    local healthPerHeart = maxHealth / 3
    
    for i, heart in ipairs(hearts) do
        local heartMinHealth = (i - 1) * healthPerHeart
        local heartMaxHealth = i * healthPerHeart
        
        if health >= heartMaxHealth then
            -- Corazón lleno
            if heart.state ~= \"full\" then
                heart.state = \"full\"
                heart.icon.Text = \"❤\"
                heart.icon.TextColor3 = Color3.fromRGB(255, 50, 50)
                heart.button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                
                -- Animación de recuperación
                TweenService:Create(heart.button, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, HEART_SIZE + 8, 0, HEART_SIZE + 8)
                }):Play()
                task.wait(0.3)
                TweenService:Create(heart.button, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, HEART_SIZE, 0, HEART_SIZE)
                }):Play()
            end
        elseif health > heartMinHealth and health < heartMaxHealth then
            -- Corazón a la mitad
            if heart.state ~= \"half\" then
                heart.state = \"half\"
                heart.icon.Text = \"💔\"
                heart.icon.TextColor3 = Color3.fromRGB(255, 150, 50)
                heart.button.BackgroundColor3 = Color3.fromRGB(40, 30, 20)
                
                -- Animación de daño
                TweenService:Create(heart.button, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, HEART_SIZE - 4, 0, HEART_SIZE - 4)
                }):Play()
                task.wait(0.1)
                TweenService:Create(heart.button, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, HEART_SIZE, 0, HEART_SIZE)
                }):Play()
            end
        else
            -- Corazón vacío
            if heart.state ~= \"empty\" then
                heart.state = \"empty\"
                heart.icon.Text = \"🖤\"
                heart.icon.TextColor3 = Color3.fromRGB(80, 80, 80)
                heart.button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                
                -- Animación de pérdida
                TweenService:Create(heart.icon, TweenInfo.new(0.2), {
                    TextTransparency = 0.5
                }):Play()
                TweenService:Create(heart.button, TweenInfo.new(0.3), {
                    BackgroundTransparency = 0.6
                }):Play()
            end
        end
    end
end

-- Conectar eventos
humanoid.HealthChanged:Connect(function()
    updateHearts()
end)

-- Actualizar al inicio
updateHearts()

-- Reconectar cuando el personaje reaparezca
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild(\"Humanoid\")
    
    -- Resetear corazones
    for _, heart in ipairs(hearts) do
        heart.state = \"full\"
        heart.icon.Text = \"❤\"
        heart.icon.TextColor3 = Color3.fromRGB(255, 50, 50)
        heart.icon.TextTransparency = 0
        heart.button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        heart.button.BackgroundTransparency = 0.2
        heart.button.Size = UDim2.new(0, HEART_SIZE, 0, HEART_SIZE)
    end
    
    humanoid.HealthChanged:Connect(function()
        updateHearts()
    end)
    
    updateHearts()
end)

print(\"✅ Sistema de vidas con 3 corazones cargado\")
