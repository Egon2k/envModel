clear all


%% simulation
sim.dt                          = 0.001;            % sampling rate in [s]
sim.T                           = 10;               % simulated time in [s]

% tractor parameter
param.tractor.steeringAngleInit = 0;
param.tractor.wheelbase         = 6;                % [m]
param.tractor.hitchLength       = 0.72;             % [m]
param.tractor.psiInit           = 0;


%% sprayer parameter
param.sprayer.l2                = 5.5;              % {m]
param.sprayer.l3                = 0;                % {m]

%% control parameter
control.tractor.steeringAngle   = 0*pi/180;
control.tractor.frontWheelV     = 2;

figure(2)
clf;
figure(3)
clf;
pause(0.001);


for alphaSet = -30:10:30
    index = 1;
    
    param.sprayer.alphaInit         = alphaSet * pi/180;
    
    for betaSet = -30:10:30
        param.sprayer.betaInit      = betaSet * pi/180;
        control.sprayer.beta        = betaSet * pi/180;

        %% init
        [tractor, sprayer] = initStep(param);
        animation(0, control, tractor, sprayer);
        
        psiOld = sprayer.psi;
        
        figure(1);
        clf;
        distance = 0;

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
        
        x(index)          = betaSet;
        deltaAlpha(index) = alphaSet - sprayer.alpha;
        deltaPsi(index)   = psiOld   - sprayer.psi;
        
        index = index + 1;

        fprintf('#');
    end
    
    figure(2);
    hold on;
    plot(x,deltaAlpha,'r');
    
    figure(3);
    hold on;
    plot(x,deltaPsi);
    
    fprintf('\n');
    pause(0.001);
end

