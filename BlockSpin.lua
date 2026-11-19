local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Camera = Workspace.CurrentCamera

local KEY = "VENOM-HUB-8492-7316"
local DISCORD = "https://discord.gg/upsFFfUbCY"
local DURATION = 86400

local function readKey()
    return tonumber(LocalPlayer:GetAttribute("VK"))
end
local function writeKey(t)
    pcall(function() LocalPlayer:SetAttribute("VK", t) end)
end

local function gate()
    local g = Instance.new("ScreenGui")
    g.Name = "VenomKeyGate"
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    g.DisplayOrder = 1e6
    pcall(function() g.Parent = (gethui and gethui()) or CoreGui end)
    if not g.Parent then g.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local b = Instance.new("Frame")
    b.Size = UDim2.new(0, 380, 0, 300)
    b.Position = UDim2.fromScale(.5, .5)
    b.AnchorPoint = Vector2.new(.5, .5)
    b.BackgroundColor3 = Color3.fromRGB(8, 10, 9)
    b.BorderSizePixel = 0
    b.Parent = g
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 16)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(0, 255, 136)
    s.Thickness = 1.5
    s.Transparency = .3
    local gr = Instance.new("UIGradient", b)
    gr.Color = ColorSequence.new(Color3.fromRGB(0, 40, 28), Color3.fromRGB(8, 10, 9))
    gr.Rotation = 90

    local function lbl(t, y, h, sz, col, f)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, h)
        l.Position = UDim2.new(0, 0, 0, y)
        l.BackgroundTransparency = 1
        l.Font = f or Enum.Font.Gotham
        l.TextSize = sz
        l.TextColor3 = col
        l.Text = t
        l.Parent = b
        return l
    end
    lbl("VENOM HUB", 18, 50, 22, Color3.fromRGB(0, 255, 136), Enum.Font.GothamBold)
    lbl("Enter your key to continue", 58, 20, 12, Color3.fromRGB(140, 160, 150))

    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, -50, 0, 42)
    box.Position = UDim2.new(0, 25, 0, 95)
    box.BackgroundColor3 = Color3.fromRGB(16, 20, 18)
    box.BorderSizePixel = 0
    box.Parent = b
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local bs = Instance.new("UIStroke", box)
    bs.Color = Color3.fromRGB(0, 255, 136)
    bs.Thickness = 1
    bs.Transparency = .6

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, -20, 1, 0)
    tb.Position = UDim2.new(0, 10, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Font = Enum.Font.Gotham
    tb.TextSize = 14
    tb.TextColor3 = Color3.new(1, 1, 1)
    tb.PlaceholderText = "VENOM-HUB-XXXX-XXXX"
    tb.PlaceholderColor3 = Color3.fromRGB(100, 110, 105)
    tb.Text = ""
    tb.ClearTextOnFocus = false
    tb.Parent = box

    local st = lbl("", 143, 18, 12, Color3.fromRGB(255, 80, 80))

    local function mk(t, y, c)
        local x = Instance.new("TextButton")
        x.Size = UDim2.new(1, -50, 0, 38)
        x.Position = UDim2.new(0, 25, 0, y)
        x.BackgroundColor3 = c
        x.BorderSizePixel = 0
        x.Font = Enum.Font.GothamBold
        x.TextSize = 14
        x.TextColor3 = Color3.fromRGB(8, 10, 9)
        x.Text = t
        x.Parent = b
        Instance.new("UICorner", x).CornerRadius = UDim.new(0, 8)
        return x
    end
    local cb = mk("CHECK KEY", 170, Color3.fromRGB(0, 255, 136))
    local db = mk("GET KEY (Discord)", 218, Color3.fromRGB(88, 101, 242))

    local at, lock = 0, false
    local function sfx(id, v)
        pcall(function()
            local s = Instance.new("Sound")
            s.SoundId = id
            s.Volume = v
            s.Parent = SoundService
            s:Play()
            s.Ended:Connect(function() s:Destroy() end)
        end)
    end

    cb.MouseButton1Click:Connect(function()
        if lock then return end
        local i = tb.Text:gsub("%s+", "")
        if i == "" then st.Text = "Please enter a key" return end
        st.TextColor3 = Color3.fromRGB(255, 200, 80)
        st.Text = "Verifying..."
        task.wait(.6)
        if i == KEY then
            lock = true
            st.TextColor3 = Color3.fromRGB(0, 255, 136)
            st.Text = "Key valid! Loading..."
            writeKey(os.time())
            sfx("rbxassetid://6026984224", .5)
            task.wait(.8)
            TweenService:Create(b, TweenInfo.new(.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(), BackgroundTransparency = 1}):Play()
            task.wait(.45)
            g:Destroy()
            _G.__VenomGo()
        else
            at += 1
            st.TextColor3 = Color3.fromRGB(255, 80, 80)
            st.Text = "Invalid key (" .. at .. ")"
            local o = b.Position
            for k = 1, 6 do
                b.Position = o + UDim2.fromOffset(math.sin(k * 3) * 8, 0)
                task.wait(.03)
            end
            b.Position = o
        end
    end)

    db.MouseButton1Click:Connect(function()
        local f = setclipboard or toclipboard or (syn and syn.write_clipboard)
        if type(f) == "function" then
            pcall(function() f(DISCORD) end)
            st.TextColor3 = Color3.fromRGB(0, 255, 136)
            st.Text = "Discord link copied!"
        else
            st.TextColor3 = Color3.fromRGB(255, 200, 80)
            st.Text = "Link: " .. DISCORD
        end
        sfx("rbxassetid://6895079853", .4)
    end)
end

local function hub()
    local function hp(u)
        local ok, res = pcall(game.HttpGet, game, u)
        if ok and res ~= "" then return res end
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then
            local r = req({Url = u, Method = "GET"})
            if r and r.Body then return r.Body end
        end
        return ""
    end

    local function gl()
        local c = hp("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
        if c == "" then c = hp("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua") end
        if c == "" then error("WindUI load failed") end
        local W = loadstring(c)()
        pcall(function()
            W:AddTheme({
                Name = "VENOM HUB",
                Background = W:Gradient({["0"] = {Color = Color3.fromHex("#0A0A0C"), Transparency = .12}, ["100"] = {Color = Color3.fromHex("#0A0A0C"), Transparency = .12}}, {Rotation = 90}),
                Accent = W:Gradient({["0"] = {Color = Color3.fromHex("#0D3B2E"), Transparency = 0}, ["100"] = {Color = Color3.fromHex("#00FF88"), Transparency = 0}}, {Rotation = 90}),
                Dialog = Color3.fromHex("#0A0A0C"),
                Outline = Color3.fromHex("#ffffff"),
                Text = Color3.fromHex("#ffffff"),
                Placeholder = Color3.fromHex("#a1a1aa"),
                Button = Color3.fromHex("#0D3B2E"),
                Icon = Color3.fromHex("#00FF88"),
                Toggle = Color3.fromHex("#00FF88"),
                Slider = Color3.fromHex("#00FF88"),
                Checkbox = Color3.fromHex("#00FF88"),
                SliderIcon = Color3.fromHex("#71717a"),
                Primary = Color3.fromHex("#00FF88"),
                PanelBackground = Color3.fromHex("#ffffff"),
                PanelBackgroundTransparency = .94,
                LabelBackground = Color3.fromHex("#000000"),
                LabelBackgroundTransparency = .8,
                ElementBackground = Color3.fromHex("#121214"),
                ElementBackgroundTransparency = .3
            })
            W:SetTheme("VENOM HUB")
        end)
        return W
    end

    local W = gl()
    local LOGO = "82585983764987"
    local gN = "Roblox"
    pcall(function() gN = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)

    if not game:IsLoaded() then game.Loaded:Wait() end

    getgenv().MortyState = {
        ESPPro = false, ESPChams = false, SnapDepth = 10, Crosshair = false,
        CrosshairSize = 24, SilentAim = false, LegitAimbot = false, AimbotSmooth = 5,
        NoRecoil = false, HeadHitbox = false, HitboxSize = 2, HitboxEnabled = false,
        AntiFling = false, CameraZoom = 70, FOVSize = 130, ShowFOV = false,
        InfiniteStamina = false, LowEndBoost = false, CFrameSpeedEnabled = false,
        CFrameSpeedValue = 1, FakeLagEnabled = false, AntiAFKEnabled = false
    }

    local ElectricBlue = Color3.fromRGB(0, 160, 255)
    local CyanGlow = Color3.fromRGB(0, 230, 255)
    local savedPosition = nil
    local isUnderground = false

    local SFX = {
        Click = "rbxassetid://6895079853",
        Toggle = "rbxassetid://6026984224",
        Notify = "rbxassetid://4590662766"
    }
    local function ps(id, v, p)
        pcall(function()
            local s = Instance.new("Sound")
            s.SoundId = id
            s.Volume = v or .35
            s.PlaybackSpeed = p or 1
            s.Parent = SoundService
            s:Play()
            s.Ended:Connect(function() s:Destroy() end)
        end)
    end
    local function ntf(t, c, ok)
        ps(SFX.Notify, .35, ok == false and .9 or 1.05)
        W:Notify({Title = t, Content = c, Duration = 2.5})
    end

    local Win = W:CreateWindow({
        Title = "VENOM HUB",
        Icon = "rbxassetid://"..LOGO,
        Author = gN,
        Folder = "VENOMHUB",
        Size = UDim2.fromOffset(520, 420),
        MaxSize = Vector2.new(850, 560),
        MinSize = Vector2.new(320, 300),
        Resizable = true,
        Transparent = true,
        Theme = "VENOM HUB",
        BackgroundImageTransparency = .35,
        Acrylic = false,
        ShadowTransparency = .3,
        Radius = 18,
        IconRadius = 1,
        IconSize = 27,
        SideBarWidth = 185,
        Topbar = {Height = 56, ButtonsType = "Default"},
        User = {Enabled = true, Anonymous = false},
        OpenButton = {
            Title = "VENOM HUB",
            Icon = "rbxassetid://"..LOGO,
            CornerRadius = UDim.new(0, 16),
            StrokeThickness = 1,
            Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 136)), ColorSequenceKeypoint.new(1, Color3.fromRGB(184, 255, 74))},
            OnlyMobile = false,
            Enabled = true,
            Draggable = true
        }
    })

    -- 1. INFORMACIÓN
    local InfoTab = Win:Tab({Title = "Información", Icon = "info"})
    InfoTab:Paragraph({
        Title = "🔵 ¡Gracias por usar VENOM HUB!",
        Desc = "Versión Pro con Silent Aim, Aimbot Legit y Anti-Lag."
    })
    InfoTab:Section({Title = "Soporte & Redes"})
    InfoTab:Button({
        Title = "📋 Copiar Link del Discord",
        Desc = DISCORD,
        Callback = function()
            ps(SFX.Click, .3, 1.1)
            if setclipboard then
                setclipboard(DISCORD)
                ntf("Discord Copiado", "¡Enlace copiado con éxito!", true)
            end
        end
    })
    InfoTab:Paragraph({
        Title = "📱 Redes Oficiales",
        Desc = "• Discord: <font color='#FF5050'>VENOM HUB</font>\n• Servidor: <font color='#FF5050'>"..DISCORD.."</font>"
    })

    -- 2. COMBATE
    local CombatTab = Win:Tab({Title = "Combate", Icon = "target"})
    CombatTab:Section({Title = "Panel Snap Down (Subsuelo)"})
    CombatTab:Toggle({
        Title = "Mostrar Panel Snap Down",
        Desc = "<font color='#FF5050'>⚠ Muestra un cuadro flotante para bajar bajo el mapa y escapar/emboscar.</font>",
        Value = false,
        Callback = function(s)
            ps(SFX.Toggle, .35, s and 1.1 or .9)
            local gui = CoreGui:FindFirstChild("MortySnapDownGui") or LocalPlayer.PlayerGui:FindFirstChild("MortySnapDownGui")
            if gui then gui.Enabled = s end
        end
    })
    CombatTab:Section({Title = "Aim Assist & Disparos"})
    CombatTab:Toggle({
        Title = "Silent Aim (Disparo Silencioso)",
        Desc = "<font color='#FF5050'>⚠ Redirige tus disparos al enemigo más cercano dentro del FOV sin mover la cámara.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.SilentAim = s end
    })
    CombatTab:Toggle({
        Title = "Aimbot Legit (Auto-Apuntado)",
        Desc = "<font color='#FF5050'>⚠ Mueve suavemente la cámara hacia el enemigo más cercano dentro del FOV.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.LegitAimbot = s end
    })
    CombatTab:Slider({
        Title = "Suavizado del Aimbot",
        Desc = "<font color='#FF5050'>⚠ 1 = muy rápido/seco, 15 = muy lento/suave.</font>",
        Value = {Min = 1, Max = 15, Default = 5},
        Callback = function(v) getgenv().MortyState.AimbotSmooth = v end
    })
    CombatTab:Toggle({
        Title = "No Recoil (Sin Retroceso)",
        Desc = "<font color='#FF5050'>⚠ Elimina el retroceso y la dispersión del arma equipada.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.NoRecoil = s end
    })
    CombatTab:Section({Title = "Hitboxes (Cajas de Golpe)"})
    CombatTab:Toggle({
        Title = "Expandir Hitbox del Cuerpo",
        Desc = "<font color='#FF5050'>⚠ Agranda el cuerpo de los enemigos para recibir más disparos.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.HitboxEnabled = s end
    })
    CombatTab:Toggle({
        Title = "Hitbox Gigante en la Cabeza",
        Desc = "<font color='#FF5050'>⚠ Prioriza la cabeza para headshots fáciles.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.HeadHitbox = s end
    })
    CombatTab:Slider({
        Title = "Tamaño de la Hitbox",
        Desc = "<font color='#FF5050'>⚠ Multiplicador del tamaño (2 = normal agrandada, 8 = enorme).</font>",
        Value = {Min = 2, Max = 8, Default = 2},
        Callback = function(v) getgenv().MortyState.HitboxSize = v end
    })
    CombatTab:Section({Title = "Ventajas PvP"})
    CombatTab:Toggle({
        Title = "Stamina Infinita",
        Desc = "<font color='#FF5050'>⚠ Mantiene llenos los valores de stamina/energía mientras esté activo.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.InfiniteStamina = s end
    })
    CombatTab:Toggle({
        Title = "Anti-Fling (Anti-Empujón)",
        Desc = "<font color='#FF5050'>⚠ Anula la velocidad y giro que te lanzan al ser empujado.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.AntiFling = s end
    })
    CombatTab:Section({Title = "Cámara, Mira & FOV"})
    CombatTab:Slider({
        Title = "Zoom / FOV de Cámara",
        Desc = "<font color='#FF5050'>⚠ 30 = muy cerca, 120 = muy amplio (más visión).</font>",
        Value = {Min = 30, Max = 120, Default = 70},
        Callback = function(v)
            getgenv().MortyState.CameraZoom = v
            pcall(function() Camera.FieldOfView = v end)
        end
    })
    CombatTab:Toggle({
        Title = "Mostrar Círculo FOV",
        Desc = "<font color='#FF5050'>⚠ Dibuja en pantalla el círculo donde actúan aimbot/silent aim.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.ShowFOV = s end
    })
    CombatTab:Slider({
        Title = "Tamaño del FOV",
        Desc = "<font color='#FF5050'>⚠ Radio del círculo de detección (en píxeles).</font>",
        Value = {Min = 50, Max = 300, Default = 130},
        Callback = function(v) getgenv().MortyState.FOVSize = v end
    })
    CombatTab:Toggle({
        Title = "Mira Central Arrastrable",
        Desc = "<font color='#FF5050'>⚠ Muestra un diamante en el centro que puedes arrastrar con el ratón.</font>",
        Value = false,
        Callback = function(s)
            ps(SFX.Toggle, .35, s and 1.1 or .9)
            getgenv().MortyState.Crosshair = s
            local gui = CoreGui:FindFirstChild("MortySafeCrosshair") or LocalPlayer.PlayerGui:FindFirstChild("MortySafeCrosshair")
            if gui and gui:FindFirstChild("MovableDiamond") then gui.MovableDiamond.Visible = s end
        end
    })

    -- 3. VISUALES
    local VisualTab = Win:Tab({Title = "Visuales", Icon = "eye"})
    VisualTab:Section({Title = "ESP & Chams"})
    VisualTab:Toggle({
        Title = "ESP de Tarjeta (Vida + Arma)",
        Desc = "<font color='#FF5050'>⚠ Muestra sobre cada enemigo su nombre, vida y arma equipada.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.ESPPro = s end
    })
    VisualTab:Toggle({
        Title = "Chams (Brillo Total)",
        Desc = "<font color='#FF5050'>⚠ Pinta a los enemigos de neón azul para verlos a través de paredes.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.ESPChams = s end
    })

    -- 4. JUGADOR
    local PlayerTab = Win:Tab({Title = "Jugador", Icon = "user"})
    PlayerTab:Section({Title = "Velocidad & Desync"})
    PlayerTab:Toggle({
        Title = "CFrame Speed (Velocidad Rota)",
        Desc = "<font color='#FF5050'>⚠ Te mueve por CFrame a gran velocidad. Cuidado, es detectable.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.CFrameSpeedEnabled = s end
    })
    PlayerTab:Slider({
        Title = "Intensidad de Velocidad",
        Desc = "<font color='#FF5050'>⚠ 0.5 = lento, 3.5 = rapidísimo. Empieza bajo.</font>",
        Value = {Min = 0.5, Max = 3.5, Default = 1},
        Callback = function(v) getgenv().MortyState.CFrameSpeedValue = v end
    })
    PlayerTab:Toggle({
        Title = "Fake Lag / Desync Local",
        Desc = "<font color='#FF5050'>⚠ Congela tu posición a ratos para desincronizar de los enemigos.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.FakeLagEnabled = s end
    })

    -- 5. RENDIMIENTO
    local MiscTab = Win:Tab({Title = "Rendimiento", Icon = "settings"})
    MiscTab:Section({Title = "Anti-Lag / Gama Baja"})
    MiscTab:Toggle({
        Title = "Modo Anti-Lag Ultra FPS",
        Desc = "<font color='#FF5050'>⚠ Quita sombras, materiales y partículas para subir FPS.</font>",
        Value = false,
        Callback = function(s)
            ps(SFX.Toggle, .35, s and 1.1 or .9)
            getgenv().MortyState.LowEndBoost = s
            pcall(function()
                if s then
                    Lighting.GlobalShadows = false
                    Lighting.Brightness = 2
                    for _, v in ipairs(Workspace:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.Material = Enum.Material.SmoothPlastic
                            v.Reflectance = 0
                        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                            v.Enabled = false
                        end
                    end
                    ntf("Anti-Lag Activado", "¡Optimizado para gama baja!", true)
                else
                    Lighting.GlobalShadows = true
                    ntf("Anti-Lag Desactivado", "Restaurando gráficos...", true)
                end
            end)
        end
    })
    MiscTab:Section({Title = "Sistema"})
    MiscTab:Toggle({
        Title = "Anti-AFK (Evitar Expulsión)",
        Desc = "<font color='#FF5050'>⚠ Mueve el mouse solo para que Roblox no te expulse por inactividad.</font>",
        Value = false,
        Callback = function(s) ps(SFX.Toggle, .35, s and 1.1 or .9) getgenv().MortyState.AntiAFKEnabled = s end
    })
    MiscTab:Button({
        Title = "🔄 Reconectarse (Rejoin)",
        Desc = "<font color='#FF5050'>⚠ Te vuelve a meter a la misma partida del servidor actual.</font>",
        Callback = function()
            ps(SFX.Click, .3, 1.1)
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
        end
    })

    -- LOOPS
    task.spawn(function()
        task.wait(1)
        local FOVCircle = Drawing.new("Circle")
        FOVCircle.Thickness = 1.5
        FOVCircle.NumSides = 32
        FOVCircle.Radius = 130
        FOVCircle.Filled = false
        FOVCircle.Color = ElectricBlue
        FOVCircle.Visible = false

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "MortySafeCrosshair"
        ScreenGui.ResetOnSpawn = false
        pcall(function() ScreenGui.Parent = CoreGui end)
        if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

        local CrosshairFrame = Instance.new("Frame", ScreenGui)
        CrosshairFrame.Name = "MovableDiamond"
        CrosshairFrame.Size = UDim2.new(0, 24, 0, 24)
        CrosshairFrame.Position = UDim2.new(0.5, -12, 0.5, -12)
        CrosshairFrame.BackgroundTransparency = 1
        CrosshairFrame.Rotation = 45
        CrosshairFrame.Visible = false
        CrosshairFrame.Active = true
        CrosshairFrame.Draggable = true

        local CrosshairInner = Instance.new("Frame", CrosshairFrame)
        CrosshairInner.Size = UDim2.new(1, 0, 1, 0)
        CrosshairInner.BackgroundColor3 = ElectricBlue
        CrosshairInner.BackgroundTransparency = 0.35
        CrosshairInner.BorderSizePixel = 0

        local CrosshairStroke = Instance.new("UIStroke", CrosshairInner)
        CrosshairStroke.Color = CyanGlow
        CrosshairStroke.Transparency = 0.1
        CrosshairStroke.Thickness = 2.5

        local SnapGui = Instance.new("ScreenGui")
        SnapGui.Name = "MortySnapDownGui"
        SnapGui.ResetOnSpawn = false
        SnapGui.Enabled = false
        pcall(function() SnapGui.Parent = CoreGui end)
        if not SnapGui.Parent then SnapGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

        local SnapCard = Instance.new("Frame", SnapGui)
        SnapCard.Name = "CardFrame"
        SnapCard.Size = UDim2.new(0, 240, 0, 140)
        SnapCard.Position = UDim2.new(0.3, 0, 0.3, 0)
        SnapCard.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        SnapCard.BorderSizePixel = 0
        SnapCard.Active = true
        SnapCard.Draggable = true
        Instance.new("UICorner", SnapCard).CornerRadius = UDim.new(0, 10)
        local SnapStroke = Instance.new("UIStroke", SnapCard)
        SnapStroke.Color = ElectricBlue
        SnapStroke.Thickness = 2

        local CloseSnap = Instance.new("TextButton", SnapCard)
        CloseSnap.Size = UDim2.new(0, 24, 0, 24)
        CloseSnap.Position = UDim2.new(1, -30, 0, 8)
        CloseSnap.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        CloseSnap.Text = "X"
        CloseSnap.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseSnap.TextSize = 13
        CloseSnap.Font = Enum.Font.GothamBold
        CloseSnap.MouseButton1Click:Connect(function() SnapGui.Enabled = false end)

        local MetersLabel = Instance.new("TextLabel", SnapCard)
        MetersLabel.Size = UDim2.new(0.6, 0, 0, 24)
        MetersLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
        MetersLabel.BackgroundTransparency = 1
        MetersLabel.Text = "Profundidad: 10m"
        MetersLabel.TextColor3 = CyanGlow
        MetersLabel.TextSize = 13
        MetersLabel.Font = Enum.Font.GothamBold

        local SliderBack = Instance.new("Frame", SnapCard)
        SliderBack.Size = UDim2.new(0.8, 0, 0, 6)
        SliderBack.Position = UDim2.new(0.1, 0, 0.42, 0)
        SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

        local SliderBar = Instance.new("Frame", SliderBack)
        SliderBar.Size = UDim2.new(0.3, 0, 1, 0)
        SliderBar.BackgroundColor3 = ElectricBlue

        local SliderButton = Instance.new("TextButton", SliderBar)
        SliderButton.Size = UDim2.new(0, 14, 0, 14)
        SliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
        SliderButton.Position = UDim2.new(1, 0, 0.5, 0)
        SliderButton.BackgroundColor3 = CyanGlow
        SliderButton.Text = ""

        local SnapButton = Instance.new("TextButton", SnapCard)
        SnapButton.Size = UDim2.new(0.85, 0, 0, 36)
        SnapButton.Position = UDim2.new(0.075, 0, 0.58, 0)
        SnapButton.BackgroundColor3 = ElectricBlue
        SnapButton.Text = "SNAP DOWN"
        SnapButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SnapButton.TextSize = 15
        SnapButton.Font = Enum.Font.GothamBold

        SnapButton.MouseButton1Click:Connect(function()
            ps(SFX.Click, .3, 1)
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not isUnderground then
                        savedPosition = hrp.CFrame
                        hrp.CFrame = hrp.CFrame - Vector3.new(0, getgenv().MortyState.SnapDepth, 0)
                        hrp.Anchored = true
                        isUnderground = true
                        SnapButton.Text = "GO UP"
                    else
                        hrp.Anchored = false
                        if savedPosition then hrp.CFrame = savedPosition end
                        isUnderground = false
                        SnapButton.Text = "SNAP DOWN"
                    end
                end
            end)
        end)

        local draggingSlider = false
        SliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = true
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                SliderBar.Size = UDim2.new(pos, 0, 1, 0)
                local meters = math.floor(pos * 29) + 1
                getgenv().MortyState.SnapDepth = meters
                MetersLabel.Text = "Profundidad: " .. meters .. "m"
            end
        end)

        local function getClosestPlayerInFOV()
            local closest = nil
            local shortestDist = getgenv().MortyState.FOVSize
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local targetPart = p.Character:FindFirstChild("Head") or p.Character.HumanoidRootPart
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closest = targetPart
                            end
                        end
                    end
                end
            end
            return closest
        end

        RunService.RenderStepped:Connect(function()
            pcall(function()
                FOVCircle.Visible = getgenv().MortyState.ShowFOV
                FOVCircle.Radius = getgenv().MortyState.FOVSize
                FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

                if getgenv().MortyState.InfiniteStamina then
                    local char = LocalPlayer.Character
                    if char then
                        for _, v in ipairs(char:GetDescendants()) do
                            if v:IsA("NumberValue") and (v.Name:lower():find("stamina") or v.Name:lower():find("energy")) then
                                v.Value = 100
                            end
                        end
                    end
                end

                if getgenv().MortyState.SilentAim or getgenv().MortyState.LegitAimbot then
                    local target = getClosestPlayerInFOV()
                    if target then
                        if getgenv().MortyState.LegitAimbot then
                            local camPos = Camera.CFrame.Position
                            local targetCF = CFrame.new(camPos, target.Position)
                            Camera.CFrame = Camera.CFrame:Lerp(targetCF, 1 / math.clamp(getgenv().MortyState.AimbotSmooth, 1, 20))
                        end
                    end
                end

                if getgenv().MortyState.NoRecoil then
                    local char = LocalPlayer.Character
                    if char then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            for _, v in ipairs(tool:GetDescendants()) do
                                if v:IsA("NumberValue") and (v.Name:lower():find("recoil") or v.Name:lower():find("spread")) then
                                    v.Value = 0
                                end
                            end
                        end
                    end
                end

                if getgenv().MortyState.AntiFling then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                    end
                end

                if getgenv().MortyState.HitboxEnabled then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            if getgenv().MortyState.HeadHitbox and p.Character:FindFirstChild("Head") then
                                local head = p.Character.Head
                                head.Size = Vector3.new(getgenv().MortyState.HitboxSize * 1.5, getgenv().MortyState.HitboxSize * 1.5, getgenv().MortyState.HitboxSize * 1.5)
                                head.Transparency = 0.6
                                head.CanCollide = false
                            elseif p.Character:FindFirstChild("HumanoidRootPart") then
                                local hrp = p.Character.HumanoidRootPart
                                hrp.Size = Vector3.new(getgenv().MortyState.HitboxSize, getgenv().MortyState.HitboxSize, getgenv().MortyState.HitboxSize)
                                hrp.Transparency = 0.7
                                hrp.CanCollide = false
                            end
                        end
                    end
                end

                if getgenv().MortyState.CFrameSpeedEnabled then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * getgenv().MortyState.CFrameSpeedValue)
                    end
                end

                if getgenv().MortyState.FakeLagEnabled then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        if math.random(1, 15) == 1 then
                            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        end)
    end)

    LocalPlayer.Idled:Connect(function()
        if getgenv().MortyState.AntiAFKEnabled then
            local vu = game:GetService("VirtualUser")
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)

    local espCache = {}
    local function removeESP(p)
        if espCache[p] then
            if espCache[p].bill then espCache[p].bill:Destroy() end
            espCache[p] = nil
        end
    end
    local function getEquippedWeapon(char)
        if not char then return "Desarmado" end
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then return item.Name end
        end
        return "Desarmado"
    end

    RunService.RenderStepped:Connect(function()
        pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
                    local pChar = p.Character
                    local pHum = pChar:FindFirstChildOfClass("Humanoid")
                    local pHead = pChar.Head
                    if getgenv().MortyState.ESPChams then
                        for _, part in ipairs(pChar:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Material = Enum.Material.Neon
                                part.Color = ElectricBlue
                            end
                        end
                    end
                    if getgenv().MortyState.ESPPro and pHum and pHum.Health > 0 then
                        if not espCache[p] then
                            local bill = Instance.new("BillboardGui")
                            bill.Name = "MortyCardESP"
                            bill.AlwaysOnTop = true
                            bill.Size = UDim2.new(0, 160, 0, 50)
                            bill.StudsOffset = Vector3.new(0, 3, 0)
                            bill.Adornee = pHead
                            local nameLbl = Instance.new("TextLabel", bill)
                            nameLbl.Name = "Name"
                            nameLbl.Size = UDim2.new(1, 0, 0, 18)
                            nameLbl.BackgroundTransparency = 1
                            nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                            nameLbl.TextStrokeTransparency = 0
                            nameLbl.TextSize = 12
                            nameLbl.Font = Enum.Font.GothamBold
                            local hpBack = Instance.new("Frame", bill)
                            hpBack.Name = "HPBack"
                            hpBack.Size = UDim2.new(0.9, 0, 0, 10)
                            hpBack.Position = UDim2.new(0.05, 0, 0, 22)
                            hpBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                            hpBack.BorderSizePixel = 0
                            local hpBar = Instance.new("Frame", hpBack)
                            hpBar.Name = "HPBar"
                            hpBar.Size = UDim2.new(1, 0, 1, 0)
                            hpBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                            hpBar.BorderSizePixel = 0
                            local weaponLbl = Instance.new("TextLabel", bill)
                            weaponLbl.Name = "Weapon"
                            weaponLbl.Size = UDim2.new(1, 0, 0, 16)
                            weaponLbl.Position = UDim2.new(0, 0, 0, 34)
                            weaponLbl.BackgroundTransparency = 1
                            weaponLbl.TextColor3 = CyanGlow
                            weaponLbl.TextStrokeTransparency = 0
                            weaponLbl.TextSize = 10
                            weaponLbl.Font = Enum.Font.Gotham
                            bill.Parent = pHead
                            espCache[p] = {bill = bill, bar = hpBar, name = nameLbl, weap = weaponLbl}
                        else
                            local data = espCache[p]
                            if data and data.bar and data.name and data.weap then
                                data.name.Text = p.Name
                                local healthPercent = math.clamp(pHum.Health / pHum.MaxHealth, 0, 1)
                                data.bar.Size = UDim2.new(healthPercent, 0, 1, 0)
                                data.weap.Text = "Arma: " .. getEquippedWeapon(pChar)
                            end
                        end
                    else
                        removeESP(p)
                    end
                else
                    removeESP(p)
                end
            end
        end)
    end)

    W:Notify({Title = "VENOM HUB", Content = "¡Carga completa y estable!", Duration = 3, Icon = "check"})
end

_G.__VenomGo = hub

if readKey() and (os.time() - readKey()) < DURATION then
    _G.__VenomGo()
else
    gate()
end
