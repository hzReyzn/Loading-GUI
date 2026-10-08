-- S&NC HUB Loading UI | generated from roblox/SNCLoading | run as a LocalScript

local factories, cache = {}, {}
local function use(name)
    if cache[name] == nil then cache[name] = factories[name]() end
    return cache[name]
end

factories["Config"] = function()
-- Central design and timeline settings. No HTTP, executor, or CoreGui dependency.
return {
    Duration = 5,
    Mode = "Demo", -- "Demo", "Manual" or "Assets"; Demo is a timed showcase.
    Hold = 0.75,
    FadeOut = 0.88,
    Stagger = 0.09,
    DropDuration = 0.54,
    Quality = "High", -- "Low" reduces particles/mist on slower phones.
    BackgroundImage = "", -- Upload assets/backgrounds/obsidian.png, then rbxassetid://ID
    Accent = Color3.fromRGB(152, 98, 255),
    DeepPurple = Color3.fromRGB(61, 18, 112),
    Silver = Color3.fromRGB(230, 220, 246),
    White = Color3.fromRGB(255, 247, 255),
    Assets = {}, -- Explicit ContentProvider targets. Do not pass all workspace descendants.
    AssetTimeout = 30,
}

end

factories["Util"] = function()
local TweenService = game:GetService("TweenService")
local Util = {}
function Util.new(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do object[key] = value end
    object.Parent = parent
    return object
end
function Util.frame(parent, properties)
    local defaults = { BackgroundTransparency = 1, BorderSizePixel = 0 }
    for key, value in pairs(properties or {}) do defaults[key] = value end
    return Util.new("Frame", defaults, parent)
end
function Util.gradient(parent, colors, rotation, transparency)
    return Util.new("UIGradient", {
        Color = colors, Rotation = rotation or 0,
        Transparency = transparency or NumberSequence.new(0),
    }, parent)
end
function Util.fadeEnds()
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.48, 0),
        NumberSequenceKeypoint.new(0.52, 0), NumberSequenceKeypoint.new(1, 1),
    })
end
function Util.tween(ctx, object, seconds, properties, style, direction)
    local tween = TweenService:Create(object, TweenInfo.new(seconds,
        style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out), properties)
    ctx.tweens[tween] = true
    tween.Completed:Once(function()
        ctx.tweens[tween] = nil
        task.defer(function() tween:Destroy() end)
    end)
    tween:Play()
    return tween
end
function Util.task(ctx, fn)
    local thread
    thread = coroutine.create(function()
        local ok, err = pcall(fn)
        ctx.tasks[coroutine.running()] = nil
        if not ok and ctx.alive then warn("S&NC Loading UI: " .. tostring(err)) end
    end)
    ctx.tasks[thread] = true
    task.spawn(thread)
    return thread
end
function Util.glow(parent, color, size, position, transparency)
    -- Built-in Roblox particle texture, so the fallback needs no uploaded assets.
    return Util.new("ImageLabel", {
        BackgroundTransparency = 1, BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5), Position = position,
        Size = size, Image = "rbxasset://textures/particles/smoke_main.dds",
        ImageColor3 = color, ImageTransparency = transparency or 0.7,
        ScaleType = Enum.ScaleType.Stretch,
    }, parent)
end
function Util.spark(parent, color, size, position)
    local star = Util.frame(parent, { AnchorPoint = Vector2.new(0.5, 0.5), Position = position, Size = UDim2.fromOffset(size, size) })
    local h = Util.frame(star, { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromScale(0, 0.5), BackgroundTransparency = 0, BackgroundColor3 = color })
    Util.gradient(h, ColorSequence.new(color), 0, Util.fadeEnds())
    local v = Util.frame(star, { Size = UDim2.new(0, 1, 1, 0), Position = UDim2.fromScale(0.5, 0), BackgroundTransparency = 0, BackgroundColor3 = color })
    Util.gradient(v, ColorSequence.new(color), 90, Util.fadeEnds())
    local dot = Util.frame(star, { Size = UDim2.fromOffset(3, 3), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), Rotation = 45, BackgroundColor3 = color, BackgroundTransparency = 0 })
    return { root = star, h = h, v = v, dot = dot }
end
function Util.setSpark(star, alpha)
    local transparency = 1 - math.clamp(alpha, 0, 1)
    star.h.BackgroundTransparency = transparency
    star.v.BackgroundTransparency = transparency
    star.dot.BackgroundTransparency = transparency
end
return Util

end

factories["Background"] = function()
local U = use("Util")
local Background = {}
function Background.create(ctx, parent)
    local cfg = ctx.config
    local root = U.frame(parent, { Size = UDim2.fromScale(1, 1) })
    local image
    if cfg.BackgroundImage ~= "" then
        image = U.new("ImageLabel", {
            Size = UDim2.new(1, 44, 1, 44), Position = UDim2.fromOffset(-22, -22),
            BackgroundTransparency = 1, Image = cfg.BackgroundImage,
            ImageTransparency = 1, ScaleType = Enum.ScaleType.Crop,
        }, root)
    end
    local fallback = U.frame(root, { Size = UDim2.fromScale(1, 1) })
    local haze = {}
    for i = 1, (cfg.Quality == "Low" and 4 or 7) do
        local side = i % 2 == 0 and 0.88 or 0.12
        local glow = U.glow(fallback, cfg.Accent,
            UDim2.fromScale(0.62, 0.52), UDim2.fromScale(side, 0.12 + i * 0.10), 1)
        haze[i] = { object = glow, x = side, y = 0.12 + i * 0.10 }
    end
    -- Faceted obsidian silhouettes: three independently shaded planes per crystal.
    local crystals = {}
    for i = 1, 16 do
        local left = i <= 8
        local n = (i - 1) % 8
        local x = left and (-0.035 + n * 0.018) or (1.035 - n * 0.018)
        local y = 0.06 + n * 0.14
        local shard = U.frame(fallback, {
            Position = UDim2.fromScale(x, y), AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromScale(0.055 + (n % 3) * 0.027, 0.20 + (n % 4) * 0.055),
            Rotation = left and (-38 + n * 9) or (38 - n * 9),
            BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(15, 8, 23),
        })
        U.gradient(shard, ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 1, 9)),
            ColorSequenceKeypoint.new(0.44, Color3.fromRGB(36, 18, 62)),
            ColorSequenceKeypoint.new(0.49, Color3.fromRGB(121, 77, 187)),
            ColorSequenceKeypoint.new(0.53, Color3.fromRGB(18, 7, 31)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 1, 5)),
        }), 24)
        local facet = U.frame(shard, { Size = UDim2.new(0.26, 0, 1, 0), Position = UDim2.fromScale(0.16, 0), BackgroundTransparency = 0.35, BackgroundColor3 = cfg.Accent })
        U.gradient(facet, ColorSequence.new(cfg.White, cfg.DeepPurple), 90,
            NumberSequence.new({ NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.3,0.5),NumberSequenceKeypoint.new(1,1) }))
        crystals[i] = { object = shard, x = x, y = y }
    end
    local floor = U.frame(fallback, {
        Size = UDim2.fromScale(1, 0.23), Position = UDim2.fromScale(0, 0.77),
        BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(10, 3, 20),
    })
    U.gradient(floor, ColorSequence.new(Color3.fromRGB(12, 4, 26), Color3.new(0,0,0)),90)
    for i = 1, 14 do
        local line = U.frame(floor, { Size = UDim2.fromScale(0.24 + i * 0.043, 0.003 + i * 0.0007), Position = UDim2.fromScale(0.5, (i/15)^1.8), AnchorPoint=Vector2.new(0.5,0), BackgroundTransparency = 0.55+i*0.022, BackgroundColor3 = cfg.Accent })
        U.gradient(line, ColorSequence.new(cfg.Accent),0,U.fadeEnds())
    end
    local particles = {}
    for i = 1, (cfg.Quality == "Low" and 14 or 28) do
        local seed = (i * 0.6180339) % 1
        local mote = U.frame(root, { Size = UDim2.fromOffset(1+seed*3, 1+seed*3), BackgroundTransparency = 1, BackgroundColor3 = i%5==0 and cfg.White or cfg.Accent, Rotation = 45 })
        particles[i] = { object = mote, seed = seed }
    end
    local api = {}
    function api.update(time, reveal)
        local usingImage = image ~= nil and image.IsLoaded
        fallback.Visible = not usingImage
        if image then
            image.ImageTransparency = 1 - reveal
            image.Position = UDim2.fromOffset(-22 + math.sin(time*0.16)*5, -22 + math.cos(time*0.13)*3)
        end
        for i, h in ipairs(haze) do
            h.object.Position = UDim2.fromScale(h.x + math.sin(time*0.12+i)*0.015,h.y+math.cos(time*0.14+i)*0.012)
            h.object.Rotation = math.sin(time*0.1+i)*14
            h.object.ImageTransparency = 1 - reveal*(0.25+math.sin(time*0.3+i)*0.035)
        end
        for i,p in ipairs(particles) do
            local life = (i*0.127+time*(0.010+p.seed*0.009))%1
            p.object.Position=UDim2.new((i*0.371)%1,math.sin(time*0.32+i)*12,1-life,0)
            p.object.BackgroundTransparency=1-math.sin(life*math.pi)*(0.18+p.seed*0.38)*reveal
        end
    end
    return api
end
return Background

end

factories["NeonFrame"] = function()
local U = use("Util")
local NeonFrame = {}
function NeonFrame.create(ctx, parent)
    local cfg = ctx.config
    local root=U.frame(parent,{Size=UDim2.new(1,-28,1,-28),Position=UDim2.fromOffset(14,14)})
    local colors=ColorSequence.new({
        ColorSequenceKeypoint.new(0, cfg.DeepPurple),
        ColorSequenceKeypoint.new(0.30, cfg.Accent),
        ColorSequenceKeypoint.new(0.48, cfg.White),
        ColorSequenceKeypoint.new(0.56, cfg.Silver),
        ColorSequenceKeypoint.new(0.72, cfg.Accent),
        ColorSequenceKeypoint.new(1, cfg.DeepPurple),
    })
    local edges={}
    local specs={
        {UDim2.new(1,0,0,1),UDim2.fromScale(0,0),0,90,UDim2.new(1,0,0,80),UDim2.fromScale(0,0)},
        {UDim2.new(0,1,1,0),UDim2.fromScale(1,0),90,180,UDim2.new(0,80,1,0),UDim2.new(1,-80,0,0)},
        {UDim2.new(1,0,0,1),UDim2.fromScale(0,1),180,270,UDim2.new(1,0,0,80),UDim2.new(0,0,1,-80)},
        {UDim2.new(0,1,1,0),UDim2.fromScale(0,0),270,0,UDim2.new(0,80,1,0),UDim2.fromScale(0,0)},
    }
    for i,s in ipairs(specs) do
        local light=U.frame(root,{Size=s[1],Position=s[2],BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.2})
        local gradient=U.gradient(light,colors,s[3])
        local wash=U.frame(root,{Size=s[5],Position=s[6],BackgroundColor3=cfg.Accent,BackgroundTransparency=0.8})
        U.gradient(wash,ColorSequence.new(cfg.Accent),s[4],NumberSequence.new({NumberSequenceKeypoint.new(0,0.15),NumberSequenceKeypoint.new(0.25,0.65),NumberSequenceKeypoint.new(1,1)}))
        edges[i]={gradient=gradient,line=light,wash=wash}
    end
    -- Four localized reflections move clockwise around the perimeter.
    local heads={}
    for i=1,4 do heads[i]=U.glow(root,cfg.Silver,UDim2.fromOffset(200,110),UDim2.fromScale(0,0),0.8) end
    return { update=function(time,reveal)
        for i,e in ipairs(edges) do
            local p=math.sin(time*0.22+(i-1)*math.pi/2)*0.55
            e.gradient.Offset=Vector2.new(p,0)
            e.line.BackgroundTransparency=1-reveal*(0.45+0.25*(0.5+0.5*math.cos(time*0.25+i)))
            e.wash.BackgroundTransparency=1-reveal*(0.09+0.045*math.sin(time*0.22+i))
        end
        local w,h=root.AbsoluteSize.X,root.AbsoluteSize.Y
        local perimeter=2*(w+h)
        if perimeter <= 0 then return end
        for i,head in ipairs(heads) do
            local s=((time*0.038+(i-1)*0.25)%1)*perimeter
            local x,y
            if s<w then x,y=s,0
            elseif s<w+h then x,y=w,s-w
            elseif s<2*w+h then x,y=2*w+h-s,h
            else x,y=0,perimeter-s end
            head.Position=UDim2.fromOffset(x,y)
            head.ImageTransparency=1-reveal*0.18
        end
    end }
end
return NeonFrame

end

factories["AnimatedLogo"] = function()
local U = use("Util")
local AnimatedLogo = {}
function AnimatedLogo.create(ctx, parent)
    local cfg=ctx.config
    local root=U.frame(parent,{Size=UDim2.fromOffset(900,388),Position=UDim2.fromOffset(510,270)})
    local bloom=U.glow(root,cfg.Accent,UDim2.fromOffset(1000,470),UDim2.fromScale(0.5,0.5),1)
    local emblem=U.spark(root,cfg.Silver,56,UDim2.new(0.5,0,0,-5)); U.setSpark(emblem,0)
    local letters={}
    local specs={
        {"S",94,10,155,248,212},{"&",249,10,188,248,212},
        {"N",437,10,192,248,212},{"C",629,10,177,248,212},
        {"H",278,254,98,112,98},{"U",401,254,98,112,98},{"B",524,254,98,112,98},
    }
    local chrome=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(250,244,255)),
        ColorSequenceKeypoint.new(0.39,Color3.fromRGB(160,139,186)),
        ColorSequenceKeypoint.new(0.46,Color3.fromRGB(32,15,52)),
        ColorSequenceKeypoint.new(0.56,Color3.fromRGB(242,225,255)),
        ColorSequenceKeypoint.new(0.77,Color3.fromRGB(134,101,171)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(51,18,88)),
    })
    for i,s in ipairs(specs) do
        local item=U.frame(root,{Size=UDim2.fromOffset(s[4],s[5]),Position=UDim2.fromOffset(s[2],s[3]-64)})
        local glow=U.glow(item,cfg.Accent,UDim2.fromScale(1.5,1.1),UDim2.fromScale(0.5,0.5),1)
        local shadow=U.new("TextLabel",{Size=UDim2.fromScale(1,1),Position=UDim2.fromOffset(0,3),BackgroundTransparency=1,Text=s[1],Font=Enum.Font.Antique,TextSize=s[6],TextColor3=cfg.DeepPurple,TextTransparency=1,TextStrokeColor3=cfg.Accent,TextStrokeTransparency=1},item)
        local text=shadow:Clone();text.Position=UDim2.fromOffset(0,0);text.TextColor3=Color3.new(1,1,1);text.Parent=item
        U.gradient(text,chrome,90)
        local shine=shadow:Clone();shine.Position=UDim2.fromOffset(0,0);shine.TextColor3=cfg.White;shine.TextStrokeTransparency=1;shine.Parent=item
        local sweep=U.gradient(shine,ColorSequence.new(cfg.White),24,NumberSequence.new({
            NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.42,1),NumberSequenceKeypoint.new(0.49,0),NumberSequenceKeypoint.new(0.55,0.2),NumberSequenceKeypoint.new(0.63,1),NumberSequenceKeypoint.new(1,1),
        }))
        sweep.Offset=Vector2.new(-1,0)
        local star=U.spark(item,cfg.White,s[6]*0.45,UDim2.fromScale(0.64,0.27)); U.setSpark(star,0)
        letters[i]={item=item,shadow=shadow,text=text,shine=shine,sweep=sweep,glow=glow,star=star,spec=s,landedAt=nil}
    end
    local api={startedAt=nil}
    function api.play()
        api.startedAt=ctx.time
        U.tween(ctx,bloom,0.8,{ImageTransparency=0.88})
        U.setSpark(emblem,0.38)
        for i,letter in ipairs(letters) do
            U.task(ctx,function()
                task.wait((i-1)*cfg.Stagger)
                if not ctx.alive then return end
                U.tween(ctx,letter.text,0.26,{TextTransparency=0,TextStrokeTransparency=0.7})
                U.tween(ctx,letter.shadow,0.26,{TextTransparency=0.12,TextStrokeTransparency=0.55})
                U.tween(ctx,letter.glow,0.35,{ImageTransparency=0.88})
                local drop=U.tween(ctx,letter.item,cfg.DropDuration,{Position=UDim2.fromOffset(letter.spec[2],letter.spec[3])})
                drop.Completed:Wait()
                if not ctx.alive then return end
                letter.landedAt=ctx.time
                letter.shine.TextTransparency=0
                U.tween(ctx,letter.sweep,0.31,{Offset=Vector2.new(1,0)},Enum.EasingStyle.Cubic)
                U.tween(ctx,letter.shine,0.5,{TextTransparency=1},Enum.EasingStyle.Cubic)
                letter.glow.ImageTransparency=0.5
                U.tween(ctx,letter.glow,0.58,{ImageTransparency=0.9},Enum.EasingStyle.Cubic)
                if i==7 then
                    bloom.ImageTransparency=0.54
                    U.tween(ctx,bloom,0.65,{ImageTransparency=0.88},Enum.EasingStyle.Cubic)
                end
            end)
        end
    end
    function api.update(time)
        for _,letter in ipairs(letters) do
            if letter.landedAt then
                local age=time-letter.landedAt
                U.setSpark(letter.star,math.max(0,1-age/0.58)^3)
                letter.star.root.Position=UDim2.fromScale(0.30+math.min(1,age/0.31)*0.45,0.27)
            end
        end
    end
    return api
end
return AnimatedLogo

end

factories["LoadingBar"] = function()
local U=use("Util")
local LoadingBar={}
function LoadingBar.create(ctx,parent)
    local cfg=ctx.config
    local root=U.new("CanvasGroup",{Size=UDim2.fromOffset(840,130),Position=UDim2.fromOffset(580,692),BackgroundTransparency=1,GroupTransparency=1},parent)
    local glow=U.glow(root,cfg.Accent,UDim2.fromOffset(770,90),UDim2.fromOffset(380,41),0.64)
    local rim=U.frame(root,{Position=UDim2.fromOffset(30,24),Size=UDim2.fromOffset(700,34),BackgroundTransparency=0,BackgroundColor3=Color3.new(1,1,1)})
    U.new("UICorner",{CornerRadius=UDim.new(0,17)},rim)
    U.gradient(rim,ColorSequence.new({ColorSequenceKeypoint.new(0,cfg.Silver),ColorSequenceKeypoint.new(0.4,cfg.DeepPurple),ColorSequenceKeypoint.new(0.72,cfg.Accent),ColorSequenceKeypoint.new(1,cfg.Silver)}),90)
    local track=U.frame(rim,{Position=UDim2.fromOffset(2,2),Size=UDim2.new(1,-4,1,-4),BackgroundTransparency=0.08,BackgroundColor3=Color3.fromRGB(6,3,14)})
    U.new("UICorner",{CornerRadius=UDim.new(0,15)},track)
    local clip=U.frame(rim,{Position=UDim2.fromOffset(5,5),Size=UDim2.fromOffset(0,24),ClipsDescendants=true})
    local fill=U.frame(clip,{Size=UDim2.fromOffset(690,24),BackgroundTransparency=0,BackgroundColor3=Color3.new(1,1,1)})
    U.new("UICorner",{CornerRadius=UDim.new(0,12)},fill)
    local energy=U.gradient(fill,ColorSequence.new({ColorSequenceKeypoint.new(0,cfg.DeepPurple),ColorSequenceKeypoint.new(0.3,cfg.Accent),ColorSequenceKeypoint.new(0.54,cfg.Silver),ColorSequenceKeypoint.new(0.7,cfg.Accent),ColorSequenceKeypoint.new(1,cfg.DeepPurple)}),0)
    local veins={}
    for i=1,10 do
        local vein=U.frame(fill,{Size=UDim2.fromOffset(98,2),Position=UDim2.fromOffset(i*70,10),Rotation=(i%2==0 and 9 or -11),BackgroundTransparency=0.45,BackgroundColor3=cfg.Silver})
        U.gradient(vein,ColorSequence.new(cfg.White),0,U.fadeEnds());veins[i]=vein
    end
    local sheen=U.frame(fill,{Size=UDim2.fromOffset(65,40),Position=UDim2.fromOffset(-70,-8),Rotation=15,BackgroundTransparency=0.55,BackgroundColor3=cfg.White})
    U.gradient(sheen,ColorSequence.new(cfg.White),0,U.fadeEnds())
    local head=U.glow(root,cfg.White,UDim2.fromOffset(60,52),UDim2.fromOffset(35,41),1)
    local percent=U.new("TextLabel",{Position=UDim2.fromOffset(748,25),Size=UDim2.fromOffset(60,32),BackgroundTransparency=1,Text="0%",Font=Enum.Font.Gotham,TextSize=17,TextColor3=cfg.Silver,TextXAlignment=Enum.TextXAlignment.Left},root)
    local caption=U.new("TextLabel",{Position=UDim2.fromOffset(30,81),Size=UDim2.fromOffset(700,36),BackgroundTransparency=1,Text="L O A D I N G   H U B",Font=Enum.Font.Gotham,TextSize=20,TextColor3=cfg.Silver},root)
    local previous=-1
    return {
        show=function() U.tween(ctx,root,0.42,{GroupTransparency=0}) end,
        update=function(time,progress)
            clip.Size=UDim2.fromOffset(690*progress,24)
            head.Position=UDim2.fromOffset(35+690*progress,41)
            head.ImageTransparency=progress>0.002 and 0.65 or 1
            energy.Offset=Vector2.new(math.sin(time*0.6)*0.45,0)
            sheen.Position=UDim2.fromOffset((time*160)%850-80,-8)
            for i,v in ipairs(veins) do
                v.Position=UDim2.fromOffset((i*75-time*(26+i*2))%820-100,11+math.sin(time*1.6+i)*7)
                v.Rotation=math.sin(time*0.7+i)*12
            end
            caption.TextTransparency=0.14+math.sin(time*1.8)*0.08
            local number=math.min(100,math.floor(progress*100+0.00001))
            if number~=previous then percent.Text=tostring(number).."%";previous=number end
        end,
    }
end
return LoadingBar

end

factories["Controller"] = function()
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local ContentProvider=game:GetService("ContentProvider")
local U=use("Util")
local Defaults=use("Config")
local Background=use("Background")
local NeonFrame=use("NeonFrame")
local AnimatedLogo=use("AnimatedLogo")
local LoadingBar=use("LoadingBar")
local Controller={}

function Controller.start(options)
    assert(RunService:IsClient(),"S&NC Loading UI must run from a LocalScript")
    local config=table.clone(Defaults)
    for k,v in pairs(options or {}) do config[k]=v end
    config.Duration=math.max(0.25,tonumber(config.Duration) or 5)
    config.Hold=math.max(0,tonumber(config.Hold) or 0.75)
    config.FadeOut=math.max(0.1,tonumber(config.FadeOut) or 0.88)
    assert(config.Mode=="Demo" or config.Mode=="Manual" or config.Mode=="Assets","Unknown loading mode")
    local player=Players.LocalPlayer
    local playerGui=player:WaitForChild("PlayerGui")
    local previous=playerGui:FindFirstChild("SNCLoadingScreen")
    if previous then
        local dispose=previous:FindFirstChild("Dispose")
        if dispose and dispose:IsA("BindableEvent") then dispose:Fire() end
        previous:Destroy()
    end
    local ctx={config=config,alive=true,time=0,tweens={},tasks={},connections={},target=0,progress=0,started=false,closing=false}
    local gui=U.new("ScreenGui",{Name="SNCLoadingScreen",IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=1000,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},playerGui)
    local dispose=U.new("BindableEvent",{Name="Dispose"},gui)
    local finished=Instance.new("BindableEvent")
    local outcome=nil
    local group=U.new("CanvasGroup",{Name="Scene",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(3,1,6),BorderSizePixel=0,GroupTransparency=0},gui)
    local background=Background.create(ctx,group)
    local stage=U.frame(group,{Name="Design1920",Size=UDim2.fromOffset(1920,1080),Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5)})
    local scale=U.new("UIScale",{Scale=1},stage)
    local logo=AnimatedLogo.create(ctx,stage)
    local bar=LoadingBar.create(ctx,stage)
    local frame=NeonFrame.create(ctx,group)
    local flash=U.glow(stage,config.White,UDim2.fromOffset(1400,850),UDim2.fromScale(0.5,0.5),1)
    local black=U.frame(group,{Name="IntroBlack",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0,ZIndex=100})
    local api={}
    local function resize()
        local size=group.AbsoluteSize
        scale.Scale=math.min(size.X/1920,size.Y/1080)
    end
    resize()
    table.insert(ctx.connections,group:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize))
    local function cleanup(reason)
        if not ctx.alive then return end
        ctx.alive=false
        outcome=reason or "cancelled"
        for _,connection in ipairs(ctx.connections) do connection:Disconnect() end
        for tween in pairs(ctx.tweens) do tween:Cancel() end
        table.clear(ctx.tweens)
        local current=coroutine.running()
        for thread in pairs(ctx.tasks) do
            if thread~=current and coroutine.status(thread)~="dead" then pcall(task.cancel,thread) end
        end
        table.clear(ctx.tasks)
        finished:Fire(outcome)
        -- The signal is no longer needed once all waiters have been resumed.
        task.defer(function() finished:Destroy() end)
        gui:Destroy()
    end
    function api.Destroy() cleanup("cancelled") end
    function api.SetProgress(value)
        if not ctx.alive or ctx.closing or config.Mode=="Demo" then return end
        if type(value)~="number" or value~=value then return end
        ctx.target=math.max(ctx.target,math.clamp(value,0,1))
    end
    function api.Complete() api.SetProgress(1) end
    function api.AwaitFinished()
        if outcome then return outcome end
        return finished.Event:Wait()
    end
    table.insert(ctx.connections,dispose.Event:Connect(api.Destroy))
    table.insert(ctx.connections,gui.Destroying:Connect(function() cleanup("cancelled") end))
    local function beginOutro()
        if ctx.closing or not ctx.alive then return end
        ctx.closing=true
        U.task(ctx,function()
            task.wait(config.Hold)
            if not ctx.alive then return end
            local pulse=U.tween(ctx,flash,0.11,{ImageTransparency=0.76},Enum.EasingStyle.Cubic)
            pulse.Completed:Wait()
            if not ctx.alive then return end
            U.tween(ctx,flash,0.5,{ImageTransparency=1},Enum.EasingStyle.Cubic)
            local fade=U.tween(ctx,group,config.FadeOut,{GroupTransparency=1},Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut)
            fade.Completed:Wait()
            if ctx.alive then cleanup("completed") end
        end)
    end
    local loadingStarted=0
    table.insert(ctx.connections,RunService.RenderStepped:Connect(function(dt)
        ctx.time=ctx.time+dt
        local reveal=math.clamp((ctx.time-0.12)/0.8,0,1)
        background.update(ctx.time,reveal)
        frame.update(ctx.time,reveal)
        logo.update(ctx.time)
        if ctx.started and not ctx.closing then
            if config.Mode=="Demo" then
                local t=math.clamp((ctx.time-loadingStarted)/config.Duration,0,1)
                ctx.progress=0.5-0.5*math.cos(t*math.pi)
                if t>=1 then ctx.progress=1 end
            else
                ctx.progress=ctx.progress+(ctx.target-ctx.progress)*(1-math.exp(-dt*14))
                if ctx.target>=1 and ctx.progress>0.9995 then ctx.progress=1 end
            end
            if ctx.progress>=1 then beginOutro() end
        end
        bar.update(ctx.time,ctx.progress)
    end))
    U.task(ctx,function()
        task.wait(0.12)
        if not ctx.alive then return end
        local reveal=U.tween(ctx,black,0.8,{BackgroundTransparency=1},Enum.EasingStyle.Cubic)
        reveal.Completed:Wait()
        if not ctx.alive then return end
        logo.play()
        task.wait(config.DropDuration+6*config.Stagger+0.22)
        if not ctx.alive then return end
        bar.show()
        task.wait(0.42)
        if not ctx.alive then return end
        ctx.started=true;loadingStarted=ctx.time
        if config.Mode=="Assets" then
            U.task(ctx,function()
                if not game:IsLoaded() then game.Loaded:Wait() end
                if not ctx.alive then return end
                local targets=config.Assets
                local count=#targets
                for i,asset in ipairs(targets) do
                    if not ctx.alive then return end
                    local ok,err=pcall(function() ContentProvider:PreloadAsync({asset}) end)
                    if not ok then warn("S&NC asset unavailable: "..tostring(err)) end
                    api.SetProgress(i/math.max(1,count))
                end
                api.Complete()
            end)
            U.task(ctx,function()
                task.wait(math.max(1,config.AssetTimeout))
                if ctx.alive and not ctx.closing then
                    -- Exit a stalled visual loader; this does not claim assets loaded successfully.
                    warn("S&NC Loading UI asset timeout; closing the loader")
                    cleanup("timeout")
                end
            end)
        end
    end)
    return api
end
return Controller

end

local loader = use("Controller").start()
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()
loader.AwaitFinished()
-- Your hub can start here.
