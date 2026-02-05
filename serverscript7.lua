-- SERVER SCRIPT - RemoteEvent para compra de poderes
-- ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local purchaseEvent = Instance.new("RemoteFunction")
purchaseEvent.Name = "PurchasePowerEvent"
purchaseEvent.Parent = ReplicatedStorage

purchaseEvent.OnServerInvoke = function(player, powerName, price)
    if not player or not powerName or not price then return false end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return false end
    
    local woodValue = leaderstats:FindFirstChild("Wood")
    if not woodValue then return false end
    
    if woodValue.Value >= price then
        if _G.AddWood then
            _G.AddWood(player, -price)
        end
        return true
    end
    
    return false
end

print("✅ PurchasePowerEvent creado")
