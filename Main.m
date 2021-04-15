
%%  Ce code permet de parametrer et de lancer la simulation    %%
%                                                               %
%       ---------------  NE PAS MODIFIER ---------------        %
%                                                               %
%       Pour programmer les robots, utilisez Robot.m            %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Add path to subfolder
addpath(genpath('utilities'));
%addpath('./');


%% Set up Robotarium object

N = 12;
xi = [-0.45 -0.15 0.15 0.45 -0.45 -0.15 0.15 0.45 -0.45 -0.15 0.15 0.45];
yi = [0.3 0.3 0.3 0.3 0 0 0 0 -0.3 -0.3 -0.3 -0.3] ;
ai = rand(1,N).*2*  pi - pi ;
 
initial_conditions = [xi ; yi ; ai ] ;
 
r = Robotarium('NumberOfRobots', N, 'ShowFigure', true, 'InitialConditions', initial_conditions);


%% PARAMETERS 
SPEED = r.max_linear_velocity ; % Moving speed of the robots
DETECTION_RANGE = 0.05 ; % Distance to the target for detection
ATTACK_RANGE = 0.5 ; % Distance to the target for attacking 
ATTACK_STRENGTH = 0.01 ; % Reduction of target energy for robot attacking the target

PERCEPTION_RANGE = 0.35 ; % Perception range of the robots (for walls or neighbors)

[x_target, y_target] = getTargetPosition();
    
%% VARIABLES
target_energy = 100; % Experiment ends when target energy is down to 0

target_detected = zeros(1,N); % Which robots have detected the target
target_attacked = zeros(1,N); % Which robots are attacking the taget

%% AFFICHAGE
d = plot(x_target,y_target,'ro');
target_caption = text(-1.5, -1.1, sprintf('Energie de la cible : %0.1f%%', target_energy), 'FontSize', 15, 'FontWeight', 'bold', 'Color','r');
time_caption = text(-1.5, -1.2, sprintf('Temps écoulé : 0 s'), 'FontSize', 14, 'FontWeight', 'bold', 'Color','r');
uistack(target_caption, 'top'); 
uistack(time_caption, 'top'); 
uistack(d, 'bottom');

% Initialize velocity vector for agents.  
v = zeros(2, N);

%% BARRIER CERTIFICATES
uni_barrier_cert = create_uni_barrier_certificate_with_boundary();
%si_to_uni_dyn = create_si_to_uni_dynamics('LinearVelocityGain', 0.5, 'AngularVelocityLimit', pi/2);
si_to_uni_dyn = create_si_to_uni_dynamics();

%% CREATE THE ROBOTS
clear allRobots
for i=1:N
    allRobots{i} = Robot(i , initial_conditions(1,i) , initial_conditions(2,i) , initial_conditions(3,i) , SPEED);
end

%% DATA COLLECTION
expectedDuration = 5000 ;
total_time = 0 ;

data_target = nan(expectedDuration,2);
data_X = nan(expectedDuration,N);
data_Y = nan(expectedDuration,N);
data_attack = nan(expectedDuration,N);
data_detect = nan(expectedDuration,N);



%% START OF SIMULATION
iteration = 0 ;

while target_energy>0 && total_time<900
    
   % Update iteration
        iteration = iteration + 1 ;
        
   % UPdate total time
        total_time = total_time + r.time_step ;
        
    % Retrieve velocity and position of the robots
        x = r.get_poses();
        for i=1:N
            allRobots{i}.x = x(1,i);
            allRobots{i}.y = x(2,i);
            allRobots{i}.orientation = x(3,i);
        end
        
    % Distance to the target
        d_target = sqrt((x_target - x(1,:)).^2 + (y_target - x(2,:)).^2);
        
    % Walls detection
        dWalls.up = abs(1-x(2,:));
        dWalls.up(dWalls.up>PERCEPTION_RANGE) = NaN ;
        dWalls.down = abs(-1-x(2,:));
        dWalls.down(dWalls.down>PERCEPTION_RANGE) = NaN;
        dWalls.left = abs(-1.6-x(1,:));
        dWalls.left(dWalls.left>PERCEPTION_RANGE) = NaN;
        dWalls.right = abs(1.6-x(1,:));
        dWalls.right(dWalls.right>PERCEPTION_RANGE) = NaN;
    
     %% Behavioural algorithm for the robots

        % Compute distance between robots
        dm = squareform(pdist([x(1,:)' x(2,:)']));
        
        for i = 1:N

            % Detect the neighbors within the perception range
                %neighbors = delta_disk_neighbors(x, i, PERCEPTION_RANGE);
                neighbors = find(dm(i,:)<=PERCEPTION_RANGE & dm(i,:)>0);
                
            % Collect local information for robot i
                clear INFO
                
                % Walls information 
                    INFO.murs.dist_haut = dWalls.up(i);
                    INFO.murs.dist_bas = dWalls.down(i);
                    INFO.murs.dist_gauche = dWalls.left(i);
                    INFO.murs.dist_droite = dWalls.right(i);
                    
                % Neighbors information (when applicable)
                    INFO.nbVoisins = length(neighbors);
                    for v = 1:length(neighbors)
                        INFO.voisins{v} = allRobots{neighbors(v)};
                    end

                % Target information (when applicable)
                    if (d_target(i)<DETECTION_RANGE)
                        allRobots{i}.set_info_cible(x_target, y_target);
                    end
                    
                    if (allRobots{i}.cible_detected==1) && (d_target(i)<ATTACK_RANGE)
                        allRobots{i}.start_attack();
                    else
                        allRobots{i}.stop_attack();
                    end                   
  
            % Update the states of the robot
                allRobots{i}.update(INFO) ;
        end 

    
        % Control LEDS
        for i=1:N
            % Green light when target has been detected
            if (allRobots{i}.cible_detected==1)
                r.set_right_leds(i , [0 ; 255 ; 0]);
            end

            % Red light when target is attacked
            if (allRobots{i}.cible_attacked==1)
                r.set_left_leds(i , [255 ; 0 ; 0]);
            else
                r.set_left_leds(i , [0 ; 0 ; 0]);
            end
        end

    
    % Update target energy
        for i=1:N
            if (allRobots{i}.cible_attacked==1)
                target_energy = max(target_energy - ATTACK_STRENGTH , 0 );
            end
        end


    %% Update robots speed and position  
        clear dx
        for i=1:N
            dx(1,i) = allRobots{i}.vx ;
            dx(2,i) = allRobots{i}.vy ;
        end
        v = dx ;

    % Avoid actuator errors : we need to threshold dx
        norms = arrayfun(@(x) norm(dx(:, x)), 1:N);
        threshold = 3/4*r.max_linear_velocity;
        to_thresh = find(norms > threshold);
        if ~isempty(to_thresh)
            dx(:, to_thresh) = threshold*dx(:, to_thresh)./norms(to_thresh);
        end
    
    % Transform the single-integrator dynamics to unicycle dynamics using a provided utility function
        dx = si_to_uni_dyn(dx, x);  
        dx = uni_barrier_cert(dx, x);
        
    % Set velocities of agents 1:N
        r.set_velocities(1:N, dx);
        
    % Save data
        tmpAtt = zeros(1,N);
        tmpDet = zeros(1,N);
        for i=1:N
            if (allRobots{i}.cible_attacked==1)
                tmpAtt(i) = 1 ;
            end
            if (allRobots{i}.cible_detected==1)
                tmpDet(i) = 1 ;
            end 
        end
        data_attack(iteration,:) = tmpAtt ;
        data_detect(iteration,:) = tmpDet ;
        data_X(iteration,:) = x(1,:);
        data_Y(iteration,:) = x(2,:);
        data_target(iteration,:) = [target_energy total_time] ;


    % Send the previously set velocities to the agents.  This function must be called!
        r.step();   
    
    % Display
        target_caption.String = sprintf('Energie de la cible %0.1f%%', round(10.*target_energy)/10);
        time_caption.String = sprintf('Temps écoulé : %d s', round(iteration*r.time_step));
    
end

% Resultat
    disp(['Temps total pour détruire la cible : ' num2str(round(iteration*r.time_step)) ' secondes'])

    
% Données finales
    data_X = data_X(1:iteration,:);
    data_Y = data_Y(1:iteration,:);
    data_attack = data_attack(1:iteration,:);
    data_detect = data_detect(1:iteration,:);
    data_target = data_target(1:iteration,:);
    
    
    
    %r.debug();
