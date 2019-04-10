clear all


%% simulation
sim.dt                          = 0.001;              % sampling rate in [s]
sim.T                           = 10;               % simulated time in [s]

% tractor parameter
param.tractor.steeringAngleInit = 0;
param.tractor.wheelbase         = 6;                % [m]
param.tractor.hitchLength       = 0.72;             % [m]
param.tractor.psiInit           = 0;


%% sprayer parameter
param.sprayer.l2                = 5.5;              % {m]
param.sprayer.l3                = 0;                % {m]

param.sprayer.alphaInit         = 0 * pi/180;       % angle between tractor and sprayer
param.sprayer.betaInit          = 0 * pi/180;       % kink angle
param.sprayer.psiInit           = 0 * pi/180;

index = 1;

for steering = -45:1:45
    % control
    control.tractor.steeringAngle   = steering*pi/180;
    control.tractor.frontWheelV     = 10;           % [m/s]
    control.sprayer.beta            = 0;
    
    figure(1);
    clf;
    distance = 0;
    
    %% init
    [tractor, sprayer] = initStep(param);
    animation(0, control, tractor, sprayer);

    hitchXold = tractor.hitchX;
    hitchYold = tractor.hitchY;
    
    %% calculation
    for i = 1:(sim.T/sim.dt)
        [tractor, sprayer] = singleStep(param, control, sim, tractor, sprayer);
        animation(1, control, tractor, sprayer);

        distance = distance + sprayer.ds;
        
        if (distance > 0.2)
            break;
        end
        
        %pause(sim.dt/2);
    end
    
    % calculate the distance the hitch traveled
    x(index) = steering;
    hitchDistance(index) = sqrt((tractor.hitchX - hitchXold)^2 + ...
                            (tractor.hitchY - hitchYold)^2);
    hitchDirection(index) = atan2d((tractor.hitchY - hitchYold), ...
                               (tractor.hitchX - hitchXold));
    distarray(index) = distance;
    
    index = index + 1;

    figure(2);
    clf;
    plot(x,hitchDistance,'r');
    plot(x,distarray,'b');

    figure(3);
    clf;
    plot(x,hitchDirection,'g');
    
    fprintf('#');
end

%min(hitchDistance)
%max(hitchDistance)