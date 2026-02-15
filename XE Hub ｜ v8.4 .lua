-- ============================================================
-- 坤坤大帝脚本 最终版（窗口透明度60%，彩虹边框透明度60%）
-- 包含：WindUI 边框设置 + 通用 + 变身 + 第二个脚本全部功能
-- 修复：自瞄 FOV 圆圈永不消失，窗口背景透明度0.4，彩虹边框透明度0.4
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
    -- 设置彩虹边框透明度为60%（不透明度60% -> 透明度0.4）
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

-- 创建 WindUI 主窗口（使用默认深色背景，无自定义图片）
local Window = WindUI:CreateWindow({
    Title = "<font color='#FFA500'>坤坤大帝</font><font color='#FFFF00'>Hub v8.4</font>",
    IconTransparency = 0.5,
    IconThemed = true,
    Author = "作者:衍哥 & 坤坤大帝",
    Folder = "坤坤大帝Hub_Ultimate",
    Size = UDim2.fromOffset(750, 500),
    Transparent = true,
    Theme = "White",  -- 默认深色主题
    User = { Enabled = true, Callback = function() print("用户信息") end, Anonymous = false },
})

-- 设置窗口背景透明度为60%（不透明度60% -> 透明度0.4）
if Window.UIElements and Window.UIElements.Main then
    Window.UIElements.Main.BackgroundTransparency = 0.4
end

spawn(function()
    wait(0.5)
    initializeRainbowBorder("彩虹颜色", animationSpeed)
end)

Window:Tag({ Title = "QQ:1057787159", Color = Color3.fromHex("#FFA500") })
Window:Tag({ Title = "v8.4", Color = Color3.fromHex("#0000FF") })

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

-- ===================== 通用标签页（原 WindUI 通用功能） =====================
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

-- 飞行按钮（多个）
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

-- ===================== 变身标签页（所有变身按钮） =====================
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

-- ===================== 以下为从第二个脚本移植的功能（完整实现） =====================
-- ===================== AI-Aimbot 标签页 =====================
local AimbotTab = Window:Tab({ Title = "AI-Aimbot", Icon = "target", Locked = false })

-- Aimbot 变量
local aimbotEnabled = false
local aimbotSmooth = 0.35
local aimbotBone = "Head"
local aimbotPrediction = 0.12
local aimbotCheckTeam = false
local wallCheckEnabled = false
local aimLineEnabled = false
local aimbotMode = "Distance"
local mouseFOV = 120
local fixedFOV = 90
local showMouseFOV = false
local showFixedFOV = false

-- Drawing 对象（使用全局表存储，便于重建）
local aimbotDrawings = {
    mouseFovCircle = nil,
    fixedFovCircle = nil,
    aimLine = nil
}
local aimbotConn

-- 辅助函数
local function getAimPos(character)
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    local bone = character:FindFirstChild(aimbotBone) or character:FindFirstChild("Head")
    if not (root and bone) then return nil end
    local vel = root.Velocity
    return bone.Position + vel * aimbotPrediction
end

local function isVisible(pos, targetCharacter)
    if not wallCheckEnabled then return true end
    local origin = Camera.CFrame.Position
    local direction = (pos - origin).Unit
    local ray = Ray.new(origin, direction * (origin - pos).Magnitude)
    local ignoreList = {LocalPlayer.Character, Camera}
    if targetCharacter then table.insert(ignoreList, targetCharacter) end
    local part = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    return part == nil
end

local function inAnyFOV(worldPos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
    if not onScreen or screenPos.Z <= 0 then return false end
    local mousePos = UserInputService:GetMouseLocation()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    if showMouseFOV and aimbotDrawings.mouseFovCircle then
        if (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude <= mouseFOV then return true end
    end
    if showFixedFOV and aimbotDrawings.fixedFovCircle then
        if (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude <= fixedFOV then return true end
    end
    return false
end

local function getClosest()
    local closest, minDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if aimbotCheckTeam and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then continue end
        local char = plr.Character
        if not char then continue end
        local aimPos = getAimPos(char)
        if not aimPos then continue end
        if not inAnyFOV(aimPos) then continue end
        local sp, onScreen = Camera:WorldToViewportPoint(aimPos)
        if not onScreen or sp.Z <= 0 then continue end
        if not isVisible(aimPos, char) then continue end
        local dist
        if aimbotMode == "Distance" then
            dist = (aimPos - Camera.CFrame.Position).Magnitude
        else
            dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        end
        if dist < minDist then
            minDist, closest = dist, plr
        end
    end
    return closest
end

-- 创建/重建 Drawing 对象的函数
local function ensureDrawings()
    if not aimbotDrawings.mouseFovCircle then
        aimbotDrawings.mouseFovCircle = Drawing.new("Circle")
        aimbotDrawings.mouseFovCircle.NumSides = 64
        aimbotDrawings.mouseFovCircle.Thickness = 1.5
        aimbotDrawings.mouseFovCircle.Color = Color3.fromRGB(255,255,255)
        aimbotDrawings.mouseFovCircle.Filled = false
        aimbotDrawings.mouseFovCircle.ZIndex = 10
    end
    if not aimbotDrawings.fixedFovCircle then
        aimbotDrawings.fixedFovCircle = Drawing.new("Circle")
        aimbotDrawings.fixedFovCircle.NumSides = 64
        aimbotDrawings.fixedFovCircle.Thickness = 1.5
        aimbotDrawings.fixedFovCircle.Color = Color3.fromRGB(255,165,0)
        aimbotDrawings.fixedFovCircle.Filled = false
        aimbotDrawings.fixedFovCircle.ZIndex = 9
    end
    if not aimbotDrawings.aimLine then
        aimbotDrawings.aimLine = Drawing.new("Line")
        aimbotDrawings.aimLine.Thickness = 1.5
        aimbotDrawings.aimLine.Color = Color3.fromRGB(0,255,0)
        aimbotDrawings.aimLine.ZIndex = 11
    end
end

local function startAimbot()
    if aimbotConn then aimbotConn:Disconnect() end
    ensureDrawings() -- 确保对象存在

    local function setFixedCenter()
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        if aimbotDrawings.fixedFovCircle then aimbotDrawings.fixedFovCircle.Position = center end
        if aimbotDrawings.aimLine then aimbotDrawings.aimLine.From = center end
    end
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(setFixedCenter)
    setFixedCenter()

    aimbotConn = RunService.RenderStepped:Connect(function()
        -- 每次渲染前确保 Drawing 对象存在（防止意外清除）
        ensureDrawings()

        if not aimbotEnabled then
            if aimbotDrawings.aimLine then aimbotDrawings.aimLine.Visible = false end
            if aimbotDrawings.mouseFovCircle then aimbotDrawings.mouseFovCircle.Visible = false end
            if aimbotDrawings.fixedFovCircle then aimbotDrawings.fixedFovCircle.Visible = false end
            return
        end
        if aimbotDrawings.mouseFovCircle then
            aimbotDrawings.mouseFovCircle.Visible = showMouseFOV
            aimbotDrawings.mouseFovCircle.Radius = mouseFOV
            aimbotDrawings.mouseFovCircle.Position = UserInputService:GetMouseLocation()
        end
        if aimbotDrawings.fixedFovCircle then
            aimbotDrawings.fixedFovCircle.Visible = showFixedFOV
            aimbotDrawings.fixedFovCircle.Radius = fixedFOV
            aimbotDrawings.fixedFovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end

        local target = getClosest()
        if not target or not target.Character then
            if aimbotDrawings.aimLine then aimbotDrawings.aimLine.Visible = false end
            return
        end
        local aimPos = getAimPos(target.Character)
        if not aimPos then
            if aimbotDrawings.aimLine then aimbotDrawings.aimLine.Visible = false end
            return
        end
        if aimbotDrawings.aimLine then
            local screenPos, onScreen = Camera:WorldToViewportPoint(aimPos)
            if onScreen and screenPos.Z > 0 then
                aimbotDrawings.aimLine.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                aimbotDrawings.aimLine.To = Vector2.new(screenPos.X, screenPos.Y)
                aimbotDrawings.aimLine.Visible = aimLineEnabled
            else
                aimbotDrawings.aimLine.Visible = false
            end
        end
        local delta = aimPos - Camera.CFrame.Position
        if delta.Magnitude < 0.01 then return end
        local targetCF = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + delta)
        local currentLook = Camera.CFrame.LookVector
        local targetLook = targetCF.LookVector
        local dot = currentLook:Dot(targetLook)
        local angle = math.acos(math.clamp(dot, -1, 1))
        if angle <= math.rad(90) then
            local smoothFactor = math.clamp(aimbotSmooth, 0.01, 0.99)
            local newLook = currentLook:Lerp(targetLook, 1 - smoothFactor)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + newLook)
        end
    end)
end

local function stopAimbot()
    if aimbotConn then aimbotConn:Disconnect() aimbotConn = nil end
    if aimbotDrawings.mouseFovCircle then aimbotDrawings.mouseFovCircle.Visible = false; aimbotDrawings.mouseFovCircle:Remove(); aimbotDrawings.mouseFovCircle = nil end
    if aimbotDrawings.fixedFovCircle then aimbotDrawings.fixedFovCircle.Visible = false; aimbotDrawings.fixedFovCircle:Remove(); aimbotDrawings.fixedFovCircle = nil end
    if aimbotDrawings.aimLine then aimbotDrawings.aimLine.Visible = false; aimbotDrawings.aimLine:Remove(); aimbotDrawings.aimLine = nil end
end

-- Aimbot 控件
AimbotTab:Toggle({ Title = "启用 Aimbot", Default = false, Callback = function(v)
    aimbotEnabled = v
    if v then startAimbot() else stopAimbot() end
end})
AimbotTab:Toggle({ Title = "仅瞄准敌人", Default = false, Callback = function(v) aimbotCheckTeam = v end})
AimbotTab:Toggle({ Title = "墙体检测", Default = false, Callback = function(v) wallCheckEnabled = v end})
AimbotTab:Toggle({ Title = "显示自瞄线条", Default = false, Callback = function(v) aimLineEnabled = v end})
AimbotTab:Dropdown({ Title = "瞄准方式", Values = {"Distance", "Crosshair"}, Value = "Distance", Callback = function(v) aimbotMode = v end})
AimbotTab:Slider({ Title = "平滑系数", Value = {Min=0, Max=1, Default=0.35}, Callback = function(v) aimbotSmooth = v end})
AimbotTab:Slider({ Title = "预测时间", Value = {Min=0, Max=1, Default=0.12}, Callback = function(v) aimbotPrediction = v end})
AimbotTab:Dropdown({ Title = "瞄准骨骼", Values = {"Head", "Neck", "UpperTorso", "HumanoidRootPart"}, Value = "Head", Callback = function(v) aimbotBone = v end})
AimbotTab:Toggle({ Title = "显示跟随FOV", Default = false, Callback = function(v) showMouseFOV = v end})
AimbotTab:Slider({ Title = "跟随FOV半径", Value = {Min=0, Max=500, Default=120}, Callback = function(v) mouseFOV = v end})
AimbotTab:Toggle({ Title = "显示固定FOV", Default = false, Callback = function(v) showFixedFOV = v end})
AimbotTab:Slider({ Title = "固定FOV半径", Value = {Min=0, Max=500, Default=90}, Callback = function(v) fixedFOV = v end})

-- ===================== 透视功能标签页（ESP 完整实现） =====================
local ESPTab = Window:Tab({ Title = "透视", Icon = "eye", Locked = false })

-- ESP 变量
local ESP_ENABLED = false
local CHAMS_ENABLED = false
local TRACERS_ENABLED = false
local OUTLINES_ENABLED = false
local FULLBRIGHT_ENABLED = false
local ESP_SETTINGS = { Box = true, Name = true, Distance = true, HealthBar = true, HealthText = false, Tracer = false, TracerPosition = "Bottom", ShowEnemyOnly = false, MaxDistance = 500 }
local COLOR_SETTINGS = { Enemy = Color3.fromRGB(255,0,0), Ally = Color3.fromRGB(0,255,0), Friend = Color3.fromRGB(255,255,0), Neutral = Color3.fromRGB(255,255,255), Crosshair = Color3.fromRGB(255,0,0), Mob = Color3.fromRGB(255,165,0) }
local ESP_CACHE = {}
local CHAMS_CACHE = {}
local TRACERS_CACHE = {}
local OUTLINED_PARTS = {}
local BLACKLIST = {}
local FRIENDLIST = {}
local playerNameInput = ""

-- 队伍颜色函数
local function GetTeamColor(player)
    if FRIENDLIST[player.Name] then return COLOR_SETTINGS.Friend end
    if BLACKLIST[player.Name] then return COLOR_SETTINGS.Neutral end
    if LocalPlayer.Team and player.Team then
        if LocalPlayer.Team == player.Team then
            return COLOR_SETTINGS.Ally
        else
            return COLOR_SETTINGS.Enemy
        end
    end
    return COLOR_SETTINGS.Enemy
end

-- ESP 绘制函数
local function CreateESPObject(player)
    local esp = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthText = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }
    esp.Box.Thickness = 2; esp.Box.Filled = false; esp.Box.ZIndex = 1
    esp.Name.Size = 16; esp.Name.Center = true; esp.Name.Outline = true; esp.Name.ZIndex = 2
    esp.Distance.Size = 14; esp.Distance.Center = true; esp.Distance.Outline = true; esp.Distance.ZIndex = 2
    esp.HealthBar.Filled = true; esp.HealthBar.Thickness = 1; esp.HealthBar.ZIndex = 1
    esp.HealthText.Size = 12; esp.HealthText.Center = true; esp.HealthText.Outline = true; esp.HealthText.ZIndex = 2
    esp.Tracer.Thickness = 1; esp.Tracer.ZIndex = 1
    ESP_CACHE[player] = esp
    return esp
end

local function UpdateESP()
    if not ESP_ENABLED then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if ESP_SETTINGS.ShowEnemyOnly and GetTeamColor(player) == COLOR_SETTINGS.Ally then
            if ESP_CACHE[player] then for _, obj in pairs(ESP_CACHE[player]) do obj.Visible = false end end
            continue
        end
        local character = player.Character
        if not character then
            if ESP_CACHE[player] then for _, obj in pairs(ESP_CACHE[player]) do obj.Visible = false end end
            continue
        end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        local humanoid = character:FindFirstChild("Humanoid")
        if not (rootPart and head and humanoid) then continue end
        local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        if not onScreen then
            if ESP_CACHE[player] then for _, obj in pairs(ESP_CACHE[player]) do obj.Visible = false end end
            continue
        end
        local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
        if distance > ESP_SETTINGS.MaxDistance then
            if ESP_CACHE[player] then for _, obj in pairs(ESP_CACHE[player]) do obj.Visible = false end end
            continue
        end
        local esp = ESP_CACHE[player] or CreateESPObject(player)
        local color = GetTeamColor(player)
        local headPos = Camera:WorldToViewportPoint(head.Position)
        local size = Vector2.new(2000 / rootPos.Z, 3000 / rootPos.Z)
        local position = Vector2.new(rootPos.X - size.X / 2, rootPos.Y - size.Y / 2)
        esp.Box.Visible = ESP_SETTINGS.Box; esp.Box.Color = color; esp.Box.Size = size; esp.Box.Position = position
        esp.Name.Visible = ESP_SETTINGS.Name; esp.Name.Color = color; esp.Name.Position = Vector2.new(rootPos.X, rootPos.Y - size.Y/2 - 20); esp.Name.Text = player.Name
        esp.Distance.Visible = ESP_SETTINGS.Distance; esp.Distance.Color = color; esp.Distance.Position = Vector2.new(rootPos.X, rootPos.Y + size.Y/2 + 5); esp.Distance.Text = string.format("%.0fm", distance)
        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        esp.HealthBar.Visible = ESP_SETTINGS.HealthBar; esp.HealthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0); esp.HealthBar.Size = Vector2.new(size.X * healthPercent, 4); esp.HealthBar.Position = Vector2.new(position.X, position.Y - 8)
        esp.HealthText.Visible = ESP_SETTINGS.HealthText; esp.HealthText.Color = Color3.new(1,1,1); esp.HealthText.Position = Vector2.new(rootPos.X, position.Y - 20); esp.HealthText.Text = string.format("%.0f/%.0f", humanoid.Health, humanoid.MaxHealth)
        esp.Tracer.Visible = ESP_SETTINGS.Tracer; esp.Tracer.Color = color
        local startPoint = (ESP_SETTINGS.TracerPosition == "Top") and Vector2.new(Camera.ViewportSize.X/2, 0) or Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
        esp.Tracer.From = startPoint; esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
    end
end

local function ClearESP()
    for player, esp in pairs(ESP_CACHE) do
        for _, obj in pairs(esp) do pcall(function() obj.Visible = false; obj:Remove() end) end
    end
    ESP_CACHE = {}
end

-- Chams 实现（使用 Highlight）
local function CreateChams(player)
    if CHAMS_CACHE[player] then return end
    local character = player.Character
    if not character then return end
    local chams = {}
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ChamsHighlight"
            highlight.Adornee = part
            highlight.FillColor = GetTeamColor(player)
            highlight.FillTransparency = 0.3
            highlight.OutlineColor = Color3.new(1,1,1)
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = part
            table.insert(chams, highlight)
        end
    end
    CHAMS_CACHE[player] = chams
end

local function UpdateChams()
    if not CHAMS_ENABLED then
        for _, chams in pairs(CHAMS_CACHE) do
            for _, c in ipairs(chams) do c:Destroy() end
        end
        CHAMS_CACHE = {}
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not CHAMS_CACHE[player] and player.Character then
            CreateChams(player)
        end
    end
end

local function ClearChams()
    for _, chams in pairs(CHAMS_CACHE) do
        for _, c in ipairs(chams) do c:Destroy() end
    end
    CHAMS_CACHE = {}
end

-- Tracers 实现（3D线条）
local function CreateTracer(player)
    if TRACERS_CACHE[player] then return end
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local tracer = Instance.new("Part")
    tracer.Name = "Tracer_" .. player.Name
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Transparency = 0.5
    tracer.Material = Enum.Material.Neon
    tracer.Size = Vector3.new(0.1, 0.1, 1)
    tracer.BrickColor = BrickColor.new(GetTeamColor(player))
    tracer.Parent = workspace
    local att0 = Instance.new("Attachment", tracer)
    local att1 = Instance.new("Attachment", tracer)
    att0.Position = Vector3.new(0, 0, -0.5)
    att1.Position = Vector3.new(0, 0, 0.5)
    local beam = Instance.new("Beam")
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Color = ColorSequence.new(GetTeamColor(player))
    beam.Transparency = NumberSequence.new(0)
    beam.Width0 = 0.1
    beam.Width1 = 0.1
    beam.FaceCamera = true
    beam.Parent = tracer
    TRACERS_CACHE[player] = {tracer = tracer, beam = beam}
end

local function UpdateTracers()
    if not TRACERS_ENABLED then
        for _, data in pairs(TRACERS_CACHE) do
            data.tracer:Destroy()
        end
        TRACERS_CACHE = {}
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not TRACERS_CACHE[player] and player.Character then
            CreateTracer(player)
        end
        if TRACERS_CACHE[player] and player.Character then
            local data = TRACERS_CACHE[player]
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local startPos = Camera.CFrame.Position
                local endPos = rootPart.Position - Vector3.new(0, 2, 0)
                local dist = (endPos - startPos).Magnitude
                data.tracer.CFrame = CFrame.lookAt(startPos, endPos) * CFrame.new(0, 0, -dist/2)
                data.tracer.Size = Vector3.new(0.1, 0.1, dist)
                data.beam.Color = ColorSequence.new(GetTeamColor(player))
            end
        end
    end
end

local function ClearTracers()
    for _, data in pairs(TRACERS_CACHE) do
        data.tracer:Destroy()
    end
    TRACERS_CACHE = {}
end

-- 轮廓实现（使用 SelectionBox）
local function CreateOutlines()
    if not OUTLINES_ENABLED then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not Players:GetPlayerFromCharacter(obj.Parent) then
            if not OUTLINED_PARTS[obj] then
                local box = Instance.new("SelectionBox")
                box.Adornee = obj
                box.Color3 = Color3.new(0,1,0)
                box.SurfaceColor3 = Color3.new(0,1,0)
                box.LineThickness = 0.05
                box.Transparency = 0.5
                box.Parent = obj
                OUTLINED_PARTS[obj] = {box = box, originalTransparency = obj.Transparency}
                obj.Transparency = 1
            end
        end
    end
end

local function ClearOutlines()
    for obj, data in pairs(OUTLINED_PARTS) do
        if obj and obj.Parent then
            obj.Transparency = data.originalTransparency
            data.box:Destroy()
        end
    end
    OUTLINED_PARTS = {}
end

-- 全亮
local function SetFullbright(enabled)
    FULLBRIGHT_ENABLED = enabled
    if enabled then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.ColorShift_Bottom = Color3.new(1,1,1)
        Lighting.ColorShift_Top = Color3.new(1,1,1)
        Lighting.TimeOfDay = "14:00:00"
    else
        Lighting.Ambient = Color3.fromRGB(100,100,100)
        Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
        Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    end
end

-- 十字准星
local crosshairGui
local function UpdateCrosshair(enabled)
    if crosshairGui then crosshairGui:Destroy() end
    if not enabled then return end
    crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "CrosshairGUI"
    crosshairGui.Parent = game:GetService("CoreGui")
    crosshairGui.ResetOnSpawn = false
    crosshairGui.IgnoreGuiInset = true
    crosshairGui.DisplayOrder = 9999
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 40, 0, 40)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = crosshairGui
    local color = COLOR_SETTINGS.Crosshair
    local function createLine(size, anchor, pos)
        local line = Instance.new("Frame")
        line.Size = size
        line.AnchorPoint = anchor
        line.Position = pos
        line.BackgroundColor3 = color
        line.BorderSizePixel = 0
        line.Parent = frame
    end
    createLine(UDim2.new(0,2,0,12), Vector2.new(0.5,1), UDim2.new(0.5,0,0.5,-1)) -- top
    createLine(UDim2.new(0,2,0,12), Vector2.new(0.5,0), UDim2.new(0.5,0,0.5,1)) -- bottom
    createLine(UDim2.new(0,12,0,2), Vector2.new(1,0.5), UDim2.new(0.5,-1,0.5,0)) -- left
    createLine(UDim2.new(0,12,0,2), Vector2.new(0,0.5), UDim2.new(0.5,1,0.5,0)) -- right
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0,3,0,3)
    dot.AnchorPoint = Vector2.new(0.5,0.5)
    dot.Position = UDim2.new(0.5,0,0.5,0)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.Parent = frame
end

-- ESP 控件
ESPTab:Toggle({ Title = "启用玩家透视", Default = false, Callback = function(v)
    ESP_ENABLED = v
    if v then RunService:BindToRenderStep("UpdateESP", 200, UpdateESP) else RunService:UnbindFromRenderStep("UpdateESP"); ClearESP() end
end})
ESPTab:Toggle({ Title = "显示方框", Default = true, Callback = function(v) ESP_SETTINGS.Box = v end})
ESPTab:Toggle({ Title = "显示名字", Default = true, Callback = function(v) ESP_SETTINGS.Name = v end})
ESPTab:Toggle({ Title = "显示距离", Default = true, Callback = function(v) ESP_SETTINGS.Distance = v end})
ESPTab:Toggle({ Title = "显示血条", Default = true, Callback = function(v) ESP_SETTINGS.HealthBar = v end})
ESPTab:Toggle({ Title = "显示血量文字", Default = false, Callback = function(v) ESP_SETTINGS.HealthText = v end})
ESPTab:Toggle({ Title = "显示追踪线条", Default = false, Callback = function(v) ESP_SETTINGS.Tracer = v end})
ESPTab:Dropdown({ Title = "线条位置", Values = {"Top","Bottom"}, Value = "Bottom", Callback = function(v) ESP_SETTINGS.TracerPosition = v end})
ESPTab:Toggle({ Title = "只显示敌人", Default = false, Callback = function(v) ESP_SETTINGS.ShowEnemyOnly = v end})
ESPTab:Slider({ Title = "最大距离", Value = {Min=100, Max=2000, Default=500}, Callback = function(v) ESP_SETTINGS.MaxDistance = v end})
ESPTab:Toggle({ Title = "启用Chams", Default = false, Callback = function(v)
    CHAMS_ENABLED = v
    if v then RunService:BindToRenderStep("UpdateChams", 201, UpdateChams) else RunService:UnbindFromRenderStep("UpdateChams"); ClearChams() end
end})
ESPTab:Toggle({ Title = "启用Tracers", Default = false, Callback = function(v)
    TRACERS_ENABLED = v
    if v then RunService:BindToRenderStep("UpdateTracers", 202, UpdateTracers) else RunService:UnbindFromRenderStep("UpdateTracers"); ClearTracers() end
end})
ESPTab:Toggle({ Title = "启用轮廓", Default = false, Callback = function(v)
    OUTLINES_ENABLED = v
    if v then CreateOutlines() else ClearOutlines() end
end})
ESPTab:Toggle({ Title = "全亮模式", Default = false, Callback = function(v) SetFullbright(v) end})
ESPTab:Toggle({ Title = "十字准星", Default = false, Callback = function(v) UpdateCrosshair(v) end})

-- 名单管理
ESPTab:Input({ Title = "玩家名称", Placeholder = "输入名称", Callback = function(v) playerNameInput = v end})
ESPTab:Button({ Title = "添加到黑名单", Callback = function()
    if playerNameInput and playerNameInput ~= "" then BLACKLIST[playerNameInput] = true; Notify("黑名单", "已添加 " .. playerNameInput) end
end})
ESPTab:Button({ Title = "添加到白名单", Callback = function()
    if playerNameInput and playerNameInput ~= "" then FRIENDLIST[playerNameInput] = true; Notify("白名单", "已添加 " .. playerNameInput) end
end})

-- ===================== 游戏脚本中心 =====================
local GameTab = Window:Tab({ Title = "游戏脚本", Icon = "package", Locked = false })

local function loadScript(url)
    pcall(function() loadstring(game:HttpGet(url))() end)
end

-- 通用脚本列表
local generalScripts = {
    {"玩家加入游戏提示", "https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"},
    {"正常范围", "https://pastebin.com/raw/jiNwDbCN"},
    {"中等范围", "https://pastebin.com/raw/x13bwrFb"},
    {"高级范围", "https://pastebin.com/raw/KKY9EpZU"},
    {"甩人", "https://pastebin.com/raw/zqyDSUWX"},
    {"飞檐走壁", "https://pastebin.com/raw/zXk4Rq2r"},
    {"踏空行走", "https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float"},
    {"黑洞脚本", "https://shz.al/~KAKAKKKKSS"},
    {"死亡笔记", "https://shz.al/~KKKSS"},
    {"想杀谁就杀谁", "https://shz.al/~HHHS"},
    {"变玩家", "https://pastebin.com/raw/XR4sGcgJ"},
    {"阿尔宙斯UI", "https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20X%20V3"},
    {"透视", "https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP"},
    {"超高画质", "https://pastebin.com/raw/jHBfJYmS"},
    {"工具挂", "https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/StandAwekening.lua"},
    {"指令", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {"键盘", "https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt"},
    {"反挂机", "https://pastebin.com/raw/9fFu43FF"},
}

for i, data in ipairs(generalScripts) do
    GameTab:Button({ Title = data[1], Callback = function() loadScript(data[2]) end})
end

-- 更多游戏脚本
local moreScripts = {
    {"FEVR脚本", "https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty45.lua"},
    {"Dex++脚本", "https://rawscripts.net/raw/Universal-Script-Dex-Explorer-plus-50432"},
    {"XA HUB", "https://raw.gitcode.com/Xingtaiduan/Scripts/raw/main/Loader.lua"},
    {"Rb脚本", "https://raw.githubusercontent.com/Yungengxin/roblox/refs/heads/main/Rb-Hub"},
    {"生存与杀手", "https://raw.githubusercontent.com/Milan08Studio/ChairWare/main/main.lua"},
    {"爱德华", "https://raw.githubusercontent.com/gumanba/Scripts/main/Edward"},
    {"活了7天", "https://rawscripts.net/raw/Universal-Script-7-days-to-live-36824"},
    {"死铁轨", "https://raw.githubusercontent.com/iopjklbnmsss/SansHubScript/refs/heads/main/SansHub"},
    {"一路向西刷钱", "https://raw.githubusercontent.com/yxgh165/yxgh165/main/一路向西"},
    {"自然灾害黑洞v6", "https://rawscripts.net/raw/Universal-Script-Super-ring-Parts-V6-28581"},
    {"XA俄亥俄州", "https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Games/俄亥俄州.lua"},
    {"XA墨水游戏", "https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Games/墨水游戏.lua"},
    {"XA99夜", "https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Games/森林中的99夜.lua"},
    {"Doors汉化", "https://pastebin.com/raw/65TwT8ja"},
    {"烂梗社区刷钱", "https://raw.githubusercontent.com/XOTRXONY/EasyScript/main/Suao.luau"},
    {"暴力区XQ汉化", "https://raw.githubusercontent.com/XQ444/XQ-/refs/heads/main/93978595733734"},
}

for i, data in ipairs(moreScripts) do
    GameTab:Button({ Title = data[1], Callback = function() loadScript(data[2]) end})
end

-- Door 游戏
GameTab:Button({ Title = "Doors 最强汉化", Callback = function() loadScript("https://pastebin.com/raw/65TwT8ja") end})
GameTab:Button({ Title = "Doors DX", Callback = function() loadScript("https://raw.githubusercontent.com/DXuwu/replicator-lol/main/dor.lua") end})

-- 力量传奇
GameTab:Toggle({ Title = "自动比赛开关", Default = false, Callback = function(v)
    while v and task.wait(2) do
        game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
    end
end})

-- ===================== 传送功能标签页 =====================
local TeleportTab = Window:Tab({ Title = "传送", Icon = "map-pin", Locked = false })

local function tp(cf)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    end
end

-- 力量传奇传送点
local powerTeleports = {
    {"出生点", CFrame.new(7, 3, 108)},
    {"安全岛", CFrame.new(-39, 10, 1838)},
    {"幸运抽奖", CFrame.new(-2606, -2, 5753)},
    {"肌肉之王", CFrame.new(-8554, 22, -5642)},
    {"传说健身房", CFrame.new(4676, 997, -3915)},
    {"永恒健身房", CFrame.new(-6686, 13, -1284)},
    {"神话健身房", CFrame.new(2177, 13, 1070)},
    {"冰霜健身房", CFrame.new(-2543, 13, -410)},
}
for _, data in ipairs(powerTeleports) do
    TeleportTab:Button({ Title = "力量传奇: " .. data[1], Callback = function() tp(data[2]) end})
end

-- 伐木大亨传送点
local lumberTeleports = {
    {"木材反斗城", CFrame.new(252.319061, 2.999999, 56.985485)},
    {"冰木", CFrame.new(1522.881714, 412.365753, 3277.718262)},
    {"椰子木", CFrame.new(2615.709228, -5.899987, -21.301384)},
    {"幻影木", CFrame.new(-56.281662, -213.131378, -1357.801880)},
    {"火山木", CFrame.new(-1615.893433, 622.999878, 1086.123413)},
    {"画室", CFrame.new(5241.558105, -166.000031, 709.565613)},
}
for _, data in ipairs(lumberTeleports) do
    TeleportTab:Button({ Title = "伐木大亨: " .. data[1], Callback = function() tp(data[2]) end})
end

-- 监狱人生传送点
local prisonTeleports = {
    {"警卫室", CFrame.new(847.726135, 98.959999, 2267.387451)},
    {"监狱室内", CFrame.new(919.257507, 98.959999, 2379.741699)},
    {"监狱室外", CFrame.new(760.603333, 96.969925, 2475.405029)},
    {"犯罪复活点", CFrame.new(-937.589172, 93.098763, 2063.031982)},
    {"院子", CFrame.new(788.575989, 97.999924, 2455.056641)},
    {"警车库", CFrame.new(602.730164, 98.200005, 2503.569824)},
}
for _, data in ipairs(prisonTeleports) do
    TeleportTab:Button({ Title = "监狱人生: " .. data[1], Callback = function() tp(data[2]) end})
end

-- ===================== 音乐标签页 =====================
local MusicTab = Window:Tab({ Title = "音乐", Icon = "music", Locked = false })

MusicTab:Button({ Title = "义勇军进行曲", Callback = function()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://1845918434"
    s.Parent = workspace
    s:Play()
end})
MusicTab:Button({ Title = "防空警报", Callback = function()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://792323017"
    s.Parent = workspace
    s:Play()
end})

-- ===================== 设置与优化标签页 =====================
local SettingsOptTab = Window:Tab({ Title = "设置与优化", Icon = "settings", Locked = false })

SettingsOptTab:Button({ Title = "复制作者QQ (913348285)", Callback = function()
    CopyToClipboard("913348285")
    Notify("复制成功", "作者QQ已复制")
end})
SettingsOptTab:Toggle({ Title = "性能模式", Default = false, Callback = function(v)
    if v then ESP_SETTINGS.MaxDistance = 300 else ESP_SETTINGS.MaxDistance = 500 end
end})
SettingsOptTab:Button({ Title = "清理内存", Callback = function() collectgarbage("collect"); Notify("内存", "已清理") end})
SettingsOptTab:Button({ Title = "优化渲染 (最低画质)", Callback = function()
    settings().Rendering.QualityLevel = 1
end})
SettingsOptTab:Button({ Title = "卸载界面", Callback = function()
    stopAimbot()
    ClearESP()
    ClearChams()
    ClearTracers()
    ClearOutlines()
    SetFullbright(false)
    if crosshairGui then crosshairGui:Destroy() end
    Window:Destroy()
end})

-- ===================== 启动完成通知 =====================
Notify("坤坤大帝脚本", "最终版加载成功！窗口透明度60%，彩虹边框透明度60%。", 5)

-- ===================== 关闭事件处理（仅清理边框动画，不影响后台功能）=====================
Window:OnClose(function()
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
    -- 注意：不停止自瞄、透视等后台功能，让它们继续运行
end)

Window:OnDestroy(function()
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
    -- 不停止后台功能
end)