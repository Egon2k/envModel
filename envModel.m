clear all;
clc

% tractor parameter
param.tractor.steeringAngleInit = 0;
param.tractor.wheelbase         = 6;                % [m]
param.tractor.hitchLength       = 0.72;             % [m]
param.tractor.psiInit           = 0 * pi/180;

%% control
radius                          = 15;               %[m]
control.tractor.steeringAngle   = -atan(param.tractor.wheelbase/radius);
control.tractor.frontWheelV     = 2.5;              % [m/s]
control.sprayer.beta            = 0 *  pi/180;


%% sprayer parameter
param.sprayer.l2                = 5.5;              % {m]
param.sprayer.l3                = 0;                % {m]

param.sprayer.alphaInit         = 0 * pi/180;       % angle between tractor and sprayer
param.sprayer.betaInit          = 0 * pi/180;       % kink angle

%% simulation
sim.dt                          = 0.01;             % sampling rate in [s]
sim.T                           = 50;               % simulated time in [s]

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
closestIndex = 0;

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

        closestIndex = delayIndex - 12;
        if (closestIndex < 1)
            closestIndex = closestIndex + TRANS_DELAY;
        end
        control.sprayer.beta = 0.81*delay(closestIndex);

        drawnow
        
        figure(2);
        hold on;
        plot(i,sprayer.alpha*180/pi,'gx');
        plot(i,control.sprayer.beta*180/pi,'bo');
    end

    if i > 500 && i < 750
        control.tractor.steeringAngle = control.tractor.steeringAngle + 0.1 * pi/180;
    end
    
    if i > 1000 && i < 1250
        control.tractor.steeringAngle = control.tractor.steeringAngle - 0.1 * pi/180;
    end

%     if i == 1000  control.tractor.steeringAngle = 10 * pi/180; end
%     if i == 3000  control.tractor.steeringAngle = 30 * pi/180; end
%     if i == 4000  control.tractor.steeringAngle = 40 * pi/180; end
%

    

end


