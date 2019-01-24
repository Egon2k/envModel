clear all
clc

%% parameter

param.tractor.frontWheelV       = 2;                % [m/s]
param.tractor.steeringAngleInit = 0 * pi/180;
param.tractor.wheelbase         = 6;                % [m]
param.tractor.hitchLength       = 0.72;             % [m]
param.tractor.psiInit           = 0 * pi/180;

param.sprayer.l2                = 5.5;              % {m]
param.sprayer.l3                = 0;                % {m]

param.sprayer.alphaInit         = 0 * pi/180;
param.sprayer.betaInit          = 0 * pi/180;

%% init

% tractor
tractor.frontX          = 0;
tractor.frontY          = 0;

tractor.rearX           = tractor.frontX + ...
                          param.tractor.wheelbase * ...
                          sin(param.tractor.psiInit);
tractor.rearY           = tractor.frontY + ...
                          param.tractor.wheelbase * ...
                          cos(param.tractor.psiInit);


tractor.hitchX          = tractor.rearX + ...
                          param.tractor.hitchLength * ...
                          sin(param.tractor.psiInit);
tractor.hitchY          = tractor.rearY + ...
                          param.tractor.hitchLength * ...
                          cos(param.tractor.psiInit);

% sprayer
sprayer.kinkX           = tractor.hitchX + ...
                          param.sprayer.l2 * ...
                          sin(param.sprayer.alphaInit);
                      
sprayer.kinkY           = tractor.hitchY + ...
                          param.sprayer.l2 * ...
                          cos(param.sprayer.alphaInit);

sprayer.axisX           = sprayer.kinkX + ...
                          param.sprayer.l3 * ...
                          sin(param.sprayer.betaInit);

sprayer.axisY           = sprayer.kinkY + ...
                          param.sprayer.l3 * ...
                          cos(param.sprayer.betaInit);

animationInit();
animationTractor(tractor);
animationSprayer(sprayer);

                      
%% calculation

singleStep(tractor,sprayer);

                      
                      
                      
                      
                      
                      
                      


