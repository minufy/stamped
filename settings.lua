Input.left = NewInput({"left"})
Input.right = NewInput({"right"})
Input.cw = NewInput({"up"})
Input.ccw = NewInput({"lctrl"})
Input.flip = NewInput({"a"})
Input.hold = NewInput({"lshift"})
Input.hard_drop = NewInput({"space"})
Input.soft_drop = NewInput({"down"})

Config = {
    arr = 0,
    das = 117,
    sdarr = 0,
}

-- Audio:add("jump")

NewImage("bg")

Camera.x_damp = 0.2
Camera.y_damp = 0.2
Camera.shake_damp = 0.2

TILE_TYPES = {
    "tile",
}
OBJECT_TYPES = {
    "player",
    "zone",
}
IMG_TYPES = {
    "test",
}

TILE_SIZE = 20
GRID_SIZE = TILE_SIZE/2

local object_align = {
    player = Align.Bottom,
}
OBJECT_ALIGN = setmetatable(object_align, {
    __index = function (t, k)
        return Align.None
    end
})