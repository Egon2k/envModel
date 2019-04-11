clear all;
close all;
clc


% tractor parameter
param.tractor.steeringAngleInit = 0;
param.tractor.wheelbase         = 6;                % [m]
param.tractor.hitchLength       = 0.72;             % [m]
param.tractor.psiInit           = 0;%-10 * pi/180;

%% control
radius                          = 10;               %[m]
control.tractor.steeringAngle   = 0;%-atan(param.tractor.wheelbase/radius);
control.tractor.frontWheelV     = 10;               % [m/s]
control.sprayer.beta            = 15 *  pi/180;


%% sprayer parameter
param.sprayer.l2                = 5.5;              % {m]
param.sprayer.l3                = 0.01;                % {m]

param.sprayer.alphaInit         = -15 * pi/180;         % angle between tractor and sprayer
param.sprayer.betaInit          = control.sprayer.beta; % kink angle

%% simulation
sim.dt                          = 0.1;              % sampling rate in [s]
sim.T                           = 2;               % simulated time in [s]

%% init
[tractor, sprayer] = initStep(param);
animation(0, control, tractor, sprayer);

%% calculation
for i = 1:(sim.T/sim.dt)
    [tractor, sprayer] = singleStep(param, control, sim, tractor, sprayer);
    animation(1, control, tractor, sprayer);
    
%     figure(2);
%     hold on;
%     plot(i,sprayer.alpha*180/pi,'gx');
%     plot(i,tractor.psi*180/pi,'bo');
%     plot(i,sprayer.psi*180/pi,'ro');
    
    pause(sim.dt/2);
end


