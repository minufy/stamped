local Board = Object:extend()
SetType(Board, "board")

local Mino = require("objects.mino")

NewImage("board")
NewImage("board_back")
NewImage("hold")
NewImage("next")
NewImage("g")
NewImage("i")
NewImage("j")
NewImage("l")
NewImage("o")
NewImage("s")
NewImage("t")
NewImage("z")

BOARD_W = 10
BOARD_H = 20
BUFFER_H = 20
local corner_offest_x = 18
local corner_offest_y = 78
local gap = 20
local hold_offset_x = 24
local hold_offset_y = 49
local next_offset_x = 24
local next_offset_y = 49
local mino_draw_offset = {
    i = {0, -0.5},
    j = {0.5, 0},
    l = {0.5, 0},
    o = {0, 0},
    s = {0.5, 0},
    t = {0.5, 0},
    z = {0.5, 0},
}

function Board:new()
    self.grid = {}
    self.x = Res.w/2-BOARD_W*TILE_SIZE/2+corner_offest_x/2
    self.y = Res.h/2-BOARD_H*TILE_SIZE/2+corner_offest_y/2
    for _ = 1, BUFFER_H+BOARD_H do
        local row = {}
        for _ = 1, BOARD_W do
            table.insert(row, "")
        end
        table.insert(self.grid, row)
    end
    self.current = Mino("i")
    self.hold = nil
    self.hold_used = false
    self.next = Bag
    self.arr = 0
    self.das = 0
    self.sdarr = 0
    self.ix = 0
end

function Board:update(dt)
    local time = love.timer.getTime()*1000

    if Input.right.pressed then
        self.ix = 1
        self.current:move(1, 0, self)
        self.das = time+Config.das
    elseif Input.right.released then
        if Input.left.down then
            self.ix = -1
        else
            self.ix = 0
        end
    end
    if Input.left.pressed then
        self.ix = -1
        self.current:move(-1, 0, self)
        self.das = time+Config.das
    elseif Input.left.released then
        if Input.right.down then
            self.ix = 1
        else
            self.ix = 0
        end
    end
    if Input.soft_drop.pressed then
        self.sdarr = time+Config.sdarr
    end

    if time >= self.das then
        if self.ix ~= 0 then
            for _ = 1, BOARD_W do
                if time >= self.arr then
                    self.arr = self.arr+Config.arr
                else
                    break
                end
                self.current:move(self.ix, 0, self)
            end
        end
    end
    if Input.soft_drop.down then
        for _ = 1, BOARD_H+BUFFER_H do
            if time >= self.sdarr then
                self.sdarr = self.sdarr+Config.sdarr
            else
                break
            end
            self.current:move(0, 1, self)
        end
    end

    if Input.cw.pressed then
        self.current:rotate(1, self)
    end
    if Input.ccw.pressed then
        self.current:rotate(-1, self)
    end

    if Input.hard_drop.pressed then
        for _ = 1, BOARD_H+BUFFER_H do
            self.current:move(0, 1, self)
        end
        self.current:lock(self)
    end
end

function Board:draw_mino(x, y ,mino_type)
    local sx, sy = unpack(mino_draw_offset[mino_type])
    Mino.draw_mino(x, y, mino_type, 0, sx, sy)
end

function Board:draw()
    local bx, by = self.x-corner_offest_x, self.y-corner_offest_y

    love.graphics.draw(Image.board_back, bx, by)
    
    local hold_x = self.x-corner_offest_x-gap-Image.hold:getWidth()
    local hold_y = self.y-corner_offest_y
    love.graphics.draw(Image.hold, hold_x, hold_y)
    if self.hold ~= nil then
        if self.hold_used then
            love.graphics.setColor(1, 1, 1, 0.5)
        end
        self:draw_mino(hold_x+hold_offset_x+gap, hold_y+hold_offset_y+gap, self.hold)
        Color.reset()
    end
    
    local next_x = self.x+corner_offest_x+BOARD_W*TILE_SIZE+gap
    local next_y = self.y-corner_offest_y
    love.graphics.draw(Image.next, next_x, next_y)
    for i = 1, 5 do
        self:draw_mino(next_x+next_offset_x+gap, next_y+next_offset_y+gap+(i-1)*TILE_SIZE*3, self.next[i])
    end

    for y = 1, BUFFER_H+BOARD_H do
        for x = 1, BOARD_W do
            local cell = self.grid[y][x]
            if cell ~= "" then
                love.graphics.draw(Image[cell], self.x+(x-1)*TILE_SIZE, self.y+(y-1)*TILE_SIZE)
            end
        end
    end
    -- love.graphics.setScissor(self.x-corner_offest_x, self.y-corner_offest_y, BOARD_W*gap+corner_offest_x*2, BOARD_H*gap+corner_offest_y*2)
    self.current:draw(self.x, self.y)
    -- love.graphics.draw(Image.board, bx, by)
    -- love.graphics.setScissor()
end

return Board