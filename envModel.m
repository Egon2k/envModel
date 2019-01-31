clear all;
close all;
clc

%% parameter

param.tractor.steeringAngleInit = 0 * pi/180;
param.tractor.wheelbase         = 6;                % [m]
param.tractor.hitchLength       = 0.72;             % [m]
param.tractor.psiInit           = 0 * pi/180;

param.sprayer.l2                = 5.5;              % {m]
param.sprayer.l3                = 3;                % {m]

param.sprayer.alphaInit         = 0 * pi/180;
param.sprayer.betaInit          = -10 * pi/180;

param.sprayer.psiInit           = 0 * pi/180;

%% control

control.tractor.steeringAngle   = 20 * pi/180;
control.tractor.frontWheelV     = 10;                % [m/s]
control.sprayer.beta            = 10 *  pi/180;

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
                          cos(param.sprayer.alphaInit + param.sprayer.psiInit);
                      
sprayer.kinkY           = sprayer.hitchY - ...
                          param.sprayer.l2 * ...
                          sin(param.sprayer.alphaInit + param.sprayer.psiInit);

sprayer.axisX           = sprayer.kinkX - ...
                          param.sprayer.l3 * ...
                          cos(param.sprayer.betaInit + param.sprayer.psiInit);

sprayer.axisY           = sprayer.kinkY - ...
                          param.sprayer.l3 * ...
                          sin(param.sprayer.betaInit + param.sprayer.psiInit);
                      
sprayer.psi             = tan(...
                          (sprayer.hitchY - sprayer.kinkY)/...
                          (sprayer.hitchX - sprayer.kinkX));
                      
sprayer.alpha           = param.sprayer.alphaInit;
                      
animationInit();
animationTractor(tractor);
animationSprayer(sprayer);
                      
%% calculation

for i = 1:2
    [tractor, sprayer] = singleStep(param, control, sim, tractor, sprayer);
end


                      
                      
                      
                      
                      
                      
                      


