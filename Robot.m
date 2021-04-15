classdef Robot < handle
    
    %% Voici un robot. 
    % Cette classe determine le comportement du robot. 
    % � partir d'ici, vous pourrez programmer son d�placement et
    % la mani�re dont il communique avec les autres robots. 
    % 
    % Lors de la simulation, il y aura 12 robots en m�me temps, tous identiques
    % (techniquement : 12 instances de cette classe). 
    % Leur mission : trouver une cible cach�e dans l'environement et la 
    % d�truire le plus vite possible.
    % 
    % Vous pouvez ajouter votre code dans la fonction *update*
    
    
    %% Propri�t�s du robot
    properties
        id              % L'identifiant du robot, compris entre 1 et 12.
        x               % La position x du robot dans l'ar�ne   
        y               % La position y du robot dans l'ar�ne
        orientation     % L'orientation du robot. C'est un angle exprim� en radian o� 0 indique que le robot est orient� vers l'est.  
        
        % Les 4 premi�res propri�t�s se mettent � jour automatiquement.
        % Vous pouvez les lire si vous en avez besoin mais vous ne 
        % pouvez pas les modifier manuellement. 
        % Pour changer la position du robot, vous devez lui appliquer un
        % mouvement (vx, vy)
        
        vx              % Le mouvement que le robot essaye de produire, le long de l'axe x.
        vy              % Le mouvement que le robot essaye de produire, le long de l'axe y.
        
        % Les valeurs (vx,vy) constitue un vecteur de d�placement. Elles
        % sont initialis�es � (0,0) ce qui signifie que le robot sera
        % immobile au d�but. Pour faire bouger votre robot, changez ces
        % deux valeurs � votre convenance. Par exemple pour faire bouger votre
        % robot vers la droite, choisissez vx = 1 et vy = 0. Pour le faire
        % bouger vers le bas, choisissez vx = 0 et vy = -1.
        %
        % Il est recommand� d'utiliser la fonction 'move' (voir plus bas) pour
        % mettre � jour vx et vy.
        %
        % Attention: le mouvement du robot est contraint par la physique du syst�me. 
        % Si le robot essaye d'aller contre un mur ou risque une collision avec un
        % autre robot, des proc�dures de s�curit� l'en empecheront. 
        
        
        cible_detected  % 1 si le robot connait l'emplacement de la cible, 0 sinon. 
        cible_attacked  % 1 si le robot est en train d'attaquer la cible, 0 sinon. 
        cible_x         % Position x de la cible dans l'environement (initialement inconnue)
        cible_y         % Position y de la cible dans l'environement (initialement inconnue)
        
        % Ces 4 propri�t�s se mettent aussi � jour automatiquement.
        % Vous pouvez les lire si vous en avez besoin mais vous ne 
        % devez pas les modifier manuellement. 
        % D�s que le robot est en contact avec la cible, la 
        % propri�t� *cible_detected* passera automatiquement � 1 
        % et les coordonn�es (cible_x, cible_y) seront renseign�es. Vous
        % n'avez pas besoin de vous en occuper.
        %
        % Une fois la cible detect�e, le robot attaquera automatiquement la 
        % cible s'il est suffisamment proche (*cible_attacked* passera � 1)
        % et cessera de l'attaquer s'il s'�loigne (*cible_attacked* passera
        % � 0).
        % Un robot qui a d�t�ct� la cible peut passer l'information � ses
        % voisins, comme nous le verront pas tard.
        
        
        MAX_SPEED       % La vitesse de d�placement du robot. Vous ne pouvez pas modifier cette propri�t�.

    end
    
    
    
    methods
        
        function robot = Robot(id, x,y,orientation , SPEED)
            % Cette fonction est utilis�e par le simulateur pour initialiser
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
            % d�placement (vx, vy) � ce robot ou � un robot voisin. 
            % Par exemple move(1,0) produira un d�placement vers la
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
            % � un autre robot voisin. 

            robot.cible_detected = 1 ;
            
            robot.cible_x = cible_x ;
            robot.cible_y = cible_y ;
        end   
        
        
        function robot = start_attack(robot)  
            % Cette fonction est appel�e automatiquement lorsque le robot
            % � d�t�ct� la cible et est � distance d'attaque.
            % Vous ne devez pas l'utiliser manuellement.
            robot.cible_attacked = 1 ;
        end
        
        
        function robot = stop_attack(robot)  
            % Cett fonction est appel�e automatiquement lorsque le robot
            % n'est plus � distance d'attaque de la cible.
            % Vous ne devez pas l'utiliser manuellement.
            robot.cible_attacked = 0 ;
        end       
        
        
        %% � vous de jouer !! 
        
        % Le robot va executer la fonction *update* ci-dessous 30 fois
        % par seconde. Vous pouvez y mettre le code que vous souhaitez.
        
        % � chaque fois que la fonction *update* est appel�e, le robot
        % re�oit des informations sur son environement proche.
        % Ces informations sont contenues dans la variable INFO. 
        
        % La variable INFO contient les informations suivantes
        %
        % INFO.murs.dist_haut : La distance entre le robot et le mur 
        % du haut de l'ar�ne. 
        %
        % INFO.murs.dist_bas : La distance entre le robot et le mur 
        % du bas de l'ar�ne. 
        %
        % INFO.murs.dist_gauche : La distance entre le robot et le mur 
        % de gauche de l'ar�ne. 
        %
        % INFO.murs.dist_droite : La distance entre le robot et le mur 
        % de droite de l'ar�ne. 
        %
        % Si un mur est hors du rayon de perception du robot, la distance
        % indiqu�e sera NaN (inconnue).
        %
        %
        % INFO.nbVoisins : Le nombre d'autres robots pr�sents dans le rayon
        % de perception du robot.
        %
        % INFO.voisins : La liste des autres robots pr�sents dans le rayon
        % de perception du robot. Le robot peut lire les propri�t�s de ces
        % autres robots et interagir avec eux. 
        %
        % Par exemple,
        %
        % INFO.voisins{i}.id vous donne l'identifiant du voisin i. 
        % INFO.voisins{i}.cible_detected permet de savoir si le voisin i
        % a d�t�ct� la cible.
        % INFO.voisins{i}.move(vx,vy) permet d'ordonner au voisin i de se
        % d�placer le long de vx,vy. 
        % INFO.voisins{i}.set_info_cible(x,y) permet de donner les coordonn�es 
        % de la cible au voisin i. 
        % etc... 
  

        % Les informations contenues dans INFO sont essentielles pour adapter le 
        % comportement de votre robot.
        
        function robot = update(robot, INFO)
  
            
            %%%% AJOUTEZ VOTRE CODE ICI %%%%
            
            % Pour vous aider � d�marrer, voici un exemple tr�s simple de programmation
            % possible. Le script exemple1.m montre comment impl�menter un
            % d�placement al�atoire. 
            %
            % (n'oubliez pas de commenter cette ligne lorsque vous �crirez votre 
            % propre programme) 
            
            
            %exemple1 ;
            
            % Voici un autre exemple un peu plus �labor�. Dans le script
            % exemple2.m le robot se d�place al�atoirement mais il �vite
            % les murs et communique la position de la cible � ses voisins
            % lorsqu'il la d�couvre (qui eux-m�me la donneront � leur
            % propre voisins, etc...)
            %
            % (n'oubliez pas de commenter cette ligne lorsque vous �crirez votre 
            % propre programme) 
            
            
            exemple2;
            
            % Lorsque votre programme est pr�t, tapez Main dans la fenetre de 
            % commandes de Matlab pour lancer la simulation
            

        end
        

    end
end

