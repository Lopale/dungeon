local dungeon = {}  -- On créer le module, le nom du modul n'a pas à être le même que celui du fichier mais cela est plus facile

local map = {}      -- Carte du niveau vide

dungeon.width = 0   -- On initialise la largeur du donjon à 0, pas de local pour pouvoir y acceder depuis l'exterieur
dungeon.height = 0  -- On initialise la hauteur du donjon à 0
dungeon.caseSize = 9  -- taille des cases en 2D en px -- pas en local pour que l'editeur de map y ai accès

-- Chaque direction du personnage correspond à un chiffre
dungeon.nord = 1
dungeon.est = 2
dungeon.sud = 3
dungeon.ouest = 4

-- position du joueur
dungeon.playerX = 0
dungeon.playerY = 0
dungeon.playerDirection = 0

-- Charger les images
local imgNord = love.graphics.newImage("img/nord.png")
local imgEst = love.graphics.newImage("img/est.png")
local imgSud = love.graphics.newImage("img/sud.png")
local imgOuest = love.graphics.newImage("img/ouest.png")

function dungeon.changePositionPlayer(x,y, direction)
    dungeon.playerX = x
    dungeon.playerY = y
    dungeon.playerDirection = direction
end

function dungeon.nextLevel()
    print("FINISH")
end


function dungeon.load()
    print("dungeon.load()")

    -- 1 Mur
    -- 0 Couloir
    -- 2 Start
    -- 3 Finish
    map = {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,2,1,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1},
        {1,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,1},
        {1,0,1,0,1,1,1,1,1,0,1,0,1,1,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1},
        {1,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,1},
        {1,0,1,1,1,1,1,0,1,1,1,0,1,1,1,1,1,1,1,0,1,0,1,1,1,0,1,1,1,0,1},
        {1,0,1,0,0,0,1,0,1,0,1,0,1,0,0,0,0,0,1,0,1,0,1,0,0,0,1,0,0,0,1},
        {1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1,0,1,1,1,0,1,1,1},
        {1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,1,0,1,0,0,0,0,0,1},
        {1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,0,1,0,1,1,1,0,1},
        {1,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,1,0,1,0,0,0,1},
        {1,0,1,1,1,0,1,0,1,0,1,0,1,1,1,1,1,0,1,0,1,1,1,0,1,0,1,0,1,1,1},
        {1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,1,0,1,0,1,0,0,0,1},
        {1,1,1,1,1,1,1,0,1,0,1,1,1,0,1,0,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1},
        {1,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1},
        {1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1},
        {1,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,1},
        {1,0,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,0,1,1,1,1,1,0,1},
        {1,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1},
        {1,0,1,1,1,0,1,1,1,0,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1},
        {1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1},
        {1,0,1,0,1,1,1,1,1,0,1,1,1,0,1,0,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1},
        {1,0,1,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,1},
        {1,0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,0,1,0,1,1,1,0,1,1,1},
        {1,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1},
        {1,0,1,1,1,0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1},
        {1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1},
        {1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    }

    dungeon.width = #map[1] -- La première ligne de la map donne le nombre de colonne, # veux dire qu'on récupère le nombre d'éléments d'un tableau et de cette ligne
    dungeon.height = #map -- # veux dire qu'on récupère le nombre d'éléments d'un tableau, ici la map

    print("Le donjon fait ".. dungeon.width .. " par " .. dungeon.height)
end

-- test ce que contient la case sur laquelle on envoie les coordonnées
function dungeon.case(ligne, colonne)
    return map[ligne][colonne]
end

function draw2D() -- fonction de dessin en 2D
    -- love.graphics.print("Scene du donjon 2D", 120,190) -- Ecrit à 120 px en x et 150px en Y

    -- Boucle imbriqué pour parcourir le tableau
    for ligne = 1, dungeon.height do
        for colonne = 1, dungeon.width do
            local case = map[ligne][colonne]
            local x = (colonne-1)* dungeon.caseSize -- position en X de la case, colonne-1 pour commencer à 0
            local y = (ligne-1)* dungeon.caseSize
            if case == 1 then
                love.graphics.setColor(0.8,0.8,0.8) -- Colorier en gris si c'est 1 (un mur) 
            elseif case == 0 then
                love.graphics.setColor(1,1,1) -- Colorier en blanc si c'est 0 (un couloir)
            elseif case == 2 then
                love.graphics.setColor(0.8,0,0) -- Colorier en rouge si c'est 2 (le début)
            elseif case == 3 then
                love.graphics.setColor(0,0.8,0) -- Colorier en vert si c'est 3 (le finish)
            end
            love.graphics.rectangle("fill",x,y,dungeon.caseSize,dungeon.caseSize) -- on colorie chaque case de la bonne couleur à la bonne coordonnées

            -- Empalcement du joueur
            if ligne == dungeon.playerY and colonne == dungeon.playerX then
                -- love.graphics.setColor(0,0,0.8)
                if dungeon.playerDirection == dungeon.nord then
                    love.graphics.draw(imgNord, x , y)
                elseif dungeon.playerDirection == dungeon.est then
                    love.graphics.draw(imgEst, x , y)
                elseif dungeon.playerDirection == dungeon.sud then
                    love.graphics.draw(imgSud, x , y)
                elseif dungeon.playerDirection == dungeon.ouest then
                    love.graphics.draw(imgOuest, x , y)
                end
            end
        end
    end

end
    
function draw3D() -- fonction de dessin en 3D
    -- love.graphics.print("Scene du donjon 3D", 120,190) -- Ecrit à 120 px en x et 150px en Y
end
    

function dungeon.draw(dt, mode) -- Pour passer de 2D a 3D
    if mode == "3D" then
        draw3D()
    else
        draw2D()
    end

end


return dungeon -- OBLGATOIRE !!!, renvois le module et son contenu