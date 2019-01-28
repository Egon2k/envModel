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
    deltaHitch = sqrt((tractor.hitchX - sprayer.hitchX)^2 + ...
                      (tractor.hitchY - sprayer.hitchY)^2 );
                                
    hitchAngle = tan((tractor.hitchY - sprayer.hitchY) / ...
                     (tractor.hitchX - sprayer.hitchX) );
                 
        
    dpsiSprayer = asin(deltaHitch * sin(pi - hitchAngle) / param.sprayer.l2);
                      
    sprayer.psi = sprayer.psi + dpsiSprayer;
    
    sprayer.hitchX = tractor.hitchX;
    
    sprayer.hitchY = tractor.hitchY;

    sprayer.kinkX = sprayer.hitchX - ...
                    param.sprayer.l2 * ...
                    cos(sprayer.psi);
                      
    sprayer.kinkY = sprayer.hitchY - ...
                    param.sprayer.l2 * ...
                    sin(sprayer.psi);

                
    sprayer.axisX = sprayer.hitchX - ...
                    x * cos(sprayer.psi);

    sprayer.axisY = sprayer.hitchY - ...
                    x * sin(sprayer.psi);
                
    %% plot

    animationTractor(tractor);
    animationSprayer(sprayer);
    
    %% set outputs
    
    tractorOut = tractor;
    sprayerOut = sprayer;
end
