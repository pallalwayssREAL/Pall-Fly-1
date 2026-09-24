--========================================================--
--  Pall Fly                                            --
--  By @Pall                                            --
--  Fitur: Minimize + Hide + Logo + Keybind             --
--========================================================--

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

--========================= CONFIG =========================--
local FLY_SPEED      = 60
local SPRINT_MULT    = 2.5
local TOGGLE_KEY     = Enum.KeyCode.C
local MINIMIZE_KEY   = Enum.KeyCode.M
local HIDE_KEY       = Enum.KeyCode.H
local SPEED_MIN      = 1
local SPEED_MAX      = 1000
--==========================================================--

local flying   = false
local bodyVel  = nil
local bodyGyro = nil

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

--========================= MAIN PANEL =========================--
local PANEL_W = 220
local PANEL_H = 250

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
panel.Position = UDim2.new(0, 20, 0.5, -PANEL_H/2)
panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 14)
panelCorner.Parent = panel

local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 12, 1, 12)
shadow.Position = UDim2.new(0, -6, 0, 4)
shadow.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
shadow.BackgroundTransparency = 0.72
shadow.BorderSizePixel = 0
shadow.ZIndex = panel.ZIndex - 1
shadow.Parent = panel
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 18)
shadowCorner.Parent = shadow

--========================= TITLE BAR =========================--
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(248, 248, 252)
titleBar.BorderSizePixel = 0
titleBar.Parent = panel
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar
local titleFill = Instance.new("Frame")
titleFill.Size = UDim2.new(1, 0, 0, 14)
titleFill.Position = UDim2.new(0, 0, 1, -14)
titleFill.BackgroundColor3 = Color3.fromRGB(248, 248, 252)
titleFill.BorderSizePixel = 0
titleFill.Parent = titleBar

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 8, 0, 8)
dot.Position = UDim2.new(0, 14, 0.5, -4)
dot.BackgroundColor3 = Color3.fromRGB(130, 130, 255)
dot.BorderSizePixel = 0
dot.Parent = titleBar
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Pall Fly  |  By @Pall"
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 30, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextColor3 = Color3.fromRGB(30, 30, 40)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Tombol Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
minimizeBtn.Position = UDim2.new(1, -60, 0.5, -13)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(235, 235, 245)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(80, 80, 100)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = titleBar
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

-- Tombol Hide
local hideBtn = Instance.new("TextButton")
hideBtn.Name = "HideBtn"
hideBtn.Size = UDim2.new(0, 26, 0, 26)
hideBtn.Position = UDim2.new(1, -30, 0.5, -13)
hideBtn.BackgroundColor3 = Color3.fromRGB(255, 225, 225)
hideBtn.BorderSizePixel = 0
hideBtn.Text = "×"
hideBtn.TextColor3 = Color3.fromRGB(200, 70, 70)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 18
hideBtn.AutoButtonColor = false
hideBtn.Parent = titleBar
local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 8)
hideCorner.Parent = hideBtn

--========================= DIVIDER =========================--
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -28, 0, 1)
divider.Position = UDim2.new(0, 14, 0, 40)
divider.BackgroundColor3 = Color3.fromRGB(230, 230, 238)
divider.BorderSizePixel = 0
divider.Parent = panel

--========================= TOGGLE FLY =========================--
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(1, -28, 0, 38)
toggleBtn.Position = UDim2.new(0, 14, 0, 50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
toggleBtn.BorderSizePixel = 0
toggleBtn.Font = Enum.Font.GothamSemibold
toggleBtn.TextSize = 13
toggleBtn.TextColor3 = Color3.fromRGB(60, 60, 80)
toggleBtn.Text = "▶  Enable Fly  [C]"
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = panel
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = toggleBtn

local divider2 = Instance.new("Frame")
divider2.Size = UDim2.new(1, -28, 0, 1)
divider2.Position = UDim2.new(0, 14, 0, 100)
divider2.BackgroundColor3 = Color3.fromRGB(230, 230, 238)
divider2.BorderSizePixel = 0
divider2.Parent = panel

--========================= SPEED SLIDER =========================--
local speedHeaderRow = Instance.new("Frame")
speedHeaderRow.Size = UDim2.new(1, -28, 0, 24)
speedHeaderRow.Position = UDim2.new(0, 14, 0, 110)
speedHeaderRow.BackgroundTransparency = 1
speedHeaderRow.Parent = panel

local speedTitleLbl = Instance.new("TextLabel")
speedTitleLbl.Text = "Speed"
speedTitleLbl.Size = UDim2.new(0.5, 0, 1, 0)
speedTitleLbl.BackgroundTransparency = 1
speedTitleLbl.Font = Enum.Font.GothamSemibold
speedTitleLbl.TextSize = 11
speedTitleLbl.TextColor3 = Color3.fromRGB(80, 80, 100)
speedTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
speedTitleLbl.Parent = speedHeaderRow

local speedNumLbl = Instance.new("TextLabel")
speedNumLbl.Name = "SpeedNum"
speedNumLbl.Text = tostring(FLY_SPEED)
speedNumLbl.Size = UDim2.new(0.5, 0, 1, 0)
speedNumLbl.Position = UDim2.new(0.5, 0, 0, 0)
speedNumLbl.BackgroundTransparency = 1
speedNumLbl.Font = Enum.Font.GothamBold
speedNumLbl.TextSize = 11
speedNumLbl.TextColor3 = Color3.fromRGB(130, 130, 255)
speedNumLbl.TextXAlignment = Enum.TextXAlignment.Right
speedNumLbl.Parent = speedHeaderRow

local TRACK_H    = 6
local THUMB_SIZE = 18
local SLIDER_Y   = 144

local sliderTrack = Instance.new("Frame")
sliderTrack.Name = "SliderTrack"
sliderTrack.Size = UDim2.new(1, -28, 0, TRACK_H)
sliderTrack.Position = UDim2.new(0, 14, 0, SLIDER_Y + (THUMB_SIZE - TRACK_H)/2)
sliderTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = panel
local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = sliderTrack

local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(130, 130, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

local sliderThumb = Instance.new("Frame")
sliderThumb.Name = "SliderThumb"
sliderThumb.Size = UDim2.new(0, THUMB_SIZE, 0, THUMB_SIZE)
sliderThumb.AnchorPoint = Vector2.new(0.5, 0.5)
sliderThumb.Position = UDim2.new(0, 0, 0.5, 0)
sliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderThumb.BorderSizePixel = 0
sliderThumb.ZIndex = 5
sliderThumb.Parent = sliderTrack
local thumbCorner = Instance.new("UICorner")
thumbCorner.CornerRadius = UDim.new(1, 0)
thumbCorner.Parent = sliderThumb
local thumbShadow = Instance.new("UIStroke")
thumbShadow.Color = Color3.fromRGB(180, 180, 210)
thumbShadow.Thickness = 1.5
thumbShadow.Parent = sliderThumb

--========================= STATUS =========================--
local statusRow = Instance.new("Frame")
statusRow.Size = UDim2.new(1, -28, 0, 20)
statusRow.Position = UDim2.new(0, 14, 0, 182)
statusRow.BackgroundTransparency = 1
statusRow.Parent = panel

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 7, 0, 7)
statusDot.Position = UDim2.new(0, 0, 0.5, -3)
statusDot.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
statusDot.BorderSizePixel = 0
statusDot.Parent = statusRow
local sDotCorner = Instance.new("UICorner")
sDotCorner.CornerRadius = UDim.new(1, 0)
sDotCorner.Parent = statusDot

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Text = "Idle  |  By @Pall"
statusLabel.Size = UDim2.new(1, -14, 1, 0)
statusLabel.Position = UDim2.new(0, 14, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusRow

--========================= KEYBIND INFO =========================--
local keybindRow = Instance.new("Frame")
keybindRow.Size = UDim2.new(1, -28, 0, 20)
keybindRow.Position = UDim2.new(0, 14, 0, 206)
keybindRow.BackgroundTransparency = 1
keybindRow.Parent = panel

local keybindLbl = Instance.new("TextLabel")
keybindLbl.Name = "KeybindLbl"
keybindLbl.Text = "Keybind: C Fly | M Min | H Hide"
keybindLbl.Size = UDim2.new(1, 0, 1, 0)
keybindLbl.BackgroundTransparency = 1
keybindLbl.Font = Enum.Font.Gotham
keybindLbl.TextSize = 9
keybindLbl.TextColor3 = Color3.fromRGB(150, 150, 170)
keybindLbl.TextXAlignment = Enum.TextXAlignment.Left
keybindLbl.Parent = keybindRow

--========================= FLOATING LOGO =========================--
local logoBtn = Instance.new("TextButton")
logoBtn.Name = "FloatingLogo"
logoBtn.Size = UDim2.new(0, 56, 0, 56)
logoBtn.Position = UDim2.new(0.5, -28, 0.5, -28)
logoBtn.BackgroundColor3 = Color3.fromRGB(130, 130, 255)
logoBtn.BorderSizePixel = 0
logoBtn.Text = "P"
logoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
logoBtn.Font = Enum.Font.GothamBold
logoBtn.TextSize = 26
logoBtn.AutoButtonColor = false
logoBtn.Visible = false
logoBtn.Parent = screenGui

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logoBtn

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(255, 255, 255)
logoStroke.Thickness = 2
logoStroke.Parent = logoBtn

-- Label kecil di bawah logo
local logoTag = Instance.new("TextLabel")
logoTag.Name = "LogoTag"
logoTag.Size = UDim2.new(0, 80, 0, 14)
logoTag.Position = UDim2.new(0.5, -40, 0.5, 32)
logoTag.BackgroundTransparency = 1
logoTag.Font = Enum.Font.GothamBold
logoTag.TextSize = 10
logoTag.TextColor3 = Color3.fromRGB(130, 130, 255)
logoTag.Text = "By @Pall"
logoTag.Visible = false
logoTag.Parent = screenGui

--========================= STATE =========================--
local sliderDragging = false
local isMinimized = false
local isHidden = false

--========================= SLIDER =========================--
local function getThumbPercent()
    return (FLY_SPEED - SPEED_MIN) / (SPEED_MAX - SPEED_MIN)
end

local function applySliderPercent(pct)
    pct = math.clamp(pct, 0, 1)
    FLY_SPEED = math.floor(SPEED_MIN + pct * (SPEED_MAX - SPEED_MIN) + 0.5)
    speedNumLbl.Text = tostring(FLY_SPEED)

    local trackW = sliderTrack.AbsoluteSize.X
    local thumbX = pct * trackW
    sliderThumb.Position = UDim2.new(0, thumbX, 0.5, 0)
    sliderFill.Size = UDim2.new(0, thumbX, 1, 0)
end

task.defer(function()
    applySliderPercent(getThumbPercent())
end)

local function onSliderInput(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end

sliderTrack.InputBegan:Connect(onSliderInput)
sliderThumb.InputBegan:Connect(onSliderInput)

UserInputService.InputChanged:Connect(function(input)
    if not sliderDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and
       input.UserInputType ~= Enum.UserInputType.Touch then return end

    local trackPos = sliderTrack.AbsolutePosition.X
    local trackW   = sliderTrack.AbsoluteSize.X
    local mouseX   = input.Position.X
    local pct      = (mouseX - trackPos) / trackW
    applySliderPercent(pct)
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

--========================= DRAG PANEL =========================--
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = input.Position
        startPos  = panel.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                     input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--========================= LOGO DRAG =========================--
local logoDragging, logoDragStart, logoStartPos
logoBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        logoDragging  = true
        logoDragStart = input.Position
        logoStartPos  = logoBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if logoDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                         input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - logoDragStart
        logoBtn.Position = UDim2.new(
            logoStartPos.X.Scale, logoStartPos.X.Offset + delta.X,
            logoStartPos.Y.Scale, logoStartPos.Y.Offset + delta.Y
        )
        logoTag.Position = UDim2.new(
            0, logoBtn.AbsolutePosition.X + logoBtn.AbsoluteSize.X/2 - 40,
            0, logoBtn.AbsolutePosition.Y + logoBtn.AbsoluteSize.Y + 4
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        logoDragging = false
    end
end)

--========================= MINIMIZE / HIDE =========================--
local function setPanelVisible(v)
    panel.Visible = v
end

local function minimize()
    if isHidden then return end
    isMinimized = true
    panel.Visible = false
    logoBtn.Visible = true
    logoTag.Visible = true
end

local function restoreFromMinimize()
    isMinimized = false
    panel.Visible = true
    logoBtn.Visible = false
    logoTag.Visible = false
end

local function hidePanel()
    isHidden = true
    panel.Visible = false
    logoBtn.Visible = false
    logoTag.Visible = false
end

local function unhidePanel()
    isHidden = false
    if isMinimized then
        logoBtn.Visible = true
        logoTag.Visible = true
    else
        panel.Visible = true
    end
end

local function toggleMinimize()
    if isHidden then return end
    if isMinimized then restoreFromMinimize() else minimize() end
end

local function toggleHide()
    if isHidden then unhidePanel() else hidePanel() end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
hideBtn.MouseButton1Click:Connect(toggleHide)

-- Klik logo = restore panel
logoBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        restoreFromMinimize()
    end
end)

-- Hover efek tombol
local function addHover(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = hoverColor }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = normalColor }):Play()
    end)
end

addHover(minimizeBtn, Color3.fromRGB(235, 235, 245), Color3.fromRGB(215, 215, 235))
addHover(hideBtn, Color3.fromRGB(255, 225, 225), Color3.fromRGB(255, 190, 190))
addHover(logoBtn, Color3.fromRGB(130, 130, 255), Color3.fromRGB(100, 100, 230))

--========================= UI FLYING STATE =========================--
local function setUIFlying(state)
    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad)
    if state then
        TweenService:Create(toggleBtn, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(130, 130, 255),
            TextColor3       = Color3.fromRGB(255, 255, 255),
        }):Play()
        toggleBtn.Text = "■  Disable Fly  [C]"
        TweenService:Create(statusDot, tweenInfo, { BackgroundColor3 = Color3.fromRGB(100, 220, 130) }):Play()
        statusLabel.Text = "Flying  |  By @Pall"
        statusLabel.TextColor3 = Color3.fromRGB(80, 180, 110)
        dot.BackgroundColor3 = Color3.fromRGB(100, 220, 130)
        logoBtn.BackgroundColor3 = Color3.fromRGB(100, 220, 130)
    else
        TweenService:Create(toggleBtn, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(245, 245, 250),
            TextColor3       = Color3.fromRGB(60, 60, 80),
        }):Play()
        toggleBtn.Text = "▶  Enable Fly  [C]"
        TweenService:Create(statusDot, tweenInfo, { BackgroundColor3 = Color3.fromRGB(200, 200, 210) }):Play()
        statusLabel.Text = "Idle  |  By @Pall"
        statusLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
        dot.BackgroundColor3 = Color3.fromRGB(130, 130, 255)
        logoBtn.BackgroundColor3 = Color3.fromRGB(130, 130, 255)
    end
end

--========================= FLY LOGIC =========================--
local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getRootPart()
    return getCharacter():WaitForChild("HumanoidRootPart")
end

local function enableFly()
    local root = getRootPart()
    if root:FindFirstChild("FlyVelocity") then root.FlyVelocity:Destroy() end
    if root:FindFirstChild("FlyGyro")     then root.FlyGyro:Destroy()     end

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Name     = "FlyVelocity"
    bodyVel.Velocity = Vector3.zero
    bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVel.Parent   = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name      = "FlyGyro"
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.D         = 50
    bodyGyro.CFrame    = root.CFrame
    bodyGyro.Parent    = root

    local hum = getCharacter():FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end

    flying = true
    setUIFlying(true)
end

local function disableFly()
    if bodyVel  then bodyVel:Destroy();  bodyVel  = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end

    local hum = getCharacter():FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end

    flying = false
    setUIFlying(false)
end

local function getInputDirection()
    local dir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up)    then dir += Vector3.new( 0,0,-1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down)  then dir += Vector3.new( 0,0, 1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left)  then dir += Vector3.new(-1,0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then dir += Vector3.new( 1,0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space)                                               then dir += Vector3.new( 0,1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or
       UserInputService:IsKeyDown(Enum.KeyCode.RightControl)                                        then dir += Vector3.new( 0,-1,0) end
    return dir
end

RunService.Heartbeat:Connect(function()
    if not flying or not bodyVel or not bodyGyro then return end

    local root     = getRootPart()
    local camCF    = camera.CFrame
    local inputDir = getInputDirection()

    local isSprinting = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or
                        UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
    local speed = isSprinting and FLY_SPEED * SPRINT_MULT or FLY_SPEED

    if inputDir.Magnitude > 0 then
        local worldDir = camCF:VectorToWorldSpace(inputDir).Unit
        bodyVel.Velocity = worldDir * speed
        local lookAt = Vector3.new(worldDir.X, 0, worldDir.Z)
        if lookAt.Magnitude > 0.01 then
            bodyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + lookAt)
        end
    else
        bodyVel.Velocity = bodyVel.Velocity * 0.85
    end
end)

local function onToggle()
    if flying then disableFly() else enableFly() end
end

toggleBtn.MouseButton1Click:Connect(onToggle)

toggleBtn.MouseEnter:Connect(function()
    if not flying then
        TweenService:Create(toggleBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(235, 235, 245) }):Play()
    end
end)
toggleBtn.MouseLeave:Connect(function()
    if not flying then
        TweenService:Create(toggleBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(245, 245, 250) }):Play()
    end
end)

--========================= KEYBINDS =========================--
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == TOGGLE_KEY then
        onToggle()
    elseif input.KeyCode == MINIMIZE_KEY then
        toggleMinimize()
    elseif input.KeyCode == HIDE_KEY then
        toggleHide()
    end
end)

--========================= CHARACTER RESPAWN =========================--
player.CharacterAdded:Connect(function()
    flying   = false
    bodyVel  = nil
    bodyGyro = nil
    setUIFlying(false)
    task.defer(function() applySliderPercent(getThumbPercent()) end)
end)
