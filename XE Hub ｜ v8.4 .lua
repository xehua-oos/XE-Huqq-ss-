-- ============================================================
-- 坤坤大帝脚本 最终稳定版（ESP彻底修复，无残留）
-- 包含：边框设置 + 通用 + 变身 + 玩家Aimbot + 玩家ESP（修复版）
-- 窗口透明度60%，彩虹边框透明度60%，白色主题
-- ============================================================

-- 加载 WindUI 核心
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xehua-oos/ui/refs/heads/main/%E8%A1%8D%E5%93%A5.lua"))()

-- ===================== 全局变量与工具函数 =====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 通知封装
local function Notify(title, content, duration)
    WindUI:Notify({ Title = title, Content = content, Duration = duration or 3 })
end

-- 复制到剪贴板
local function CopyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    elseif writeclipboard then
        writeclipboard(text)
        return true
    end
    return false
end

-- ===================== 边框设置（原 WindUI 部分） =====================
local rainbowBorderAnimation
local currentBorderColorScheme = "彩虹颜色"
local animationSpeed = 2
local borderEnabled = true

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE"))}),"palette"},
    ["黑红颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))}),"alert-triangle"},
    ["蓝白颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF"))}),"droplet"},
    ["紫金颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFD700")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700"))}),"crown"},
    ["蓝黑颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("0000FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))}),"moon"},
    ["绿紫颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("800080")),ColorSequenceKeypoint.new(1, Color3.fromHex("00FF00"))}),"zap"},
    ["粉蓝颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00BFFF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF69B4"))}),"heart"},
    ["橙青颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00CED1")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF4500"))}),"sun"},
    ["红金颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFD700")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF0000"))}),"award"},
    ["银蓝颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("4682B4")),ColorSequenceKeypoint.new(1, Color3.fromHex("C0C0C0"))}),"star"},
    ["霓虹颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(0.25, Color3.fromHex("00FFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.75, Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("00FFFF"))}),"sparkles"},
    ["森林颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("228B22")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("32CD32")),ColorSequenceKeypoint.new(1, Color3.fromHex("228B22"))}),"tree"},
    ["火焰颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF8C00"))}),"flame"},
    ["海洋颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000080")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("00BFFF"))}),"waves"},
    ["日落颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF8C00")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700"))}),"sunset"},
    ["银河颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("4B0082")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")),ColorSequenceKeypoint.new(1, Color3.fromHex("9370DB"))}),"galaxy"},
    ["糖果颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF1493")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))}),"candy"},
    ["金属颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("A9A9A9")),ColorSequenceKeypoint.new(1, Color3.fromHex("696969"))}),"shield"}
}

local function createRainbowBorder(window, colorScheme, speed)
    if not window or not window.UIElements then
        wait(1)
        if not window or not window.UIElements then
            return nil, nil
        end
    end
    
    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil, nil
    end
    
    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        local glowEffect = existingStroke:FindFirstChild("GlowEffect")
        if glowEffect then
            local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
            if schemeData then
                glowEffect.Color = schemeData[1]
            end
        end
        return existingStroke, rainbowBorderAnimation
    end
    
    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 1.5
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Enabled = borderEnabled
    rainbowStroke.Parent = mainFrame
    -- 设置彩虹边框透明度为60%
    rainbowStroke.Transparency = 0.4
    
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    
    local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["彩虹颜色"][1]
    end
    
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke
    
    return rainbowStroke, nil
end

local function startBorderAnimation(window, speed)
    if not window or not window.UIElements then
        return nil
    end
    
    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil
    end
    
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke or not rainbowStroke.Enabled then
        return nil
    end
    
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then
        return nil
    end
    
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
    
    local animation
    animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil or not rainbowStroke.Enabled then
            animation:Disconnect()
            return
        end
        
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)
    
    rainbowBorderAnimation = animation
    return animation
end

local function initializeRainbowBorder(scheme, speed)
    speed = speed or animationSpeed
    
    local rainbowStroke, _ = createRainbowBorder(Window, scheme, speed)
    if rainbowStroke then
        if borderEnabled then
            startBorderAnimation(Window, speed)
        end
        borderInitialized = true
        return true
    end
    return false
end

local function playSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://9047002353"
        sound.Volume = 0.3
        sound.Parent = game:GetService("SoundService")
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    end)
end

-- 创建 WindUI 主窗口（白色主题）
local Window = WindUI:CreateWindow({
    Title = "<font color='#FFA500'>坤坤大帝</font><font color='#FFFF00'>Hub v8.4</font>",
    IconTransparency = 0.5,
    IconThemed = true,
    Author = "作者:衍哥 & 坤坤大帝",
    Folder = "坤坤大帝Hub_Ultimate",
    Size = UDim2.fromOffset(750, 500),
    Transparent = true,
    Theme = "Light",
    User = { Enabled = true, Callback = function() print("用户信息") end, Anonymous = false },
})

-- 设置窗口背景透明度为60%
if Window.UIElements and Window.UIElements.Main then
    Window.UIElements.Main.BackgroundTransparency = 0.4
end

spawn(function()
    wait(0.5)
    initializeRainbowBorder("彩虹颜色", animationSpeed)
end)

Window:Tag({ Title = "QQ:1057787159", Color = Color3.fromHex("#FFA500") })
Window:Tag({ Title = "v8.4 ESP修复版", Color = Color3.fromHex("#0000FF") })

-- ===================== 边框设置标签页 =====================
local SettingsTab = Window:Tab({ Title = "边框设置", Icon = "palette", Locked = false })

SettingsTab:Toggle({
    Title = "启用边框",
    Desc = "开关霓虹灯边框效果",
    Default = borderEnabled,
    Callback = function(value)
        borderEnabled = value
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Enabled = value
                if value and not rainbowBorderAnimation then
                    startBorderAnimation(Window, animationSpeed)
                elseif not value and rainbowBorderAnimation then
                    rainbowBorderAnimation:Disconnect()
                    rainbowBorderAnimation = nil
                end
                WindUI:Notify({ Title = "边框", Content = value and "已启用" or "已禁用", Duration = 2 })
            end
        end
    end
})

local colorSchemeNames = {}
for name, _ in pairs(COLOR_SCHEMES) do
    table.insert(colorSchemeNames, name)
end
table.sort(colorSchemeNames)

SettingsTab:Dropdown({
    Title = "边框颜色",
    Desc = "选择喜欢的颜色组合",
    Values = colorSchemeNames,
    Value = "彩虹颜色",
    Callback = function(value)
        currentBorderColorScheme = value
        initializeRainbowBorder(value, animationSpeed)
        playSound()
    end
})

SettingsTab:Slider({
    Title = "边框转动速度",
    Desc = "调整边框旋转的快慢",
    Value = { Min = 1, Max = 10, Default = 5 },
    Callback = function(value)
        animationSpeed = value
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
        if borderEnabled then
            startBorderAnimation(Window, animationSpeed)
        end
        playSound()
    end
})

SettingsTab:Slider({
    Title = "边框粗细",
    Desc = "调整边框的粗细",
    Value = { Min = 1, Max = 5, Default = 1.5 },
    Step = 0.5,
    Callback = function(value)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Thickness = value
            end
        end
        playSound()
    end
})

SettingsTab:Slider({
    Title = "圆角大小",
    Desc = "调整UI圆角的大小",
    Value = { Min = 0, Max = 20, Default = 16 },
    Callback = function(value)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local corner = mainFrame:FindFirstChildOfClass("UICorner")
            if not corner then
                corner = Instance.new("UICorner")
                corner.Parent = mainFrame
            end
            corner.CornerRadius = UDim.new(0, value)
        end
        playSound()
    end
})

SettingsTab:Button({
    Title = "随机颜色",
    Icon = "palette",
    Callback = function()
        local randomColor = colorSchemeNames[math.random(1, #colorSchemeNames)]
        currentBorderColorScheme = randomColor
        initializeRainbowBorder(randomColor, animationSpeed)
        playSound()
    end
})

-- ===================== 通用标签页 =====================
local GeneralTab = Window:Tab({ Title = "通用", Icon = "settings", Locked = false })

-- 移动速度滑块
local speedSlider = GeneralTab:Slider({
    Title = "移动速度",
    Value = { Min = 16, Max = 600, Default = 16 },
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

-- 跳跃高度滑块
local jumpSlider = GeneralTab:Slider({
    Title = "跳跃高度",
    Value = { Min = 50, Max = 600, Default = 50 },
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = v
        end
    end
})

-- 重力滑块
local gravitySlider = GeneralTab:Slider({
    Title = "重力设置",
    Value = { Min = 0, Max = 500, Default = 196 },
    Callback = function(v)
        workspace.Gravity = v
    end
})

-- 视野缩放
GeneralTab:Slider({
    Title = "视野缩放距离",
    Value = { Min = 0, Max = 2500, Default = 128 },
    Callback = function(v)
        LocalPlayer.CameraMaxZoomDistance = v
    end
})

-- 广角设置
GeneralTab:Slider({
    Title = "广角设置",
    Value = { Min = 1, Max = 120, Default = 70 },
    Callback = function(v)
        workspace.CurrentCamera.FieldOfView = v
    end
})

-- 无限跳
local infiniteJump = false
GeneralTab:Toggle({
    Title = "无限跳",
    Default = false,
    Callback = function(v)
        infiniteJump = v
        if v then
            UserInputService.JumpRequest:Connect(function()
                if infiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState("Jumping")
                end
            end)
        end
    end
})

-- 夜视
GeneralTab:Toggle({
    Title = "夜视",
    Default = false,
    Callback = function(v)
        if v then
            Lighting.Ambient = Color3.new(1, 1, 1)
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
        end
    end
})

-- 穿墙
local noclip = false
GeneralTab:Toggle({
    Title = "穿墙模式",
    Default = false,
    Callback = function(v)
        noclip = v
        if v then
            local connection
            connection = RunService.Stepped:Connect(function()
                if not noclip then connection:Disconnect() return end
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

-- 自动互动
local autoInteract = false
GeneralTab:Toggle({
    Title = "自动互动",
    Default = false,
    Callback = function(v)
        autoInteract = v
        if v then
            spawn(function()
                while autoInteract do
                    for _, descendant in pairs(workspace:GetDescendants()) do
                        if descendant:IsA("ProximityPrompt") then
                            fireproximityprompt(descendant)
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})

-- 偷东西
GeneralTab:Button({
    Title = "一键偷别人的东西",
    Callback = function()
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                for _, b in pairs(v.Backpack:GetChildren()) do
                    b.Parent = LocalPlayer.Backpack
                end
            end
        end
    end
})

-- 飞行按钮
GeneralTab:Button({
    Title = "飞行(by天下布武)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Twbtx/tiamxiabuwu/main/t%20x%20b%20w%20fly"))()
    end
})

GeneralTab:Button({
    Title = "阿尔飞行",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/5zJu3hfN"))()
    end
})

GeneralTab:Button({
    Title = "踏空行走",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
    end
})

-- 反挂机
GeneralTab:Button({
    Title = "反挂机",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/9fFu43FF"))()
    end
})

-- 点击传送工具
GeneralTab:Button({
    Title = "点击传送工具",
    Callback = function()
        local mouse = LocalPlayer:GetMouse()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Click Teleport"
        tool.Activated:Connect(function()
            local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
        end)
        tool.Parent = LocalPlayer.Backpack
    end
})

-- ===================== 变身标签页 =====================
local TransformTab = Window:Tab({ Title = "变身", Icon = "zap", Locked = false })

local transformScripts = {
    {"John doe forsaken变身", "https://rawscripts.net/raw/Universal-Script-John-doe-forsaken-v1-58705"},
    {"无敌大摆锤变身", "https://rawscripts.net/raw/Universal-Script-Ban-Hammer-Script-58232"},
    {"Lua Hammer变身", "https://rawscripts.net/raw/Universal-Script-Lua-Hammer-56507"},
    {"Ban hammer变身", "https://rawscripts.net/raw/Universal-Script-Ban-hammer-v0-47112"},
    {"变身脚本5", "https://pastebin.com/raw/JwUdxg8y"},
    {"忍者键盘变身", "https://raw.githubusercontent.com/gObl00x/Pendulum-Fixed-AND-Others-Scripts/refs/heads/main/Server%20Admin"},
    {"Caducus The fallen god变身", "https://rawscripts.net/raw/Universal-Script-FE-Caducus-The-fallen-god-REQUIRES-REANIMATION-TO-WORK-47600"},
    {"Brick Hamman变身", "https://rawscripts.net/raw/Universal-Script-Brick-Hamman-Converted-49804"},
    {"Hacker X变身", "https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/Hacker%20X"},
    {"变身脚本10", "https://pastebin.com/raw/m7r4Qeu1"},
    {"变身脚本11", "https://raw.githubusercontent.com/TEST19983/Reslasjd/refs/heads/main/attac"},
    {"托马斯火车变身", "https://raw.githubusercontent.com/Sugm4Bullet1/LuaXXccL/refs/heads/main/Thomas"},
    {"Banisher变身", "https://raw.githubusercontent.com/retpirato/Roblox-Scripts/refs/heads/master/Banisher.lua"},
    {"Studio Dummy变身", "https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/Studio%20Dummy"},
    {"变身脚本15", "https://pastebin.com/raw/XNVWznPH"},
    {"Soul Reaper变身", "https://raw.githubusercontent.com/gObl00x/My-Converts/refs/heads/main/Soul%20Reaper.lua"},
    {"Sin Unleashed变身", "https://raw.githubusercontent.com/gitezgitgit/Sin-Unleashed/refs/heads/main/Sin%20Unleashed.lua.txt"},
    {"Shadow Ravager变身", "https://raw.githubusercontent.com/retpirato/Roblox-Scripts/refs/heads/master/Shadow%20Ravager.lua"},
    {"小丑变身", "https://raw.githubusercontent.com/HappyCow91/RobloxScripts/refs/heads/main/ClientSided/clown.lua"},
    {"RUIN IX变身", "https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/RUIN%20IX"},
    {"RUIN EX变身", "https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/RUIN%20EX"},
    {"变身脚本22", "https://pastebin.com/raw/KPYbrH1C"},
    {"Red Sword Pickaxe变身", "https://raw.githubusercontent.com/ProBypasserHax1/Idkkk/refs/heads/main/Red%20Sword%20Pickaxe.txt"},
    {"revenge hands变身", "https://raw.githubusercontent.com/nicolasbarbosa323/sin-dragon/refs/heads/main/reevenge%20hands.txt"},
    {"Project 44033514变身", "https://raw.githubusercontent.com/gitezgitgit/Project-2044033514/refs/heads/main/Project%2044033514.lua.txt"},
    {"变身脚本26", "https://pastefy.app/CtVFoMMq/raw"},
    {"pandora变身", "https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/pandora"},
    {"Omni God变身", "https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/Omni%20God"},
    {"Mr.Pixels变身", "https://raw.githubusercontent.com/gObl00x/My-Converts/refs/heads/main/Mr.Pixels.lua"},
    {"Mr.Bye Bye变身", "https://raw.githubusercontent.com/gObl00x/My-Converts/refs/heads/main/Mr.Bye%20Bye.lua"},
    {"Client Replication变身", "https://rawscripts.net/raw/Client-Replication-the-ss-loadstring-script-27393"},
    {"Lost Hope Scythe变身", "https://raw.githubusercontent.com/gObl00x/My-Converts/refs/heads/main/Lost%20Hope%20Scythe.lua"},
    {"kitcher gun变身", "https://raw.githubusercontent.com/nicolasbarbosa323/rare/refs/heads/main/kitcher%20gun.lua"},
    {"Kirito Blades变身", "https://raw.githubusercontent.com/nicolasbarbosa323/the-angel/refs/heads/main/Kirito%20Blades.txt"},
    {"变身脚本35", "https://pastebin.com/raw/yraarJ7m"},
    {"Internal War变身", "https://raw.githubusercontent.com/gObl00x/My-Converts/refs/heads/main/Internal%20War.lua"},
    {"Incension Reborn变身", "https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/Incension%20Reborn"},
    {"Genkadda omega变身", "https://raw.githubusercontent.com/nicolasbarbosa323/grakkeda/refs/heads/main/Roblox%20Genkadda%20omega%20leaked.txt"},
}

for i, data in ipairs(transformScripts) do
    TransformTab:Button({ Title = data[1], Callback = function()
        pcall(function() loadstring(game:HttpGet(data[2]))() end)
    end})
end

-- ===================== 玩家 Aimbot 模块（终极修复版） =====================
local Aimbot = {
    enabled = false,
    smooth = 0.35,
    bone = "Head",
    prediction = 0.12,
    checkTeam = false,
    wallCheck = false,
    lineEnabled = false,
    mode = "Distance",
    mouseFOV = 120,
    fixedFOV = 90,
    showMouseFOV = false,
    showFixedFOV = false,
    drawings = { mouseFovCircle = nil, fixedFovCircle = nil, aimLine = nil },
    connection = nil
}

function Aimbot:getAimPos(character)
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    local bone = character:FindFirstChild(self.bone) or character:FindFirstChild("Head")
    if not (root and bone) then return nil end
    return bone.Position + root.Velocity * self.prediction
end

function Aimbot:isVisible(pos, targetChar)
    if not self.wallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (pos - origin).Unit
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera, targetChar}
    local result = workspace:Raycast(origin, direction * (origin - pos).Magnitude, rayParams)
    return result == nil
end

function Aimbot:inFOV(worldPos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
    if not onScreen or screenPos.Z <= 0 then return false end
    local mousePos = UserInputService:GetMouseLocation()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    if self.showMouseFOV and self.drawings.mouseFovCircle then
        if (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude <= self.mouseFOV then return true end
    end
    if self.showFixedFOV and self.drawings.fixedFovCircle then
        if (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude <= self.fixedFOV then return true end
    end
    return false
end

function Aimbot:getClosest()
    local closest, minDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if self.checkTeam and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then continue end
        local char = plr.Character
        if not char then continue end
        local aimPos = self:getAimPos(char)
        if not aimPos then continue end
        if not self:inFOV(aimPos) then continue end
        local sp, onScreen = Camera:WorldToViewportPoint(aimPos)
        if not onScreen or sp.Z <= 0 then continue end
        if not self:isVisible(aimPos, char) then continue end
        local dist = (self.mode == "Distance") and (aimPos - Camera.CFrame.Position).Magnitude or (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if dist < minDist then
            minDist, closest = dist, plr
        end
    end
    return closest
end

function Aimbot:ensureDrawings()
    -- 鼠标FOV圆
    if not self.drawings.mouseFovCircle then
        local ok, obj = pcall(Drawing.new, "Circle")
        if ok then
            obj.NumSides = 64; obj.Thickness = 1.5; obj.Color = Color3.fromRGB(255,255,255)
            obj.Filled = false; obj.Visible = false; obj.ZIndex = 10
            self.drawings.mouseFovCircle = obj
        end
    end
    if self.drawings.mouseFovCircle then
        self.drawings.mouseFovCircle.Radius = self.mouseFOV
        self.drawings.mouseFovCircle.Visible = self.showMouseFOV and self.enabled
    end

    -- 固定FOV圆
    if not self.drawings.fixedFovCircle then
        local ok, obj = pcall(Drawing.new, "Circle")
        if ok then
            obj.NumSides = 64; obj.Thickness = 1.5; obj.Color = Color3.fromRGB(255,165,0)
            obj.Filled = false; obj.Visible = false; obj.ZIndex = 9
            self.drawings.fixedFovCircle = obj
        end
    end
    if self.drawings.fixedFovCircle then
        self.drawings.fixedFovCircle.Radius = self.fixedFOV
        self.drawings.fixedFovCircle.Visible = self.showFixedFOV and self.enabled
    end

    -- 瞄准线
    if not self.drawings.aimLine then
        local ok, obj = pcall(Drawing.new, "Line")
        if ok then
            obj.Thickness = 1.5; obj.Color = Color3.fromRGB(0,255,0)
            obj.Visible = false; obj.ZIndex = 11
            self.drawings.aimLine = obj
        end
    end
    if self.drawings.aimLine then
        self.drawings.aimLine.Visible = self.lineEnabled and self.enabled
    end
end

function Aimbot:start()
    if self.connection then self.connection:Disconnect() end
    self:ensureDrawings()

    local function updateFixedCenter()
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        if self.drawings.fixedFovCircle then
            self.drawings.fixedFovCircle.Position = center
        end
        if self.drawings.aimLine then
            self.drawings.aimLine.From = center
        end
    end
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateFixedCenter)
    updateFixedCenter()

    self.connection = RunService.RenderStepped:Connect(function()
        self:ensureDrawings()

        if self.drawings.mouseFovCircle then
            self.drawings.mouseFovCircle.Position = UserInputService:GetMouseLocation()
        end

        if not self.enabled then
            if self.drawings.aimLine then self.drawings.aimLine.Visible = false end
            return
        end

        local target = self:getClosest()
        if not target or not target.Character then
            if self.drawings.aimLine then self.drawings.aimLine.Visible = false end
            return
        end

        local aimPos = self:getAimPos(target.Character)
        if not aimPos then
            if self.drawings.aimLine then self.drawings.aimLine.Visible = false end
            return
        end

        if self.drawings.aimLine then
            local screenPos, onScreen = Camera:WorldToViewportPoint(aimPos)
            if onScreen and screenPos.Z > 0 then
                self.drawings.aimLine.To = Vector2.new(screenPos.X, screenPos.Y)
                self.drawings.aimLine.Visible = self.lineEnabled
            else
                self.drawings.aimLine.Visible = false
            end
        end

        local delta = aimPos - Camera.CFrame.Position
        if delta.Magnitude < 0.01 then return end
        local targetCF = CFrame.lookAt(Camera.CFrame.Position, aimPos)
        local currentLook = Camera.CFrame.LookVector
        local targetLook = targetCF.LookVector
        local dot = currentLook:Dot(targetLook)
        local angle = math.acos(math.clamp(dot, -1, 1))
        if angle <= math.rad(90) then
            local smoothFactor = math.clamp(self.smooth, 0.01, 0.99)
            local newLook = currentLook:Lerp(targetLook, 1 - smoothFactor)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + newLook)
        end
    end)
end

function Aimbot:stop()
    if self.connection then self.connection:Disconnect(); self.connection = nil end
    for _, obj in pairs(self.drawings) do
        if obj then pcall(function() obj.Visible = false; obj:Remove() end) end
    end
    self.drawings = { mouseFovCircle = nil, fixedFovCircle = nil, aimLine = nil }
end

-- ===================== AI-Aimbot 标签页 =====================
local AimbotTab = Window:Tab({ Title = "AI-Aimbot", Icon = "target", Locked = false })

AimbotTab:Toggle({ Title = "启用 Aimbot", Default = false, Callback = function(v)
    Aimbot.enabled = v
    if v then Aimbot:start() else Aimbot:stop() end
end})

AimbotTab:Toggle({ Title = "仅瞄准敌人", Default = false, Callback = function(v) Aimbot.checkTeam = v end})

AimbotTab:Toggle({ Title = "墙体检测", Default = false, Callback = function(v) Aimbot.wallCheck = v end})

AimbotTab:Toggle({ Title = "显示自瞄线条", Default = false, Callback = function(v)
    Aimbot.lineEnabled = v
    if Aimbot.drawings.aimLine then
        Aimbot.drawings.aimLine.Visible = v and Aimbot.enabled
    end
end})

AimbotTab:Dropdown({ Title = "瞄准方式", Values = {"Distance", "Crosshair"}, Value = "Distance", Callback = function(v) Aimbot.mode = v end})

AimbotTab:Slider({ Title = "平滑系数", Value = {Min=0, Max=1, Default=0.35}, Callback = function(v)
    Aimbot.smooth = v
end})

AimbotTab:Slider({ Title = "预测时间", Value = {Min=0, Max=1, Default=0.12}, Callback = function(v)
    Aimbot.prediction = v
end})

AimbotTab:Dropdown({ Title = "瞄准骨骼", Values = {"Head", "Neck", "UpperTorso", "HumanoidRootPart"}, Value = "Head", Callback = function(v) Aimbot.bone = v end})

AimbotTab:Toggle({ Title = "显示跟随FOV", Default = false, Callback = function(v)
    Aimbot.showMouseFOV = v
    if Aimbot.drawings.mouseFovCircle then
        Aimbot.drawings.mouseFovCircle.Visible = v and Aimbot.enabled
    end
end})

AimbotTab:Slider({ Title = "跟随FOV半径", Value = {Min=0, Max=500, Default=120}, Callback = function(v)
    Aimbot.mouseFOV = v
    if Aimbot.drawings.mouseFovCircle then
        Aimbot.drawings.mouseFovCircle.Radius = v
    end
end})

AimbotTab:Toggle({ Title = "显示固定FOV", Default = false, Callback = function(v)
    Aimbot.showFixedFOV = v
    if Aimbot.drawings.fixedFovCircle then
        Aimbot.drawings.fixedFovCircle.Visible = v and Aimbot.enabled
    end
end})

AimbotTab:Slider({ Title = "固定FOV半径", Value = {Min=0, Max=500, Default=90}, Callback = function(v)
    Aimbot.fixedFOV = v
    if Aimbot.drawings.fixedFovCircle then
        Aimbot.drawings.fixedFovCircle.Radius = v
    end
end})

-- ===================== 玩家ESP模块（终极修复） =====================
local ESPTab = Window:Tab({ Title = "透视", Icon = "eye", Locked = false })

local ESP = {
    enabled = false,
    settings = {
        Box = false, Name = true, Distance = false, HealthBar = false, HealthText = false,
        Tracer = false, TracerPosition = "Bottom", ShowEnemyOnly = false, MaxDistance = 500
    },
    colors = {
        Enemy = Color3.fromRGB(255,0,0), Ally = Color3.fromRGB(0,255,0),
        Friend = Color3.fromRGB(255,255,0), Neutral = Color3.fromRGB(255,255,255)
    },
    cache = {}, -- [player] = {Box, Name, Distance, HealthBar, HealthText, Tracer}
    blacklist = {}, whitelist = {}
}

function ESP:getTeamColor(player)
    if self.whitelist[player.Name] then return self.colors.Friend end
    if self.blacklist[player.Name] then return self.colors.Neutral end
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team == player.Team and self.colors.Ally or self.colors.Enemy
    end
    return self.colors.Enemy
end

function ESP:createObject(player)
    local obj = {}
    local success, box = pcall(Drawing.new, "Square")
    if success then box.Thickness = 2; box.Filled = false; box.ZIndex = 1; box.Visible = false; obj.Box = box end
    success, obj.Name = pcall(Drawing.new, "Text")
    if obj.Name then obj.Name.Size = 16; obj.Name.Center = true; obj.Name.Outline = true; obj.Name.ZIndex = 2; obj.Name.Visible = false end
    success, obj.Distance = pcall(Drawing.new, "Text")
    if obj.Distance then obj.Distance.Size = 14; obj.Distance.Center = true; obj.Distance.Outline = true; obj.Distance.ZIndex = 2; obj.Distance.Visible = false end
    success, obj.HealthBar = pcall(Drawing.new, "Square")
    if obj.HealthBar then obj.HealthBar.Filled = true; obj.HealthBar.Thickness = 1; obj.HealthBar.ZIndex = 1; obj.HealthBar.Visible = false end
    success, obj.HealthText = pcall(Drawing.new, "Text")
    if obj.HealthText then obj.HealthText.Size = 12; obj.HealthText.Center = true; obj.HealthText.Outline = true; obj.HealthText.ZIndex = 2; obj.HealthText.Visible = false end
    success, obj.Tracer = pcall(Drawing.new, "Line")
    if obj.Tracer then obj.Tracer.Thickness = 1; obj.Tracer.ZIndex = 1; obj.Tracer.Visible = false end
    self.cache[player] = obj
    return obj
end

function ESP:update()
    if not self.enabled then
        for _, obj in pairs(self.cache) do
            for _, drawing in pairs(obj) do if drawing then drawing.Visible = false end end
        end
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then goto continue end
        if self.settings.ShowEnemyOnly and self:getTeamColor(player) == self.colors.Ally then
            if self.cache[player] then
                for _, drawing in pairs(self.cache[player]) do if drawing then drawing.Visible = false end end
            end
            goto continue
        end
        local char = player.Character
        if not char then
            if self.cache[player] then
                for _, drawing in pairs(self.cache[player]) do if drawing then drawing.Visible = false end end
            end
            goto continue
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChild("Humanoid")
        if not (root and head and hum) then goto continue end
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if not onScreen then
            if self.cache[player] then
                for _, drawing in pairs(self.cache[player]) do if drawing then drawing.Visible = false end end
            end
            goto continue
        end
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        if dist > self.settings.MaxDistance then
            if self.cache[player] then
                for _, drawing in pairs(self.cache[player]) do if drawing then drawing.Visible = false end end
            end
            goto continue
        end
        local esp = self.cache[player] or self:createObject(player)
        local color = self:getTeamColor(player)
        local size = Vector2.new(2000/pos.Z, 3000/pos.Z)
        local boxPos = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)

        if esp.Box then
            esp.Box.Visible = self.settings.Box
            esp.Box.Color = color
            esp.Box.Size = size
            esp.Box.Position = boxPos
        end
        if esp.Name then
            esp.Name.Visible = self.settings.Name
            esp.Name.Color = color
            esp.Name.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 20)
            esp.Name.Text = player.Name
        end
        if esp.Distance then
            esp.Distance.Visible = self.settings.Distance
            esp.Distance.Color = color
            esp.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 5)
            esp.Distance.Text = string.format("%.0fm", dist)
        end
        local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        if esp.HealthBar then
            esp.HealthBar.Visible = self.settings.HealthBar
            esp.HealthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
            esp.HealthBar.Size = Vector2.new(size.X * healthPercent, 4)
            esp.HealthBar.Position = Vector2.new(boxPos.X, boxPos.Y - 8)
        end
        if esp.HealthText then
            esp.HealthText.Visible = self.settings.HealthText
            esp.HealthText.Color = Color3.new(1,1,1)
            esp.HealthText.Position = Vector2.new(pos.X, boxPos.Y - 20)
            esp.HealthText.Text = string.format("%.0f/%.0f", hum.Health, hum.MaxHealth)
        end
        if esp.Tracer then
            esp.Tracer.Visible = self.settings.Tracer
            esp.Tracer.Color = color
            local start = self.settings.TracerPosition == "Top" and Vector2.new(Camera.ViewportSize.X/2, 0) or Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            esp.Tracer.From = start
            esp.Tracer.To = Vector2.new(pos.X, pos.Y)
        end
        ::continue::
    end
end

function ESP:clear()
    for _, obj in pairs(self.cache) do
        for _, drawing in pairs(obj) do
            if drawing then pcall(function() drawing.Visible = false; drawing:Remove() end) end
        end
    end
    self.cache = {}
end

-- ESP控件
ESPTab:Toggle({ Title = "启用玩家透视", Default = false, Callback = function(v)
    ESP.enabled = v
    if v then
        RunService:BindToRenderStep("UpdateESP", 200, function() ESP:update() end)
    else
        RunService:UnbindFromRenderStep("UpdateESP")
        ESP:clear()
    end
end})
ESPTab:Toggle({ Title = "显示方框", Default = false, Callback = function(v) ESP.settings.Box = v end})
ESPTab:Toggle({ Title = "显示名字", Default = false, Callback = function(v) ESP.settings.Name = v end})
ESPTab:Toggle({ Title = "显示距离", Default = false, Callback = function(v) ESP.settings.Distance = v end})
ESPTab:Toggle({ Title = "显示血条", Default = false, Callback = function(v) ESP.settings.HealthBar = v end})
ESPTab:Toggle({ Title = "显示血量文字", Default = false, Callback = function(v) ESP.settings.HealthText = v end})
ESPTab:Toggle({ Title = "显示追踪线条", Default = false, Callback = function(v) ESP.settings.Tracer = v end})
ESPTab:Dropdown({ Title = "线条位置", Values = {"Top","Bottom"}, Value = "Bottom", Callback = function(v) ESP.settings.TracerPosition = v end})
ESPTab:Toggle({ Title = "只显示敌人", Default = false, Callback = function(v) ESP.settings.ShowEnemyOnly = v end})
ESPTab:Slider({ Title = "最大距离", Value = {Min=100, Max=2000, Default=500}, Callback = function(v) ESP.settings.MaxDistance = v end})

-- 名单管理
local playerNameInput = ""
ESPTab:Input({ Title = "玩家名称", Placeholder = "输入名称", Callback = function(v) playerNameInput = v end})
ESPTab:Button({ Title = "添加到黑名单", Callback = function()
    if playerNameInput and playerNameInput ~= "" then ESP.blacklist[playerNameInput] = true; Notify("黑名单", "已添加 " .. playerNameInput) end
end})
ESPTab:Button({ Title = "添加到白名单", Callback = function()
    if playerNameInput and playerNameInput ~= "" then ESP.whitelist[playerNameInput] = true; Notify("白名单", "已添加 " .. playerNameInput) end
end})
ESPTab:Button({ Title = "重置所有绘图（清理残留）", Callback = function()
    ESP:clear()
    Aimbot:stop()
    Notify("重置", "已尝试清除所有绘图，若仍有残留请重启执行器", 3)
end})

-- ===================== 其他功能（音乐、传送、设置优化） =====================
local MusicTab = Window:Tab({ Title = "音乐", Icon = "music", Locked = false })
MusicTab:Button({ Title = "义勇军进行曲", Callback = function()
    local s = Instance.new("Sound"); s.SoundId = "rbxassetid://1845918434"; s.Parent = workspace; s:Play()
end})
MusicTab:Button({ Title = "防空警报", Callback = function()
    local s = Instance.new("Sound"); s.SoundId = "rbxassetid://792323017"; s.Parent = workspace; s:Play()
end})

local TeleportTab = Window:Tab({ Title = "传送", Icon = "map-pin", Locked = false })
local function tp(cf) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = cf end end
local powerTeleports = {
    {"出生点", CFrame.new(7,3,108)}, {"安全岛", CFrame.new(-39,10,1838)}, {"幸运抽奖", CFrame.new(-2606,-2,5753)},
}
for _, data in ipairs(powerTeleports) do
    TeleportTab:Button({ Title = "力量传奇: " .. data[1], Callback = function() tp(data[2]) end})
end

local SettingsOptTab = Window:Tab({ Title = "设置与优化", Icon = "settings", Locked = false })
SettingsOptTab:Button({ Title = "复制作者QQ (913348285)", Callback = function()
    CopyToClipboard("913348285"); Notify("复制成功", "作者QQ已复制")
end})
SettingsOptTab:Toggle({ Title = "性能模式", Default = false, Callback = function(v)
    ESP.settings.MaxDistance = v and 300 or 500
end})
SettingsOptTab:Button({ Title = "清理内存", Callback = function() collectgarbage("collect"); Notify("内存", "已清理") end})
SettingsOptTab:Button({ Title = "优化渲染 (最低画质)", Callback = function() settings().Rendering.QualityLevel = 1 end})
SettingsOptTab:Button({ Title = "卸载界面", Callback = function()
    Aimbot:stop(); ESP:clear(); Window:Destroy()
end})

-- ===================== 启动完成通知 =====================
Notify("坤坤大帝脚本", "v9.0 终极稳定版加载成功！所有功能已修复。", 5)

-- ===================== 关闭事件处理 =====================
Window:OnClose(function()
    if rainbowBorderAnimation then rainbowBorderAnimation:Disconnect() end
    Aimbot:stop(); ESP:clear()
end)
Window:OnDestroy(function()
    if rainbowBorderAnimation then rainbowBorderAnimation:Disconnect() end
end)