Menu = {}

function Menu:init()
    -- Edit:init()
    -- Level:init("1")
end

function Menu:update(dt)

end

function Menu:draw()
    love.graphics.draw(Image.bg)

    Shadow:start()



    Shadow:stop()
end

return Menu