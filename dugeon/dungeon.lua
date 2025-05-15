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

local CDV = {} -- Champs de vision du joueur pour la 3D, sur trois cases par trois


function dungeon.changePositionPlayer(x,y, direction)
    dungeon.playerX = x
    dungeon.playerY = y
    dungeon.playerDirection = direction

    calculCDV() -- On recalcul le champs de vision à chaque déplacement
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

-- Vérifie les données du champs de vision pour ne pas sortir du tableau (v pour vision)
function changeCDV(vLigne, vColonne, mapLigne, mapColonne)
    if mapLigne > 0 and mapColonne > 0 and mapColonne <= dungeon.height and mapColonne <= dungeon.width then
        CDV[vLigne][vColonne]= map[mapLigne][mapColonne]
    end
end



-- Calcul du champs de vision
function calculCDV()
    CDV = {} -- on reset le champs de vision
    for ligne=1,3 do
        CDV[ligne] = {0,0,0}    -- On initialise les 3 ligne par des 0 
                                -- donc CDV = {
                                --              {0,0,0},
                                --              {0,0,0},
                                --              {0,0,0},                
                                --             }
    end

    local x = dungeon.playerX -- On récupère la position du joueur
    local y = dungeon.playerY

    -- On calcul pour chacune des quatre direction en commençant par le nord
    -- NORD
    if dungeon.playerDirection == dungeon.nord then
        changeCDV(1,1,y,x-1)   -- Ligne 1 colonne 1
        changeCDV(1,2,y,x)     -- Ligne 1 colonne 2
        changeCDV(1,3,y,x+1)   -- Ligne 1 colonne 3

        changeCDV(2,1,y-1,x-1) -- Ligne 2 colonne 1
        changeCDV(2,2,y-1,x)   -- Ligne 2 colonne 2
        changeCDV(2,3,y-1,x+1) -- Ligne 2 colonne 3

        changeCDV(3,1,y-2,x-1) -- Ligne 3 colonne 1
        changeCDV(3,2,y-2,x)   -- Ligne 3 colonne 2
        changeCDV(3,3,y-2,x+1) -- Ligne 3 colonne 3


        -- Juste pour vérifier la table dans la console
        print('___')
        for ligne=1,3 do
            local printCDV = CDV[ligne][1]..CDV[ligne][2]..CDV[ligne][3]
            print(printCDV)
        end
        print('___')
    end


    -- EST
    if dungeon.playerDirection == dungeon.est then
        changeCDV(1,1,y-1,x)   -- Ligne 1 colonne 1
        changeCDV(1,2,y,x)     -- Ligne 1 colonne 2
        changeCDV(1,3,y+1,x)   -- Ligne 1 colonne 3

        changeCDV(2,1,y-1,x+1) -- Ligne 2 colonne 1
        changeCDV(2,2,y,x+1)   -- Ligne 2 colonne 2
        changeCDV(2,3,y+1,x+1) -- Ligne 2 colonne 3

        changeCDV(3,1,y-1,x+2) -- Ligne 3 colonne 1
        changeCDV(3,2,y,x+2)   -- Ligne 3 colonne 2
        changeCDV(3,3,y+1,x+2) -- Ligne 3 colonne 3


        -- Juste pour vérifier la table dans la console
        print('___')
        for ligne=1,3 do
            local printCDV = CDV[ligne][1]..CDV[ligne][2]..CDV[ligne][3]
            print(printCDV)
        end
        print('___')
    end

    -- SUD
    if dungeon.playerDirection == dungeon.sud then
        changeCDV(1,1,y,x+1)   -- Ligne 1 colonne 1
        changeCDV(1,2,y,x)     -- Ligne 1 colonne 2
        changeCDV(1,3,y,x-1)   -- Ligne 1 colonne 3

        changeCDV(2,1,y+1,x+1) -- Ligne 2 colonne 1
        changeCDV(2,2,y+1,x)   -- Ligne 2 colonne 2
        changeCDV(2,3,y+1,x-1) -- Ligne 2 colonne 3

        changeCDV(3,1,y+2,x+1) -- Ligne 3 colonne 1
        changeCDV(3,2,y+2,x)   -- Ligne 3 colonne 2
        changeCDV(3,3,y+2,x-1) -- Ligne 3 colonne 3


        -- Juste pour vérifier la table dans la console
        print('___')
        for ligne=1,3 do
            local printCDV = CDV[ligne][1]..CDV[ligne][2]..CDV[ligne][3]
            print(printCDV)
        end
        print('___')
    end


    -- OUEST
    if dungeon.playerDirection == dungeon.ouest then
        changeCDV(1,1,y+1,x)   -- Ligne 1 colonne 1
        changeCDV(1,2,y,x)     -- Ligne 1 colonne 2
        changeCDV(1,3,y-1,x)   -- Ligne 1 colonne 3

        changeCDV(2,1,y+1,x-1) -- Ligne 2 colonne 1
        changeCDV(2,2,y,x-1)   -- Ligne 2 colonne 2
        changeCDV(2,3,y-1,x-1) -- Ligne 2 colonne 3

        changeCDV(3,1,y+1,x-2) -- Ligne 3 colonne 1
        changeCDV(3,2,y,x-2)   -- Ligne 3 colonne 2
        changeCDV(3,3,y-1,x-2) -- Ligne 3 colonne 3


        -- Juste pour vérifier la table dans la console
        print('___')
        for ligne=1,3 do
            local printCDV = CDV[ligne][1]..CDV[ligne][2]..CDV[ligne][3]
            print(printCDV)
        end
        print('___')
    end



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