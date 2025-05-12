local sceneEditor = {} -- On créer le module, le nom du modul n'a pas à être le même que celui du fichier mais cela est plus facile

local dungeon = require("dungeon") -- On charge le module dungeon (Pas besoin d'indiquer l'extension)

function sceneEditor.load()
    print("sceneEditor.load()")
end


function sceneEditor.update(dt)
end


function sceneEditor.draw()
    love.graphics.print("Scene de l'editeur de map", 120,150) -- Ecrit à 120 px en x et 150px en Y
    dungeon.draw(dt,"2D")
end

function sceneEditor.keypressed(key)
    print("sceneEditor.keypressed(key), key = ",key)
end

function sceneEditor.mousepressed(x, y, button, istouch)
    print("sceneEditor.mousepressed(x, y, button, istouch)",x,y,button,istouch)
end


return sceneEditor -- OBLGATOIRE !!!, renvois le module et son contenu