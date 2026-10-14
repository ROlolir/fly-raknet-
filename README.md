# fly-raknet-
# fly-raknet

Каркас клиентского полёта с интерфейсом под RakNet-хуки инжектора.

## Что работает
- GUI (Toggle Fly + поле скорости) в CoreGui/PlayerGui
- Локальное плавное перемещение (WASD + Space/Shift)
- Интерфейс `RakNetModule` под RakNet-API инжектора

## Что НЕ работает и почему
Сетевая репликация позиции другим игрокам через RakNet невозможна
на клиенте при включённом Replication Filtering. Подробности —
в комментариях `RakNetModule.lua`.

## Файлы
- `UI.lua` — создание интерфейса
- `LocalScript.lua` — ввод и локальное движение
- `RakNetModule.lua` — интерфейс под RakNet-хуки (заглушка)
