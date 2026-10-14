-- RakNetModule.lua
--
-- Слой сетевой синхронизации позиции через RakNet-хуки инжектора.
--
-- ВАЖНО, ЧЕСТНО И БЕЗ ЗАГАДОК:
--
-- 1. Клиент при включённом Replication Filtering НЕ может реплицировать
--    свою позицию другим игрокам. Изменения DataModel на клиенте
--    не рассылаются. Только сервер рассылает.
--
-- 2. Функции вида `raknet.add_send_hook` / `rnet.sendphysics` дают
--    доступ к ОТПРАВКЕ пакета. Они НЕ дают доступа к тому, чтобы
--    сервер принял пакет. Серверная валидация движения сравнивает
--    присланный CFrame со своей симуляцией и отбрасывает расхождения.
--
-- 3. Современные античиты (VANITY, Harmony и др.) имеют отдельные
--    модули Flight/Teleport detection с порогами по вертикальной
--    скорости и дистанции телепорта. Пакетный уровень — не обход
--    этих модулей, а ещё один сигнал для них.
--
-- Поэтому здесь — ИНТЕРФЕЙС под RakNet-хуки, а не реализация обхода.
-- Подставь свою логику в `pushPosition`, если хочешь экспериментировать
-- на своём сервере. На публичных серверах это либо не сработает,
-- либо приведёт к бану.

local RakNetModule = {}

local state = {
    active = false,
    ready = false,
    executor = nil,
    onError = function() end,
}

-- Пытаемся найти RakNet-API в текущем инжекторе.
-- Ожидаемые имена — из публичных доков инжекторов с RakNet-поддержкой.
local function resolveExecutor()
    local candidates = {
        rawget(getfenv(), "raknet"),
        rawget(getfenv(), "rnet"),
        rawget(getfenv(), "RakNet"),
    }
    for _, c in ipairs(candidates) do
        if type(c) == "table" or type(c) == "userdata" then
            return c
        end
    end
    return nil
end

function RakNetModule.init(opts)
    opts = opts or {}
    if opts.onError then state.onError = opts.onError end

    local exec = resolveExecutor()
    if not exec then
        state.onError("RakNet API не найден в окружении инжектора")
        state.ready = false
        return false
    end

    state.executor = exec
    state.ready = true

    -- Здесь в теории можно было бы поставить hook на исходящие пакеты
    -- движения, если бы это решало задачу репликации. Оно не решает.
    --
    -- Пример интерфейса, который может существовать в инжекторе:
    --
    --   exec.add_send_hook(function(packet_id, data)
    --       -- можно перехватить и модифицировать исходящий пакет
    --   end)
    --
    -- Но модификация исходящего пакета не обходит серверную валидацию.

    return true
end

function RakNetModule.setActive(active)
    state.active = active and state.ready or false
end

-- Вызывается из LocalScript каждый кадр с новой CFrame.
-- Сюда ты можешь вписать свою логику отправки, если хочешь
-- экспериментировать на собственном сервере.
function RakNetModule.pushPosition(cframe)
    if not state.active then return end

    -- ЗАГЛУШКА. Реальной отправки нет.
    --
    -- Если бы мы хотели отправить физический пакет, код мог бы
    -- выглядеть примерно так (синтаксис зависит от инжектора):
    --
    --   state.executor.sendphysics(cframe)
    --
    -- Но: сервер сверит это со своей симуляцией и отбросит.
    -- См. шапку файла.
end

function RakNetModule.isReady()
    return state.ready
end

return RakNetModule
