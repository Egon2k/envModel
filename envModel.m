clear all;
close all;
clc

%% parameter

param.tractor.steeringAngleInit = 0 * pi/180;
param.tractor.wheelbase         = 6;                % [m]
param.tractor.hitchLength       = 0.72;             % [m]
param.tractor.psiInit           = 0 * pi/180;

param.sprayer.l2                = 5.5;              % {m]
param.sprayer.l3                = 0;                % {m]

param.sprayer.alphaInit         = 0 * pi/180;
param.sprayer.betaInit          = 0 * pi/180;

%% control

control.tractor.steeringAngle   = 20 * pi/180;
control.tractor.frontWheelV     = 10;                % [m/s]
control.sprayer.alpha           = 0 *  pi/180;
control.sprayer.beta            = 0 *  pi/180;

%% simulation
sim.dt                          = 0.5;

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
                          cos(param.sprayer.alphaInit);
                      
sprayer.kinkY           = sprayer.hitchY - ...
                          param.sprayer.l2 * ...
                          sin(param.sprayer.alphaInit);

sprayer.axisX           = sprayer.kinkX - ...
                          param.sprayer.l3 * ...
                          cos(param.sprayer.betaInit);

sprayer.axisY           = sprayer.kinkY - ...
                          param.sprayer.l3 * ...
                          sin(param.sprayer.betaInit);
                      
sprayer.psi             = tan(...
                          (sprayer.hitchY - sprayer.kinkY)/...
                          (sprayer.hitchX - sprayer.kinkX));
                      
animationInit();
animationTractor(tractor);
animationSprayer(sprayer);
                      
%% calculation

for i = 1:4
    [tractor, sprayer] = singleStep(param, control, sim, tractor, sprayer);
end

hold off
                      
                      
                      
                      
                      
                      
                      


