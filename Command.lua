-- Command.lua
-- Точка входа для инжектора. Загружает ChatCmdLib и регистрирует /fly.

-- 1. Загружаем библиотеку команд
local cmd = loadstring(game:HttpGet("https://raw.githubusercontent.com/reprenzy-hue/ChatCmdLib-Docs/refs/heads/main/source.lua"))()

-- 2. Регистрируем команду
cmd.AddChatCommand({
    Name = "fly",
    Desc = "Запускает меню полёта (Fly GUI)",
    Func = function()
        -- Предотвращаем повторную загрузку скрипта
        if _G._FlyRakNetLoaded then
            print("[Fly] Скрипт уже запущен.")
            return
        end
        _G._FlyRakNetLoaded = true

        -- Загружаем наш LocalScript
        -- ВАЖНО: Замени <ты> на свой GitHub username
        loadstring(game:HttpGet("https://raw.githubusercontent.com/<ты>/fly-raknet/main/LocalScript.lua"))()
        print("[Fly] Меню загружено. Напиши /fly снова для переключения.")
    end
})
