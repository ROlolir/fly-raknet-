-- UI.lua
-- Создаёт ScreenGui с кнопкой Toggle Fly и полем ввода скорости.
-- Возвращает таблицу с ссылками на элементы и колбэками.

local UI = {}

function UI.create(parent)
    parent = parent or game:GetService("CoreGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "FlyRakNetUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 110)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 28)
    title.BackgroundTransparency = 1
    title.Text = "Fly (RakNet)"
    title.TextColor3 = Color3.fromRGB(230, 230, 230)
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 15
    title.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 90, 0, 30)
    toggle.Position = UDim2.new(0, 15, 0, 40)
    toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(230, 230, 230)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.BorderSizePixel = 0
    toggle.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 90, 0, 30)
    speedBox.Position = UDim2.new(0, 115, 0, 40)
    speedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    speedBox.Text = "50"
    speedBox.TextColor3 = Color3.fromRGB(230, 230, 230)
    speedBox.Font = Enum.Font.Gotham
    speedBox.TextSize = 14
    speedBox.BorderSizePixel = 0
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = frame

    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 6)
    speedCorner.Parent = speedBox

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -30, 0, 20)
    hint.Position = UDim2.new(0, 15, 0, 78)
    hint.BackgroundTransparency = 1
    hint.Text = "WASD + Space/Shift | Speed"
    hint.TextColor3 = Color3.fromRGB(150, 150, 160)
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 11
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.Parent = frame

    return {
        gui = gui,
        frame = frame,
        toggle = toggle,
        speedBox = speedBox,
        setToggleState = function(state)
            toggle.Text = state and "ON" or "OFF"
            toggle.BackgroundColor3 = state
                and Color3.fromRGB(60, 130, 80)
                or Color3.fromRGB(45, 45, 55)
        end,
    }
end

return UI
