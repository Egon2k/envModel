clear all;
clc

% tractor parameter
param.tractor.steeringAngleInit = 0;
param.tractor.wheelbase         = 6;                % [m]
param.tractor.hitchLength       = 0.72;             % [m]
param.tractor.psiInit           = 0 * pi/180;

%% control
radius                          = 15;               %[m]
control.tractor.steeringAngle   = 0;%-atan(param.tractor.wheelbase/radius);
control.tractor.frontWheelV     = 2;                % [m/s]
control.sprayer.beta            = 0 *  pi/180;


%% sprayer parameter
param.sprayer.l2                = 2.370;            % {m]
param.sprayer.l3                = 3.055;            % {m]

param.sprayer.alphaInit         = 0 * pi/180;       % angle between tractor and sprayer
param.sprayer.betaInit          = 0 * pi/180;       % kink angle

%% simulation
sim.dt                          = 0.01;             % sampling rate in [s]
sim.T                           = 40;               % simulated time in [s]

figure(1);
clf;
figure(2);
clf;

%% init
[tractor, sprayer] = initStep(param);
animation(0, control, tractor, sprayer);

distance = 0;

TRANS_DELAY = 40;
delay = zeros(1,TRANS_DELAY+1);
delayIndex = 1;
delayedIndex = 0;

intBeta = 0;

%% calculation
for i = 1:(sim.T/sim.dt)
    [tractor, sprayer] = singleStep(param, control, sim, tractor, sprayer);

    distance = distance + sprayer.ds;

    if (distance > 0.2)

        distance = 0;
        animation(1, control, tractor, sprayer);

        delay(delayIndex) = sprayer.alpha;
        delayIndex = delayIndex + 1;
        if (delayIndex > TRANS_DELAY)
            delayIndex = delayIndex - TRANS_DELAY;
        end

        delayedIndex = delayIndex - 8;
        if (delayedIndex < 1)
            delayedIndex = delayedIndex + TRANS_DELAY;
        end
        control.sprayer.beta = 1 * delay(delayedIndex);
%         control.sprayer.beta = calcAngleRatio(sprayer.alpha, ...
%                                               param.tractor.hitchLength, ...
%                                               param.sprayer.l2) * ...
%                                delay(delayedIndex);
                           
        drawnow
        
        
        
        figure(2);
        hold on;
        plot(i,sprayer.alpha*180/pi,'g.');
        plot(i,control.sprayer.beta*180/pi,'b.');
        plot(i,(intBeta)*180/pi,'r.');
        intBeta = intBeta + 0.01*control.sprayer.beta;
    end

%     if mod(i,10/sim.dt) == 0
%         control.tractor.steeringAngle = (rand - 0.5) * 40 * pi/180;
%         control.tractor.frontWheelV   = rand * 3 + 1;
%         fprintf('SteeringAngle: %0.3f°\n', control.tractor.steeringAngle * 180 / pi);
%         fprintf('FrontWheelVel: %0.3f m/s\n', control.tractor.frontWheelV);
%     end
    
%     if i == 10/sim.dt
%         control.tractor.steeringAngle = -35 * pi/180;
%     end
%     if i == 20/sim.dt
%         control.tractor.steeringAngle = 0;
%     end
%     if i == 30/sim.dt
%         control.tractor.steeringAngle = +35 * pi/180;
%     end
%     if i == 40/sim.dt
%         control.tractor.steeringAngle = 0;
%     end

    if i > 5/sim.dt && i < 15/sim.dt
        control.tractor.steeringAngle = control.tractor.steeringAngle - 3.5*sim.dt * pi/180;
    end
    
    if i > 15/sim.dt && i < 25/sim.dt
        control.tractor.steeringAngle = control.tractor.steeringAngle + 3.5*sim.dt * pi/180;
    end
    
    if i > 30/sim.dt && i < 40/sim.dt
        control.tractor.steeringAngle = control.tractor.steeringAngle - 3.5*sim.dt * pi/180;
    end
    
    if i > 40/sim.dt && i < 50/sim.dt
        control.tractor.steeringAngle = control.tractor.steeringAngle + 3.5*sim.dt * pi/180;
    end
    
end


