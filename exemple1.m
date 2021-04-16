%% Voici un exemple de progamme pour la fonction *update* des robots.
% Ici, le robot se déplace aléatoirement. Lorsqu'il découvre la cible il communique
% l'information à tous ses voisins et va l'attaquer


   % Si le robot ne sait pas où est la cible, il cherche 
    % en se déplaçant au hasard
    if (robot.cible_detected==0)

        % Si le robot est arreté, il démarre dans une direction aléatoire
        if (robot.vx==0 && robot.vy==0)
            randVel = [rand.*2 - 1 ; rand.*2 - 1 ] ;
            v = randVel; 
            
            robot.move(v(1),v(2)); % la fonction 'move' permet de déplacer le robot.
        else
            % Sinon, il change de direction de temps en temps (au hasard)
                if rand<0.005
                    randVel = [rand.*2 - 1 ; rand.*2 - 1 ] ;
                    v = randVel ; 
                    robot.move(v(1),v(2));
                else
                   robot.move(robot.vx, robot.vy);
                end
                
        end

    else
        
        % Si le robot connait l'emplacement de la cible, il la communique à
        % tous ses voisins
        for i=1:INFO.nbVoisins
            voisin = INFO.voisins{i};
            voisin.set_info_cible(robot.cible_x, robot.cible_y);
        end
        
        % Si le robot n'est pas à distance d'attaque,
        % il s'approche de la cible jusqu'à ce qu'il puisse l'attaquer
        if (robot.cible_attacked==0)
            vx = robot.cible_x-robot.x ; 
            vy = robot.cible_y-robot.y ;
            robot.move(vx,vy);
        else
            %s'il est a distance d'attaque il s'arrête
            robot.move(0,0);
        end
        
        % Pour rappel : le robot attaque la cible automatiquement s'il
        % connait son emplacement et se trouve à distance d'attaque. Vous
        % n'avez pas à vous en soucier dans le code.

    end

    
    