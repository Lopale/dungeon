local sceneEditor = {} -- On créer le module, le nom du modul n'a pas à être le même que celui du fichier mais cela est plus facile

local dungeon = require("dungeon") -- On charge le module dungeon (Pas besoin d'indiquer l'extension)

function sceneEditor.load()
    print("sceneEditor.load()")
end


function sceneEditor.update(dt)
end


function sceneEditor.draw()
    dungeon.draw(dt,"2D")
    love.graphics.setColor(0,0,0)
    love.graphics.print("Editeur de map", 285,0) -- Ecrit à 120 px en x et 150px en Y
    love.graphics.print("Touche 1 = Mur", 285,15) -- Ecrit à 120 px en x et 150px en Y
    love.graphics.print("Touche 2 = Entrée", 285,30) -- Ecrit à 120 px en x et 150px en Y
    love.graphics.print("Touche 3 = Sortie", 285,45) -- Ecrit à 120 px en x et 150px en Y
    love.graphics.print("Clic droit = couloir / vide", 285,60) -- Ecrit à 120 px en x et 150px en Y
end

function sceneEditor.keypressed(key)
     if modeDev == true then
        if(key)== "r" then -- r pour reveal
            dungeon.liftFog("all") -- on retire tout le brouillard
        end
    end


    love.graphics.setColor(1,0,0)
    if(key)== "1" then 
        dungeon.valeurEditeur(key) -- on retire tout le brouillard
        love.graphics.print("Créer un mur", 285,75) -- Ecrit à 120 px en x et 150px en Y    
        print("Créer un mur")
    end

    print("sceneEditor.keypressed(key), key = ",key)
end

function sceneEditor.mousepressed(x, y, button, istouch)
    print("sceneEditor.mousepressed(x, y, button, istouch)",x,y,button,istouch)

    -- Création de l'éditeur de map
    -- Ajouter sécurité sur les bord, ne pas mettre 0

    x = x/2 -- Divisé par deux car on scale X2
    y = y/2

    -- Version Gamecodeur
    if button == 1 then -- le 1 est pour clic gauche 
        local ligne = math.floor(y / dungeon.caseSize) +1 -- position en pixel en y divisé par la taille des case pour avoir la position dans le tableau, plus un pour ne pas commencer à 0, math.floor retire les chiffres après la virgules
        local colonne = math.floor(x / dungeon.caseSize) +1

        if dungeon.case(ligne,colonne) == 1 then -- du coup on inverse les 1 et 0
            dungeon.changeCase(ligne,colonne,0)
        else
            dungeon.changeCase(ligne,colonne,1)            
        end
    end



    -- Version moi
    local ligne = math.floor(y / dungeon.caseSize) +1 -- position en pixel en y divisé par la taille des case pour avoir la position dans le tableau, plus un pour ne pas commencer à 0, math.floor retire les chiffres après la virgules
    local colonne = math.floor(x / dungeon.caseSize) +1
    if button == 2 then -- Si c'est un clic droit on détruit
        dungeon.changeCase(ligne,colonne,0)
    end
    
end


return sceneEditor -- OBLGATOIRE !!!, renvois le module et son contenu