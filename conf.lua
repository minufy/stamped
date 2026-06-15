WINDOW_W = 1200
WINDOW_H = 800
CONSOLE = true

function love.conf(t)
    t.window.resizable = true
    t.console = CONSOLE
    t.window.width = WINDOW_W
    t.window.height = WINDOW_H
    t.window.vsync = 0
end