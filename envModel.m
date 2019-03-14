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
control.tractor.steeringAngle   = -atan(param.tractor.wheelbase/radius);
control.tractor.frontWheelV     = 10;               % [m/s]
control.sprayer.beta            = 0;%15 *  pi/180;


%% sprayer parameter
param.sprayer.l2                = 5.5;              % {m]
param.sprayer.l3                = 0.001;            % {m]

param.sprayer.alphaInit         = 0 * pi/180;         % angle between tractor and sprayer
param.sprayer.betaInit          = control.sprayer.beta; % kink angle

param.sprayer.psiInit           = 0 * pi/180;

%% simulation
sim.dt                          = 0.1;              % sampling rate in [s]
sim.T                           = 10;               % simulated time in [s]

%% init

% tractor
tractor.frontX          = 0;
tractor.frontY          = 0;

tractor.rearX           = tractor.frontX - ...
                          param.tractor.wheelbase * ...
                          cos(param.tractor.psiInit);
tractor.rearY           = tractor.frontY - ...
                          param.tractor.wheelbase * ...
                          sin(param.tractor.psiInit);


tractor.hitchX          = tractor.rearX - ...
                          param.tractor.hitchLength * ...
                          cos(param.tractor.psiInit);
tractor.hitchY          = tractor.rearY - ...
                          param.tractor.hitchLength * ...
                          sin(param.tractor.psiInit);

tractor.psi             = tan(...
                          (tractor.frontY - tractor.rearY)/...
                          (tractor.frontX - tractor.rearX));


% sprayer
sprayer.hitchX          = tractor.hitchX;

sprayer.hitchY          = tractor.hitchY;

sprayer.kinkX           = sprayer.hitchX - ...
                          param.sprayer.l2 * ...
                          cos(param.sprayer.psiInit + param.sprayer.alphaInit);

sprayer.kinkY           = sprayer.hitchY - ...
                          param.sprayer.l2 * ...
                          sin(param.sprayer.psiInit + param.sprayer.alphaInit);

sprayer.axisX           = sprayer.kinkX - ...
                          param.sprayer.l3 * ...
                          cos(param.sprayer.psiInit + param.sprayer.alphaInit + param.sprayer.betaInit);

sprayer.axisY           = sprayer.kinkY - ...
                          param.sprayer.l3 * ...
                          sin(param.sprayer.psiInit + param.sprayer.alphaInit + param.sprayer.betaInit);

sprayer.psi             = tan(...
                          (sprayer.hitchY - sprayer.kinkY)/...
                          (sprayer.hitchX - sprayer.kinkX));

sprayer.alpha           = param.sprayer.alphaInit;

animation(0, control, tractor, sprayer);

%% calculation

for i = 1:(sim.T/sim.dt)
    [tractor, sprayer] = singleStep(param, control, sim, tractor, sprayer);
    animation(1, control, tractor, sprayer);
    pause(sim.dt);
end


