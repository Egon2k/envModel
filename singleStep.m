function [tractorOut, sprayerOut] = singleStep(param, control, sim, tractor, sprayer)
    %% helper
    deltaS = control.tractor.frontWheelV * sim.dt;
    
    dPsiTractor = asin(deltaS * sin(pi - control.tractor.steeringAngle) / param.tractor.wheelbase);
    
%     dpsiSprayer = asin(param.tractor.hitchLength * sin(dPsiTractor) / param.sprayer.l2);
%     
%     phi0 = tractor.psi - sprayer.psi;
 
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
    
    % diagonal plane between old axis and old hitch position
    diagSprayer = sqrt(param.sprayer.l2^2 + param.sprayer.l3^2 ...
                       - 2 * param.sprayer.l2 * param.sprayer.l3 ...
                       * cos(pi - control.sprayer.beta));
    
    tau1 =  epsCheck(asin(param.sprayer.l3 * sin(pi - control.sprayer.beta) / diagSprayer));
    tau2 =  epsCheck(asin(param.sprayer.l2 * sin(pi - control.sprayer.beta) / diagSprayer));
                   
    % straight through kink (kinkX, kinkX) and axis (axisX, axisY)
    if (sprayer.kinkX == sprayer.axisX && sprayer.kinkY == sprayer.axisY)
        % special case, when l3 = 0
        
        % calculate slope m from beta
        betaGlobal = sprayer.psi;% + control.sprayer.alpha + control.sprayer.beta;
        
        if (mod(betaGlobal,pi) > pi/2)
        	m = mod(betaGlobal,pi/2)/(pi/2);
        else
            m = -mod(betaGlobal,pi/2)/(pi/2);
        end
        c = sprayer.axisY;
    else
        % l3 > 0
        A = [sprayer.kinkX 1; sprayer.axisX 1];
        b = [sprayer.kinkY  ; sprayer.axisY  ];
        
        result = A\b;       % solving the linear system

        m = result(1);      % slope
        c = result(2);      % y-intercept
    end
    

    
    % cycle with hitch_new as center (hitchX, hitchY) and radius diagSprayer
    % formula: (x - x0)^2 + (y - y0)^2 = r^2
    x(1) = (tractor.hitchX + (- c^2 - 2*c*tractor.hitchX*m + 2*c*tractor.hitchY - tractor.hitchX^2*m^2 + 2*tractor.hitchX*tractor.hitchY*m - tractor.hitchY^2 + m^2*diagSprayer^2 + diagSprayer^2)^(1/2) - c*m + tractor.hitchY*m)/(m^2 + 1);
    x(2) = (tractor.hitchX - (- c^2 - 2*c*tractor.hitchX*m + 2*c*tractor.hitchY - tractor.hitchX^2*m^2 + 2*tractor.hitchX*tractor.hitchY*m - tractor.hitchY^2 + m^2*diagSprayer^2 + diagSprayer^2)^(1/2) - c*m + tractor.hitchY*m)/(m^2 + 1);
    
    y(1) = (c + tractor.hitchX*m + tractor.hitchY*m^2 + m*(- c^2 - 2*c*tractor.hitchX*m + 2*c*tractor.hitchY - tractor.hitchX^2*m^2 + 2*tractor.hitchX*tractor.hitchY*m - tractor.hitchY^2 + m^2*diagSprayer^2 + diagSprayer^2)^(1/2))/(m^2 + 1);
    y(2) = (c + tractor.hitchX*m + tractor.hitchY*m^2 - m*(- c^2 - 2*c*tractor.hitchX*m + 2*c*tractor.hitchY - tractor.hitchX^2*m^2 + 2*tractor.hitchX*tractor.hitchY*m - tractor.hitchY^2 + m^2*diagSprayer^2 + diagSprayer^2)^(1/2))/(m^2 + 1);
    
    if (sqrt((sprayer.axisX - x(1)) + (sprayer.axisY - y(1))^2) > ...
        sqrt((sprayer.axisX - x(2)) + (sprayer.axisY - y(2))^2))
        
        sprayer.axisX = x(1);
        sprayer.axisY = y(1);
    else
        sprayer.axisX = x(2);
        sprayer.axisY = y(2);
    end
    
    sprayer.hitchX = tractor.hitchX;
    sprayer.hitchY = tractor.hitchY;
    
    diagAngle = tan((sprayer.axisY - sprayer.hitchY) / ...
                    (sprayer.axisX - sprayer.hitchX));
        
    sprayer.kinkX = sprayer.hitchX - param.sprayer.l2 * cos(diagAngle + tau1);
    sprayer.kinkY = sprayer.hitchY - param.sprayer.l2 * sin(diagAngle + tau1);
    
    sprayer.psi = tan((sprayer.axisY - sprayer.kinkY) / ...
                      (sprayer.axisX - sprayer.kinkX));
        
    %% plot

    animationTractor(tractor);
    animationSprayer(sprayer);
    
    %% set outputs
    
    tractorOut = tractor;
    sprayerOut = sprayer;
end
