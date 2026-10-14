-- LocalScript.lua
-- Ввод, тоггл, плавное локальное перемещение персонажа.
-- RakNet-слой подключается опционально и НЕ является источником движения.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/<ты>/fly-raknet/main/UI.lua"))()
local RakNetModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/<ты>/fly-raknet/main/RakNetModule.lua"))()

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

local ui = UI.create()
local state = {
    enabled = false,
    speed = 50,
    keys = {},
}

-- Пытаемся поднять RakNet-слой. Если инжектор не поддерживает —
-- модуль вернёт false, и мы просто работаем локально.
local raknetReady = RakNetModule.init({
    onError = function(msg)
        warn("[Fly] RakNet: " .. tostring(msg))
    end,
})

ui.toggle.MouseButton1Click:Connect(function()
    state.enabled = not state.enabled
    ui.setToggleState(state.enabled)
    RakNetModule.setActive(state.enabled)
end)

ui.speedBox.FocusLost:Connect(function()
    local n = tonumber(ui.speedBox.Text)
    if n and n > 0 and n <= 500 then
        state.speed = n
    else
        ui.speedBox.Text = tostring(state.speed)
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    state.keys[input.KeyCode] = true
end)

UserInputService.InputEnded:Connect(function(input)
    state.keys[input.KeyCode] = false
end)

local function getMoveVector()
    local move = Vector3.zero
    local camCF = camera.CFrame

    if state.keys[Enum.KeyCode.W] then move += camCF.LookVector end
    if state.keys[Enum.KeyCode.S] then move -= camCF.LookVector end
    if state.keys[Enum.KeyCode.A] then move -= camCF.RightVector end
    if state.keys[Enum.KeyCode.D] then move += camCF.RightVector end
    if state.keys[Enum.KeyCode.Space] then move += Vector3.yAxis end
    if state.keys[Enum.KeyCode.LeftShift] then move -= Vector3.yAxis end

    if move.Magnitude > 0 then
        move = move.Unit
    end
    return move
end

RunService.RenderStepped:Connect(function(dt)
    if not state.enabled then return end
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    hum.PlatformStand = true

    local move = getMoveVector()
    local delta = move * state.speed * dt
    hrp.CFrame = hrp.CFrame + delta

    -- Отдаём новую позицию в RakNet-слой (если он поднят).
    -- Модуль сам решает, что с ней делать.
    if raknetReady then
        RakNetModule.pushPosition(hrp.CFrame)
    end
end)
