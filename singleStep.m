function [tractorOut, sprayerOut] = singleStep(param, control, sim, tractor, sprayer)
    %% helper
    deltaS = control.tractor.frontWheelV * sim.dt;
    
    dPsiTractor = asin(deltaS * sin(pi - control.tractor.steeringAngle) / param.tractor.wheelbase);
    
    dpsiSprayer = asin(param.tractor.hitchLength * sin(dPsiTractor) / param.sprayer.l2);
    
    phi0 = tractor.psi - sprayer.psi;
    
    x = sqrt(param.sprayer.l2^2 + param.sprayer.l3^2 ...
             - 2 * param.sprayer.l2 * param.sprayer.l3 ...
             * cos(pi - control.sprayer.alpha));

    %% calculation
    
    % tractor
   
    tractor.psi = tractor.psi + dPsiTractor;
    
    %front
    tractor.frontX = tractor.frontX + ...
                     deltaS * cos(control.tractor.steeringAngle + tractor.psi);
                 
    tractor.frontY = tractor.frontY + ...
                     deltaS * sin(control.tractor.steeringAngle + tractor.psi);
    
    % rear
    tractor.rearX = tractor.frontX - ...
                    param.tractor.wheelbase * ...
                    cos(tractor.psi);
    tractor.rearY = tractor.frontY - ...
                    param.tractor.wheelbase * ...
                    sin(tractor.psi);

    % hitch
    tractor.hitchX = tractor.rearX - ...
                     param.tractor.hitchLength * ...
                     cos(tractor.psi);
    tractor.hitchY = tractor.rearY - ...
                     param.tractor.hitchLength * ...
                     sin(tractor.psi); 
    
    % sprayer
    diagSprayer = sqrt(param.sprayer.l2^2 + param.sprayer.l3^2 ...
                       - 2 * param.sprayer.l2 * param.sprayer.l3 ...
                       * cos(control.sprayer.beta));
                   
                   
    % straigt through kink (kinkX, kinkX) and axis (axisX, axisY)
    A = [sprayer.kinkX 1; sprayer.axisX 1];
    b = [sprayer.kinkY  ; sprayer.axisY  ];

    result = A\b;

    m = result(1);
    c = result(2);
    
    % cycle with hitch_new as center (hitchX, hitchY) and 
    % radius diagSprayer
    % formula: (x - x0)^2 + (y - y0)^2 = r^2
    
    if 1
        sprayer.axisX = (tractor.hitchX + (- c^2 - 2*c*tractor.hitchX*m + 2*c*tractor.hitchY - tractor.hitchX^2*m^2 + 2*tractor.hitchX*tractor.hitchY*m - tractor.hitchY^2 + m^2*diagSprayer^2 + diagSprayer^2)^(1/2) - c*m + tractor.hitchY*m)/(m^2 + 1);
        sprayer.axisY = (c + tractor.hitchX*m + tractor.hitchY*m^2 + m*(- c^2 - 2*c*tractor.hitchX*m + 2*c*tractor.hitchY - tractor.hitchX^2*m^2 + 2*tractor.hitchX*tractor.hitchY*m - tractor.hitchY^2 + m^2*diagSprayer^2 + diagSprayer^2)^(1/2))/(m^2 + 1);
    else
        sprayer.axisX = (tractor.hitchX - (- c^2 - 2*c*tractor.hitchX*m + 2*c*tractor.hitchY - tractor.hitchX^2*m^2 + 2*tractor.hitchX*tractor.hitchY*m - tractor.hitchY^2 + m^2*diagSprayer^2 + diagSprayer^2)^(1/2) - c*m + tractor.hitchY*m)/(m^2 + 1);
        sprayer.axisY = (c + tractor.hitchX*m + tractor.hitchY*m^2 - m*(- c^2 - 2*c*tractor.hitchX*m + 2*c*tractor.hitchY - tractor.hitchX^2*m^2 + 2*tractor.hitchX*tractor.hitchY*m - tractor.hitchY^2 + m^2*diagSprayer^2 + diagSprayer^2)^(1/2))/(m^2 + 1);
    end
     
    
%     min = 100;
%     winkel = 0;
%     strecke = 0;   
%     
%     for i = -pi/2:pi/100:pi/2
%         for j = -10:0.1:10
%             if sprayer.hitchX + diagSprayer * sin(i + sprayer.psi) - ...
%                sprayer.axisX + j * sin(sprayer.psi + ...
%                control.sprayer.alpha +  control.sprayer.beta) < min
%                     min = sprayer.hitchX + diagSprayer * sin(i + sprayer.psi) - ...
%                           sprayer.axisX - j * sin(sprayer.psi + ...
%                           control.sprayer.alpha +  control.sprayer.beta);
%                     winkel = i;
%                     strecke = j;
%             end
%        end
%     end
    
%     sprayer.axisX = sprayer.hitchX - diagSprayer * sin(i + sprayer.psi);
%     sprayer.axisY = sprayer.hitchY + diagSprayer * cos(i + sprayer.psi);
    
    sprayer.kinkX = sprayer.axisX;
    sprayer.kinkY = sprayer.axisY;
    
    sprayer.hitchX = tractor.hitchX;
    sprayer.hitchY = tractor.hitchY;
    
%     deltaHitch = sqrt((tractor.hitchX - sprayer.hitchX)^2 + ...
%                       (tractor.hitchY - sprayer.hitchY)^2 );
%                                 
%     hitchAngle = tan((tractor.hitchY - sprayer.hitchY) / ...
%                      (tractor.hitchX - sprayer.hitchX) );
%                  
%         
%     dpsiSprayer = asin(deltaHitch * sin(pi - hitchAngle) / param.sprayer.l2);
%                       
%     sprayer.psi = sprayer.psi + dpsiSprayer;
%     
%     sprayer.hitchX = tractor.hitchX;
%     
%     sprayer.hitchY = tractor.hitchY;
% 
%     sprayer.kinkX = sprayer.hitchX - ...
%                     param.sprayer.l2 * ...
%                     cos(sprayer.psi);
%                       
%     sprayer.kinkY = sprayer.hitchY - ...
%                     param.sprayer.l2 * ...
%                     sin(sprayer.psi);
% 
%                 
%     sprayer.axisX = sprayer.hitchX - ...
%                     x * cos(sprayer.psi);
% 
%     sprayer.axisY = sprayer.hitchY - ...
%                     x * sin(sprayer.psi);
                
    %% plot

    animationTractor(tractor);
    animationSprayer(sprayer);
    
    %% set outputs
    
    tractorOut = tractor;
    sprayerOut = sprayer;
end
