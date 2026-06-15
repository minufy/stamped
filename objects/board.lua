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
    self.hold = "o"
    self.next = Bag
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
        self:draw_mino(hold_x+hold_offset_x+gap, hold_y+hold_offset_y+gap, self.hold)
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
    self.current:draw(self.x, self.y)
    love.graphics.draw(Image.board, bx, by)
end

return Board