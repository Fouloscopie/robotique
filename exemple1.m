%% Voici un exemple de progamme pour la fonction *update* des robots.
% Ici, le robot se d�place al�atoirement et s'immobilise lorsqu'il d�couvre
% la cible (pour l'attaquer).

   % Si le robot ne sait pas o� est la cible, il cherche 
   % en se d�pla�ant au hasard
    if (robot.cible_detected==0)

        % Si le robot est arret�, il d�marre dans une direction al�atoire
        if (robot.vx==0 && robot.vy==0)
            randVel = [rand.*2 - 1 ; rand.*2 - 1 ] ;
            v = randVel ; 
            
            robot.move(v(1),v(2)); % la fonction 'move' permet de d�placer le robot.
            
        else
            
            % Sinon, il change de direction de temps en temps (au hasard)
                if rand<0.005
                    randVel = [rand.*2 - 1 ; rand.*2 - 1 ] ;
                    v = randVel; 
                    robot.move(v(1),v(2));
                else
                    robot.move(robot.vx, robot.vy);
                end
        end
        

    else   
        
        % Si le robot connait l'emplacement de la cible
        % il s'en rapproche jusqu'� ce qu'il puisse l'attaquer
        if (robot.cible_attacked==0)
            vx = robot.cible_x-robot.x ; 
            vy = robot.cible_y-robot.y ;
            robot.move(vx,vy);
        else
            % S'il est assez proche pour attaquer, il s'immobilise
            robot.move(0,0);
        end
        
        % Pour rappel : le robot attaque la cible automatiquement s'il
        % connait son emplacement et se trouve � distance d'attaque. Vous
        % n'avez pas � vous en soucier dans le code.
    end

