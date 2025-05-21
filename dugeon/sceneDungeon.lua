local sceneDungeon = {} -- On créer le module, le nom du modul n'a pas à être le même que celui du fichier mais cela est plus facile

local dungeon = require("dungeon") -- On charge le module dungeon (Pas besoin d'indiquer l'extension)



function sceneDungeon.load()
    print("sceneDungeon.load()")
    dungeon.load()
    dungeon.changePositionPlayer(2,2,dungeon.sud)
end


function sceneDungeon.update(dt)
end


function sceneDungeon.draw()
    -- love.graphics.print("Scene du donjon", 120,150) -- Ecrit à 120 px en x et 150px en Y
    dungeon.draw("3D")
end

function sceneDungeon.keypressed(key)
    -- print("sceneDungeon.keypressed(key), key = ",key)

    local direction = dungeon.playerDirection
    local x = dungeon.playerX
    local y = dungeon.playerY

    if key == "right" then
        direction = direction + 1
        if direction > 4 then
            direction = 1
        end
    end
    if key == "left" then
        direction = direction - 1
        if direction == 0 then
            direction = 4
        end
    end

    if key == "up" then
        -- coordonnées avant déplacement
        local oldX = x
        local oldY = y
        if direction == dungeon.nord then
            y = y -1
        end
        if direction == dungeon.est then
            x = x +1
        end
        if direction == dungeon.sud then
            y = y + 1
        end
        if direction == dungeon.ouest then
            x = x -1
        end

       print(direction)
        -- On vérifie que l'on ne rentre pas dans un mur
        if dungeon.case(y,x) == 1 then
            x = oldX
            y = oldY
        end
        if dungeon.case(y,x) == 3 then
            dungeon.nextLevel()
        end
    end
    if key == "down" then
        print("j'affiche la mini map")
    end

    dungeon.changePositionPlayer(x,y,direction)

    if modeDev == true then
        if(key)== "r" then -- r pour reveal
            dungeon.liftFog("all") -- on retire tout le brouillard
        end
    end
end

function sceneDungeon.mousepressed(x, y, button, istouch)
    print("sceneDungeon.mousepressed(x, y, button, istouch)",x,y,button,istouch)
end


return sceneDungeon -- OBLGATOIRE !!!, renvois le module et son contenu