clear all;
close all;
clc

% tractor parameter
param.tractor.steeringAngleInit = 0;
param.tractor.wheelbase         = 6;                % [m]
param.tractor.hitchLength       = 0.72;             % [m]
param.tractor.psiInit           = 0 * pi/180;

%% control
radius                          = 10;               %[m]
control.tractor.steeringAngle   = -atan(param.tractor.wheelbase/radius);
control.tractor.frontWheelV     = 2;                % [m/s]
control.sprayer.beta            = 0 *  pi/180;


%% sprayer parameter
param.sprayer.l2                = 5.5;              % {m]
param.sprayer.l3                = 0;                % {m]

param.sprayer.alphaInit         = 0 * pi/180;       % angle between tractor and sprayer
param.sprayer.betaInit          = 0 * pi/180;       % kink angle

%% simulation
sim.dt                          = 0.01;             % sampling rate in [s]
sim.T                           = 4;                % simulated time in [s]

%% init
[tractor, sprayer] = initStep(param);
animation(0, control, tractor, sprayer);

distance = 0;
i_start = 0;

%% calculation
for i = 1:(sim.T/sim.dt)
    [tractor, sprayer] = singleStep(param, control, sim, tractor, sprayer);

    distance = distance + sprayer.ds;
    
    if (distance > 0.2)
        
        distance = 0;
        animation(1, control, tractor, sprayer);
        pause((i-i_start) * sim.dt/4);
        i_start = i;
    end
    
%     figure(2);
%     hold on;
%     plot(i,sprayer.alpha*180/pi,'gx');
%     plot(i,tractor.psi*180/pi,'bo');
%     plot(i,sprayer.psi*180/pi,'ro');

end


