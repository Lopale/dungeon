local sceneDungeon = {} -- On créer le module, le nom du modul n'a pas à être le même que celui du fichier mais cela est plus facile

local dungeon = require("dungeon") -- On charge le module dungeon (Pas besoin d'indiquer l'extension)

function sceneDungeon.load()
    print("sceneDungeon.load()")
end


function sceneDungeon.update(dt)
end


function sceneDungeon.draw()
    love.graphics.print("Scene du donjon", 120,150) -- Ecrit à 120 px en x et 150px en Y
    dungeon.draw(dt,"3D")
end

function sceneDungeon.keypressed(key)
    print("sceneDungeon.keypressed(key), key = ",key)
end

function sceneDungeon.mousepressed(x, y, button, istouch)
    print("sceneDungeon.mousepressed(x, y, button, istouch)",x,y,button,istouch)
end


return sceneDungeon -- OBLGATOIRE !!!, renvois le module et son contenu