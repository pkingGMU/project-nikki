WorldState = {
    Level1 = {
        default = {
          objects = {
            -- Test Item --
            { class = 'Item', type = 'Item', level = 'Level1',  x = 352, y = 288-32, w = 32, h = 32, can_collide = false, tag = 'item',  soft_reset = false}
            }
        },
        current = {
            objects = {
                
            }
        }
    },
    Level2 = {
        default = {
            objects = {
            }
        },
        current = {
            objects = {}
        }
    }
}

return WorldState
