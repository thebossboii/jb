--[[
Made by IAteYourDog#4864
[ Update: Hashes ]
]]
if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(1)

if not getgc then
    game.Players.LocalPlayer:Kick("Exploit not supported")
    wait(9e9)
end

local ServerNet = debug.getupvalue(require(game:GetService("ReplicatedStorage").Module.AlexChassis).SetEvent, 1)

--My serverhop might be buggy
local function serverhop(er)
    local api = game:HttpGet("https://games.roblox.com/v1/games/606849621/servers/Public?limit=100&sortOrder=Asc",true)
    for _,i in ipairs(game:GetService("HttpService"):JSONDecode(api).data) do
        pcall(function()
            if i.maxPlayers > i.playing and i.ping < 400 and i.id ~= game.JobId then
                warn("Teleporting")
                --Hah, now no autoban
                if er and er == "err" then
                    game.Players.LocalPlayer:Kick("Script currently patched or using or this is an old server")
                else
                    game.Players.LocalPlayer:Kick("Teleporting")
                end
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,i.id)
            end
        end)
    end
end

local queuemethods = (syn and syn.queue_on_teleport) or queue_on_teleport
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
     queuemethods('getgenv().fast='..tostring(getgenv().fast)..' loadstring(game:HttpGet("https://pastebin.com/raw/Q7BuM0Us",true))()')
    end
end)

local attempts = 0
repeat 
    pcall(function()
        --Get team swith hash 
        ServerNet:FireServer("ccabdc0a","Police")
        attempts = attempts + 1
        if attempts > 15 then
            serverhop("err")
        end
    end)
    wait(0.4)
until game.Players.LocalPlayer.Team == game:GetService("Teams").Police

wait(3)

for _,v in pairs(game:GetService("Workspace").Buildings:GetDescendants()) do
    if v:IsA("Texture") then
        v.Parent.CanCollide = false
    end
end

for _,v in pairs(getgc(true)) do
    if typeof(v) == "table" then
        --Equip
        if rawget(v,"Name") and rawget(v,"Frame") and v.Name == "Handcuffs" then Handcuffs = v end
        --No ragdoll
        if rawget(v, 'Ragdoll') then v.Ragdoll = function(...) return wait(9e9) end end
    end
end

local function equipHandcuffs()
    require(game:GetService("ReplicatedStorage").Game.ItemSystem.ItemSystem).Equip(game.Players.LocalPlayer, Handcuffs)
end

local function ejectPlayer(plr)
    --Get eject hash
    ServerNet:FireServer("dd8f85a1",plr.Name)
end

local function arrest(plr)
    --Get arrest hash
   ServerNet:FireServer("b61f7b0b",plr.Name)
end

local function setup()
    pcall(function()
        --I discovered this on my own btw
        local torso = game:GetService("Players").LocalPlayer.Character.LowerTorso.Root
        torso:Clone().Parent = torso.Parent torso:Destroy()
    end)
end

local player = game.Players.LocalPlayer
local function tp(cframe)
    local ma = (cframe.p - player.Character.HumanoidRootPart.Position).magnitude
    if ma > 100 then
        equipHandcuffs()
        if player.Character.HumanoidRootPart == nil then
            repeat wait() until player.Character.HumanoidRootPart ~= nil
        end
        local character = player.character
        local root = character.HumanoidRootPart
        local distanceLeft = (cframe - cframe.p) + root.Position + Vector3.new(0,4,0)
        local distance = cframe.p - root.Position
        print(ma)
        local mag = 5
        if ma > 2900 then
            ma = 8
        end
        for count = 0, distance.magnitude, mag do
            if root == nil then
                break
            end
            root.CFrame = distanceLeft + distance.Unit * count
            root.Velocity,root.RotVelocity = Vector3.new(),Vector3.new() 
            game:GetService("RunService").Stepped:Wait()
        end
    else
        player.Character.HumanoidRootPart.CFrame = cframe
    end
end

wait(.5)
setup()
--game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,10,0)

wait(2)

local arresting = nil

--My roast function is epic
spawn(function()
    while wait(2) do
        if arresting ~= nil then
            roast(arresting)
        end
    end
end)

--Autoarrest
local plrs = game:GetService("Teams").Criminal:GetPlayers()

table.sort(plrs,function(new,old)
    return (new.Character.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude < (old.Character.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude
end)

spawn(function()
    while wait(5) do
        if game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
            equipHandcuffs()
        end
    end
end)

for _,v in next, plrs do
    --Gotta check incase the player switched teams
    if v.Team == game:GetService("Teams").Criminal then
        warn("Doing",v.Name)
        equipHandcuffs()
        --For roasts
        arresting = v
        local notarrested = tonumber(game.Players.LocalPlayer.leaderstats.Money.Value)
        spawn(function()
        end)
        for i = 0,150,1 do
            pcall(function()
                game.Workspace.Camera.CameraSubject = v.Character.HumanoidRootPart
                if game.Players.LocalPlayer.Character.Humanoid.Health < 30 then
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,10,0)
                    wait(5)
                    setup()
                end
                if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                    game.Players.LocalPlayer.Character.Humanoid.Jump = true
                end
                if i > 10 and (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 100 then
                    warn("Skipping to save time")
                    return
                end
                tp(v.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-2,2),math.random(0,0.9),math.random(-2,2)))
                wait(.1)
                if v.Character:FindFirstChild('InVehicle') then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame + Vector3.new(0,1,0)
                    for _,v in pairs(require(game:GetService("ReplicatedStorage").Module.UI).CircleAction.Specs) do
                        if v.Name == "Eject" then
                            v:Callback(v, true)
                        end
                    end
                end
                arrest(v)
                --[[for b = 0,3,1 do 
                    arrest(v)
                    tp(v.Character.HumanoidRootPart.CFrame)
                end]]
            end)
            if tonumber(game.Players.LocalPlayer.leaderstats.Money.Value) > notarrested or v.Team == game:GetService("Teams").Prisoner then
                break
            end
        end
        setup()
    end
end

while wait(5) do
    serverhop()
end
