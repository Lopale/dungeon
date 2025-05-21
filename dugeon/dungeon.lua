local dungeon = {}  -- On créer le module, le nom du modul n'a pas à être le même que celui du fichier mais cela est plus facile

local map = {}      -- Carte du niveau vide

local fogOfWar = {} -- Brouillard de guerre sur la map

dungeon.width = 0   -- On initialise la largeur du donjon à 0, pas de local pour pouvoir y acceder depuis l'exterieur
dungeon.height = 0  -- On initialise la hauteur du donjon à 0
dungeon.caseSize = 9  -- taille des cases en 2D en px -- pas en local pour que l'editeur de map y ai accès

local dungeonWidthPx = 200 -- Largeur de l'affichage du donjon en "3D" en pixel
local dungeonHeightPx = 200 -- Hauteur de l'affichage du donjon en "3D" en pixel
local dungeonPosX = 10 -- Marge en X du bord
local dungeonPosY = 10 -- Marge en Y du bord

local wallSize1 = 20 -- Largeur du mur premier plan en 3D
local wallSize2 = 30 -- Largeur du mur deuxieme plan en 3D

-- Position des lignes et colonne créer la vuie 3D (cf intersectionMurs dans ressources)
local colonne1Left = wallSize1
local colonne1Right = dungeonWidthPx - wallSize1
local colonne2Left = wallSize1 + wallSize2
local colonne2Right = dungeonWidthPx - (wallSize1 + wallSize2)
local ligne1Up = wallSize1
local ligne1Down = dungeonHeightPx - wallSize1
local ligne2Up = wallSize1 + wallSize2
local ligne2Down = dungeonHeightPx - (wallSize1 + wallSize2)


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
    dungeon.liftFog("normal") -- On appel la fonction qui lève le brouillard
end


function dungeon.liftFog(sizeReveal)
    if sizeReveal == "normal" then -- Retrait du brouillard autour du joueur
        fogOfWar[dungeon.playerY][dungeon.playerX] = 1
        fogOfWar[dungeon.playerY-1][dungeon.playerX-1] = 1
        fogOfWar[dungeon.playerY-1][dungeon.playerX] = 1
        fogOfWar[dungeon.playerY-1][dungeon.playerX+1] = 1
        fogOfWar[dungeon.playerY][dungeon.playerX-1] = 1
        fogOfWar[dungeon.playerY][dungeon.playerX+1] = 1
        fogOfWar[dungeon.playerY+1][dungeon.playerX-1] = 1
        fogOfWar[dungeon.playerY+1][dungeon.playerX] = 1
        fogOfWar[dungeon.playerY+1][dungeon.playerX+1] = 1
    elseif sizeReveal == "all" then -- retrait de tout le brouillard
        for ligne = 1, dungeon.width do
        fogOfWar[ligne]={}
            for colonne =1, dungeon.height do
                fogOfWar[ligne][colonne] = 1   -- Toute la map de brouillard est donc à 0
            end
        end
        print("On lève tout le brouillard")
    end
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

    -- Brouillard de guerre ( à utiliser dans la minimap)
    fogOfWar = {}
    for ligne = 1, dungeon.width do
        fogOfWar[ligne]={}
        for colonne =1, dungeon.height do
            fogOfWar[ligne][colonne] = 0   -- Toute la map de brouillard est donc à 0
        end
    end
end

-- test ce que contient la case sur laquelle on envoie les coordonnées
function dungeon.case(ligne, colonne)
    if ligne > 0 and ligne <= dungeon.height and colonne >0 and colonne < dungeon.width then
        print("map {",ligne,",",colonne,"}")
        return map[ligne][colonne]
    else
        return 0
    end
end

-- permet de changer la valeur d'une case (Peut être utiliser pour les mur destructible ?)
function dungeon.changeCase(ligne,colonne,valeurCase)
    if ligne > 1 and ligne <= dungeon.height-1 and colonne > 1 and colonne < dungeon.width then -- 1 au lieu de 0 pour éviter de détruire les bord
        map[ligne][colonne]= valeurCase
    end
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
            

            
            --love.graphics.rectangle("fill",x,y,dungeon.caseSize,dungeon.caseSize) -- on colorie chaque case de la bonne couleur à la bonne coordonnées

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
    
function draw2MiniMap() -- fonction de dessin en 3D
    -- love.graphics.print("Minimap", 250,190) -- Ecrit à 250 px en x et 150px en Y

    
    -- Décaller l'affichage du bord (création d'une "marge")
    local miniMapX = (dungeonPosX) + dungeonWidthPx
    local miniMapY = dungeonPosY
    love.graphics.translate(miniMapX, 0)

    
    love.graphics.scale(0.5,0.5) -- on agrandit par 2 la taille des éléments affichés
    


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

            -- On n'affiche que si la case à un 1 dans le brouillard de guerre
            if fogOfWar[ligne][colonne] == 1 then
                love.graphics.rectangle("fill",x,y,dungeon.caseSize,dungeon.caseSize) -- on colorie chaque case de la bonne couleur à la bonne coordonnées
            end

            
            --love.graphics.rectangle("fill",x,y,dungeon.caseSize,dungeon.caseSize) -- on colorie chaque case de la bonne couleur à la bonne coordonnées

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

-- dessine les murs pour la vue 3D, les vertices sont les coordonnées des points du polygones formant le mur
function drawWall(vertices)
    love.graphics.setColor(.5,.5,.5)
    love.graphics.polygon("fill",vertices)  -- polygone plein ( le contnu du mur) en gris (ligne du dessus)
    love.graphics.setColor(0,0,0)
    love.graphics.polygon("line",vertices)  -- polygone en ligne ( les contour du mur) en noir (ligne du dessus)
end
    
function draw3D() -- fonction de dessin en 3D
    -- love.graphics.print("Scene du donjon 3D", 120,190) -- Ecrit à 120 px en x et 150px en Y

    -- Décaller l'affichage du bord (création d'une "marge")
    love.graphics.translate(dungeonPosX, dungeonPosY)
    
    -- On dessine le cadre en noir
    love.graphics.setColor(0,0,0)
    -- Tracer un carré de la taille du donjon
    love.graphics.rectangle("line", 0,0, dungeonWidthPx, dungeonHeightPx)

    -- On dessine du plus loin au plus près (pour la superpoisiton des éléments)

    -- ligne 3
    if CDV[3][1] ~= 0 then
        drawWall(
            {
                0,
                ligne2Up,
                colonne2Left,
                ligne2Up,
                colonne2Left,
                ligne2Down,
                0,
                ligne2Down
            }
        )
    end
    if CDV[3][2] ~= 0 then
        drawWall(
            {
                colonne2Left,
                ligne2Up,
                colonne2Right,
                ligne2Up,
                colonne2Right,
                ligne2Down,
                colonne2Left,
                ligne2Down
            }
        )
    end
    if CDV[3][3] ~= 0 then
        drawWall(
            {
                colonne2Right,
                ligne2Up,
                dungeonWidthPx,
                ligne2Up,
                dungeonWidthPx,
                ligne2Down,
                colonne2Right,
                ligne2Down
            }
        )
    end
    -- ligne 2
    if CDV[2][1] ~= 0 then
        drawWall(
            {
                0,
                ligne1Up,
                colonne1Left,
                ligne1Up,
                colonne1Left,
                ligne1Down,
                0,
                ligne1Down
            }
        )
        drawWall(
            {
                colonne1Left,
                ligne1Up,
                colonne2Left,
                ligne2Up,
                colonne2Left,
                ligne2Down,
                colonne1Left,
                ligne1Down
            }
        )
    end
    if CDV[2][3] ~= 0 then
        drawWall(
            {
                colonne1Right,
                ligne1Up,
                dungeonWidthPx,
                ligne1Up,
                dungeonWidthPx,
                ligne1Down,
                colonne1Right,
                ligne1Down
            }
        )
        drawWall(
            {
                colonne2Right,
                ligne2Up,
                colonne1Right,
                ligne1Up,
                colonne1Right,
                ligne1Down,
                colonne2Right,
                ligne2Down
            }
        )
    end
    if CDV[2][2] ~= 0 then
        drawWall(
            {
                colonne1Left,
                ligne1Up,
                colonne1Right,
                ligne1Up,
                colonne1Right,
                ligne1Down,
                colonne1Left,
                ligne1Down
            }
        )
    end
    -- ligne 1
    if CDV[1][1] ~= 0 then
        drawWall(
            {
                0,
                0,
                colonne1Left,
                ligne1Up,
                colonne1Left,
                ligne1Down,
                0,
                dungeonHeightPx
            }
        )
    end
    if CDV[1][3] ~= 0 then
        drawWall(
            {
                colonne1Right,
                ligne1Up,
                dungeonWidthPx,
                0,
                dungeonWidthPx,
                dungeonHeightPx,
                colonne1Right,
                ligne1Down
            }
        )
    end
    if CDV[1][2] ~= 0 then
    -- C'est là où se trouve le joueur
    -- Il ne peut pas y avoir de mur
    end



end
    

function dungeon.draw(mode) -- Pour passer de 2D a 3D
    
    -- CHanger la couleur du fond
    love.graphics.setBackgroundColor(.5,.5,.5)

    if mode == "3D" then
        draw3D()
        draw2MiniMap()
    else
        draw2D()
    end

end


return dungeon -- OBLGATOIRE !!!, renvois le module et son contenu