-- HzReyzn Halloween Loading UI | client
-- Visual progress is time-based; integrate real readiness before enabling continuation if required.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local old = guiParent:FindFirstChild("HzReyznHalloween")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "HzReyznHalloween"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = guiParent

local function obj(class, props, parent)
    local x = Instance.new(class)
    for k,v in pairs(props) do x[k] = v end
    x.Parent = parent
    return x
end
local function tween(x,t,props,style)
    local a = TweenService:Create(x,TweenInfo.new(t,style or Enum.EasingStyle.Sine,Enum.EasingDirection.Out),props)
    a:Play()
    return a
end
local function gradient(parent, colors, rotation)
    return obj("UIGradient",{Color=ColorSequence.new(colors),Rotation=rotation or 0},parent)
end
local bg = obj("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(7,5,15),BorderSizePixel=0},gui)
gradient(bg,{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(11,6,22)),
    ColorSequenceKeypoint.new(.52,Color3.fromRGB(35,9,29)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(10,5,17))
},20)

local ambient = obj("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(.92,.78),BackgroundColor3=Color3.fromRGB(110,23,64),BackgroundTransparency=.88,BorderSizePixel=0},bg)
obj("UICorner",{CornerRadius=UDim.new(1,0)},ambient)
local glow = obj("UIStroke",{Color=Color3.fromRGB(252,90,28),Transparency=.82,Thickness=3},ambient)
local panel = obj("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.new(.82,0,0,310),BackgroundColor3=Color3.fromRGB(13,9,24),BackgroundTransparency=.14,BorderSizePixel=0},bg)
obj("UISizeConstraint",{MaxSize=Vector2.new(680,310),MinSize=Vector2.new(270,260)},panel)
obj("UICorner",{CornerRadius=UDim.new(0,22)},panel)
local border = obj("UIStroke",{Thickness=2,Color=Color3.fromRGB(240,82,27),Transparency=.18},panel)
gradient(border,{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(255,124,32)),
    ColorSequenceKeypoint.new(.5,Color3.fromRGB(180,55,142)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(255,67,39))
},0)

local scale = obj("UIScale",{Scale=.94},panel)
tween(scale,.75,{Scale=1},Enum.EasingStyle.Quint)
local eyebrow = obj("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,18,0,25),Size=UDim2.new(1,-36,0,24),Font=Enum.Font.GothamBold,Text="HALLOWEEN  //  LIMITED EDITION",TextSize=12,TextColor3=Color3.fromRGB(238,136,188),TextTransparency=1},panel)
local title = obj("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,12,0,67),Size=UDim2.new(1,-24,0,60),Font=Enum.Font.GothamBlack,Text="HzReyzn Hub",TextScaled=true,TextColor3=Color3.fromRGB(255,166,73),TextTransparency=1},panel)
obj("UITextSizeConstraint",{MaxTextSize=47,MinTextSize=21},title)
gradient(title,{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(255,223,143)),
    ColorSequenceKeypoint.new(.45,Color3.fromRGB(255,107,33)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(218,61,139))
},0)
local titleStroke = obj("UIStroke",{Color=Color3.fromRGB(78,13,32),Thickness=1.5,Transparency=.3},title)
local subtitle = obj("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,15,0,132),Size=UDim2.new(1,-30,0,25),Font=Enum.Font.GothamMedium,Text="THE NIGHT IS JUST BEGINNING",TextSize=13,TextColor3=Color3.fromRGB(196,172,202),TextTransparency=1},panel)
local barBack = obj("Frame",{Position=UDim2.new(.08,0,0,201),Size=UDim2.new(.84,0,0,13),BackgroundColor3=Color3.fromRGB(47,31,55),BorderSizePixel=0},panel)
obj("UICorner",{CornerRadius=UDim.new(1,0)},barBack)
local bar = obj("Frame",{Size=UDim2.fromScale(0,1),BackgroundColor3=Color3.fromRGB(255,113,41),BorderSizePixel=0},barBack)
obj("UICorner",{CornerRadius=UDim.new(1,0)},bar)
gradient(bar,{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(254,83,43)),
    ColorSequenceKeypoint.new(.5,Color3.fromRGB(255,179,62)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(225,69,163))
},0)
local percent = obj("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(.08,0,0,222),Size=UDim2.new(.84,0,0,24),Font=Enum.Font.GothamBold,Text="LOADING HUB  •  0%",TextSize=14,TextColor3=Color3.fromRGB(255,200,155)},panel)
local continue = obj("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(.04,0,0,256),Size=UDim2.new(.92,0,0,26),Font=Enum.Font.GothamBold,Text="CLICK ANYWHERE TO CONTINUE",TextSize=13,TextColor3=Color3.fromRGB(255,193,95),TextTransparency=1},panel)

local particles = {}
local rng = Random.new()
for i=1,25 do
    local size = rng:NextInteger(2,6)
    local p = obj("Frame",{Size=UDim2.fromOffset(size,size),Position=UDim2.fromScale(rng:NextNumber(),rng:NextNumber()),BackgroundColor3=(i%3==0 and Color3.fromRGB(211,82,177) or Color3.fromRGB(255,123,48)),BackgroundTransparency=rng:NextNumber(.35,.75),BorderSizePixel=0},bg)
    obj("UICorner",{CornerRadius=UDim.new(1,0)},p)
    particles[#particles+1]={part=p,x=p.Position.X.Scale,y=p.Position.Y.Scale,speed=rng:NextNumber(.006,.022)}
end
panel.ZIndex = 3
for _,v in ipairs(panel:GetDescendants()) do
    if v:IsA("GuiObject") then v.ZIndex = 4 end
end
local alive = true
local elapsed = 0
local conn
conn = RunService.RenderStepped:Connect(function(dt)
    if not alive then return end
    elapsed += dt
    border.Transparency = .2 + .16 * (1+math.sin(elapsed*1.6)) / 2
    glow.Transparency = .76 + .12 * math.sin(elapsed*1.2)
    for _,p in ipairs(particles) do
        p.y -= dt*p.speed
        if p.y < -.03 then p.y=1.03 end
        p.part.Position = UDim2.fromScale(p.x + math.sin(elapsed*.6+p.x*12)*.012,p.y)
    end
end)
tween(eyebrow,.8,{TextTransparency=0})
tween(title,1,{TextTransparency=0})
tween(subtitle,1.2,{TextTransparency=0})

local completed = false
local closing = false
local function flash()
    local overlay = obj("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(255,207,160),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=15},panel)
    tween(overlay,.15,{BackgroundTransparency=.84})
    task.delay(.15,function()
        if overlay.Parent then
            local a=tween(overlay,.5,{BackgroundTransparency=1})
            a.Completed:Once(function() if overlay then overlay:Destroy() end end)
        end
    end)
end
local duration = 5.5
local start = os.clock()
while gui.Parent and not completed do
    local value = math.clamp((os.clock()-start)/duration,0,1)
    bar.Size = UDim2.fromScale(value,1)
    percent.Text = ("LOADING HUB  •  %d%%"):format(math.floor(value*100+.001))
    if value >= 1 then completed=true break end
    task.wait(.03)
end
if gui.Parent then
    bar.Size=UDim2.fromScale(1,1)
    percent.Text="LOADING COMPLETED  •  100%"
    tween(continue,.55,{TextTransparency=0})
    flash()
end
task.spawn(function()
    while alive and not closing do
        task.wait(3)
        if completed and not closing and gui.Parent then
            flash()
            tween(continue,.18,{TextTransparency=.35})
            task.wait(.18)
            if not closing and continue.Parent then tween(continue,.35,{TextTransparency=0}) end
        end
    end
end)
local function close()
    if not completed or closing then return end
    closing = true
    tween(scale,.8,{Scale=1.045},Enum.EasingStyle.Quint)
    for _,x in ipairs(gui:GetDescendants()) do
        if x:IsA("TextLabel") then tween(x,.85,{TextTransparency=1})
        elseif x:IsA("Frame") then tween(x,.85,{BackgroundTransparency=1})
        elseif x:IsA("UIStroke") then tween(x,.85,{Transparency=1}) end
    end
    task.wait(.9)
    alive=false
    if conn then conn:Disconnect() end
    gui:Destroy()
end
local clickArea = obj("TextButton",{Text="",AutoButtonColor=false,BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=20},gui)
clickArea.Activated:Connect(function() task.spawn(close) end)
-- UI is clickable on both touch and mouse once 100% is reached.
