%% Voici un exemple de progamme pour la fonction *update* des robots.

% Dans l'exemple pr�c�dent, les robots perdent beaucoup de temps � longer les murs 
% de l'ar�ne. Dans ce deuxi�me exemple, il vont en plus �viter les murs
% (tout le reste est identique � l'exemple 1).


   % Si le robot ne sait pas o� est la cible, il cherche 
   % en se d�pla�ant au hasard
    if (robot.cible_detected==0)

        % D'abord il faut v�rifier s'il n'y a pas un mur � proximit�. 
        % Dans ce programme, si le robot est � moins de 20 cm d'un mur, il se 
        % dirige dans la direction oppos�e
        
        border_v = [0 0]; % direction oppos�e aux murs
        SAFE_BORDER = 0.2; % distance d'�vitement des murs (20 cm)

        % La variable INFO.murs nous donne la distance de chaque mur.
        if INFO.murs.dist_droite < SAFE_BORDER
            border_v = border_v + [-0.1 0];
        end
        if INFO.murs.dist_gauche < SAFE_BORDER
            border_v = border_v + [0.1 0];
        end        
        if INFO.murs.dist_haut < SAFE_BORDER
            border_v = border_v + [0 -0.1];
        end
        if INFO.murs.dist_bas < SAFE_BORDER
            border_v = border_v + [0 0.1];
        end 

        
        % Si le robot est arret�, il d�marre dans une direction al�atoire
        if (robot.vx==0 && robot.vy==0)
            randVel = [rand.*2 - 1 ; rand.*2 - 1 ] ;
            v = randVel + border_v ; 
            
            robot.move(v(1),v(2)); % la fonction 'move' permet de d�placer le robot.
            
        else
            
            % Sinon, il change de direction de temps en temps (au hasard)
                if rand<0.005
                    randVel = [rand.*2 - 1 ; rand.*2 - 1 ] ;
                    v = randVel + border_v ; 
                    robot.move(v(1),v(2));
                else
                    robot.move(robot.vx + border_v(1) , robot.vy + border_v(2));
                end
        end
        
        

    else    
        
    % Le robot qui connait l'emplacement de la cible donne 
    % l'information � tous ses voisins.
    
            for i=1:INFO.nbVoisins
                voisin = INFO.voisins{i};
                voisin.set_info_cible(robot.cible_x, robot.cible_y);
            end
       
    % Si le robot connait l'emplacement de la cible
    % il s'en rapproche jusqu'� ce qu'il puisse l'attaquer
        if (robot.cible_attacked==0)
            vx = robot.cible_x-robot.x ; 
            vy = robot.cible_y-robot.y ;
            robot.move(vx,vy);
        else
            % S'il est assez proche pour attaquer, il s'immobilise (attaque
            % automatique)
            robot.move(0,0);
        end
        


    end

