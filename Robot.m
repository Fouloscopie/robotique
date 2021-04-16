classdef Robot < handle
    
    %% Voici un robot. 
    % Cette classe determine le comportement du robot. 
    % À partir d'ici, vous pourrez programmer son déplacement et
    % la manière dont il communique avec les autres robots. 
    % 
    % Lors de la simulation, il y aura 12 robots en même temps, tous identiques
    % (techniquement : 12 instances de cette classe). 
    % Leur mission : trouver une cible cachée dans l'environement et la 
    % détruire le plus vite possible.
    % 
    % Vous pouvez ajouter votre code dans la fonction *update*
    % Vous êtes aussi libre d'ajouter des attributs, des méthodes ou des
    % scripts annexes si nécessaire. 
    
    
    %% Propriétés du robot
    properties
        id              % L'identifiant du robot, compris entre 1 et 12.
        x               % La position x du robot dans l'arène   
        y               % La position y du robot dans l'arène
        orientation     % L'orientation du robot. C'est un angle exprimé en radian où 0 indique que le robot est orienté vers l'est.  
        
        % Les 4 premières propriétés se mettent à jour automatiquement.
        % Vous pouvez les lire si vous en avez besoin mais vous ne 
        % pouvez pas les modifier manuellement. 
        % Pour changer la position du robot, vous devez lui appliquer un
        % mouvement (vx, vy)
        
        vx              % Le mouvement que le robot essaye de produire, le long de l'axe x.
        vy              % Le mouvement que le robot essaye de produire, le long de l'axe y.
        
        % Les valeurs (vx,vy) constitue un vecteur de déplacement. Elles
        % sont initialisées à (0,0) ce qui signifie que le robot sera
        % immobile au début. Pour faire bouger votre robot, changez ces
        % deux valeurs à votre convenance. Par exemple pour faire bouger votre
        % robot vers la droite, choisissez vx = 1 et vy = 0. Pour le faire
        % bouger vers le bas, choisissez vx = 0 et vy = -1.
        %
        % ATTENTION : Vous ne pouvez pas déplacer le robot à une
        % coordonnée absolue (x,y). Le robot n'a pas de GPS, ni de
        % perception globale de l'environement. Vous pouvez juste lui
        % ordonner de se déplacer dans une certaine direction par rapport à
        % son emplacement actuel.
        %
        % Il est recommandé d'utiliser la fonction 'move' (voir plus bas) pour
        % mettre à jour vx et vy.
        %
        % Attention: le mouvement du robot est contraint par la physique du système. 
        % Si le robot essaye d'aller contre un mur ou risque une collision avec un
        % autre robot, des procédures de sécurité l'en empecheront. 
        
        
        cible_detected  % 1 si le robot connait l'emplacement de la cible, 0 sinon. 
        cible_attacked  % 1 si le robot est en train d'attaquer la cible, 0 sinon. 
        cible_x         % Position x de la cible dans l'environement (initialement inconnue)
        cible_y         % Position y de la cible dans l'environement (initialement inconnue)
        
        % Ces 4 propriétés se mettent aussi à jour automatiquement.
        % Vous pouvez les lire si vous en avez besoin mais vous ne 
        % devez pas les modifier manuellement. 
        % Dès que le robot est en contact avec la cible, la 
        % propriété *cible_detected* passera automatiquement à 1 
        % et les coordonnées (cible_x, cible_y) seront renseignées. Vous
        % n'avez pas besoin de vous en occuper.
        %
        % Une fois la cible detectée, le robot attaquera automatiquement la 
        % cible s'il est suffisamment proche (*cible_attacked* passera à 1)
        % et cessera de l'attaquer s'il s'éloigne (*cible_attacked* passera
        % à 0).
        % Un robot qui a détécté la cible peut passer l'information à ses
        % voisins, comme nous le verront pas tard.
        
        
        MAX_SPEED       % La vitesse de déplacement du robot. Vous ne pouvez pas modifier cette propriété.

    end
    
    
    
    methods
        
        function robot = Robot(id, x,y,orientation , SPEED)
            % Cette fonction est utilisée par le simulateur pour initialiser
            % le robot. Vous n'avez pas besoin de l'utiliser. 
            
            robot.id = id ;
            robot.x = x;
            robot.y = y;
            robot.orientation = orientation ;
            robot.vx = 0;
            robot.vy = 0;
            robot.MAX_SPEED = SPEED ;
            robot.cible_detected = 0 ;
            robot.cible_attacked = 0 ;
            robot.cible_x = NaN ;
            robot.cible_y = NaN ;

        end
        
        
        function robot = move(robot, vx, vy)
            % Utilisez cette fonction pour donner une direction de
            % déplacement (vx, vy) à ce robot ou à un robot voisin. 
            % Par exemple move(1,0) produira un déplacement vers la
            % droite.
            
            v = [vx ; vy];
            if (norm(v)>0)
                v =  robot.MAX_SPEED .* v ./ norm(v);
            end
            
            robot.vx = v(1) ;
            robot.vy = v(2) ;
        end
        
        
        function robot = set_info_cible(robot, cible_x, cible_y)
            % Cette fonction permet de renseigner les informations sur la 
            % cible. Vous pouvez vous en servir pour passer l'information
            % à un autre robot voisin. 

            robot.cible_detected = 1 ;
            
            robot.cible_x = cible_x ;
            robot.cible_y = cible_y ;
        end   
        
        
        function robot = start_attack(robot)  
            % Cette fonction est appelée automatiquement lorsque le robot
            % à détécté la cible et est à distance d'attaque.
            % Vous ne devez pas l'utiliser manuellement.
            robot.cible_attacked = 1 ;
        end
        
        
        function robot = stop_attack(robot)  
            % Cett fonction est appelée automatiquement lorsque le robot
            % n'est plus à distance d'attaque de la cible.
            % Vous ne devez pas l'utiliser manuellement.
            robot.cible_attacked = 0 ;
        end       
        
        
        %% À vous de jouer !! 
        
        % Le robot va executer la fonction *update* ci-dessous 30 fois
        % par seconde. Vous pouvez y mettre le code que vous souhaitez.
        
        % À chaque fois que la fonction *update* est appelée, le robot
        % reçoit des informations sur son environement proche.
        % Ces informations sont contenues dans la variable INFO. 
        
        % La variable INFO contient les informations suivantes :
        %
        % INFO.murs.dist_haut : La distance entre le robot et le mur 
        % du haut de l'arène. 
        %
        % INFO.murs.dist_bas : La distance entre le robot et le mur 
        % du bas de l'arène. 
        %
        % INFO.murs.dist_gauche : La distance entre le robot et le mur 
        % de gauche de l'arène. 
        %
        % INFO.murs.dist_droite : La distance entre le robot et le mur 
        % de droite de l'arène. 
        %
        % Si un mur est hors du rayon de perception du robot, la distance
        % indiquée sera NaN (inconnue).
        %
        %
        % INFO.nbVoisins : Le nombre d'autres robots présents dans le rayon
        % de perception du robot.
        %
        % INFO.voisins : La liste des autres robots présents dans le rayon
        % de perception du robot. Le robot peut lire les propriétés de ces
        % autres robots et interagir avec eux. 
        %
        % Par exemple,
        %
        % INFO.voisins{i}.id vous donne l'identifiant du voisin i. 
        %
        % INFO.voisins{i}.cible_detected permet de savoir si le voisin i
        % a détécté la cible.
        %
        % INFO.voisins{i}.move(vx,vy) permet d'ordonner au voisin i de se
        % déplacer le long de vx,vy. 
        %
        % INFO.voisins{i}.set_info_cible(x,y) permet de donner les coordonnées 
        % de la cible au voisin i. 
        %
        % etc... 
        %
        % Les informations contenues dans INFO sont essentielles pour adapter le 
        % comportement de votre robot.
        
        function robot = update(robot, INFO)
  
            
            %%%% AJOUTEZ VOTRE CODE ICI %%%%
            
            % Pour vous aider à démarrer, voici un exemple très simple de programmation
            % possible. Le script exemple1.m montre comment implémenter un
            % déplacement aléatoire. 
            %
            % (n'oubliez pas de commenter cette ligne lorsque vous écrirez votre 
            % propre programme) 
            
            
            exemple1 ;
            
            % L'exemple 1 n'est pas très efficace car les robots ont
            % tendance à se coincer contre les murs.
            %
            % Voici un autre exemple un peu plus élaboré. Dans le script
            % exemple2.m le robot se déplace aléatoirement mais il évite
            % les murs et communique la position de la cible à ses voisins
            % lorsqu'il la découvre (qui eux-même la donneront à leur
            % propre voisins, etc...)
            %
            % (n'oubliez pas de commenter cette ligne lorsque vous écrirez votre 
            % propre programme) 
            
            
            %exemple2;
            
            % À tout moment, vous pouvez taper Main dans la fenetre de 
            % commandes de Matlab pour lancer la simulation.
            
            % Lorsque votre programme est prêt, utilisez ce formulaire pour
            % participer au tournois :
            % https://form.jotform.com/211041157414038
            
            % Amusez-vous bien !
            

        end
        

    end
end

