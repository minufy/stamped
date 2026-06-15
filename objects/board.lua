local Board = Object:extend()
SetType(Board, "board")

local Mino = require("objects.mino")

NewImage("board")
NewImage("board_back")
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
end

function Board:draw()
    love.graphics.draw(Image.board_back, self.x-corner_offest_x, self.y-corner_offest_y)
    for y = 1, BUFFER_H+BOARD_H do
        for x = 1, BOARD_W do
            local cell = self.grid[y][x]
            if cell ~= "" then
                love.graphics.draw(Image[cell], self.x+(x-1)*TILE_SIZE, self.y+(y-1)*TILE_SIZE)
            end
        end
    end
    self.current:draw(self.x, self.y)
    love.graphics.draw(Image.board, self.x-corner_offest_x, self.y-corner_offest_y)
end

return Board