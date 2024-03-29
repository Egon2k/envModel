function [tractorOut, sprayerOut] = initStep(param)
    % tractor
    tractor.frontX          = 0;
    tractor.frontY          = 0;

    tractor.rearX           = tractor.frontX - ...
                              param.tractor.wheelbase * ...
                              cos(param.tractor.psiInit);
    tractor.rearY           = tractor.frontY - ...
                              param.tractor.wheelbase * ...
                              sin(param.tractor.psiInit);
                          
    tractor.rearLeftX       = tractor.rearX + ...
                              param.tractor.trackWidth/2 * ...
                              sin(param.tractor.psiInit);
    tractor.rearLeftY       = tractor.rearY + ...
                              param.tractor.trackWidth/2 * ...
                              cos(param.tractor.psiInit);
                          
    tractor.rearRightX      = tractor.rearX - ...
                              param.tractor.trackWidth/2 * ...
                              sin(param.tractor.psiInit);
    tractor.rearRightY      = tractor.rearY - ...
                              param.tractor.trackWidth/2 * ...
                              cos(param.tractor.psiInit);


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
                              cos(param.tractor.psiInit + param.sprayer.alphaInit);

    sprayer.kinkY           = sprayer.hitchY - ...
                              param.sprayer.l2 * ...
                              sin(param.tractor.psiInit + param.sprayer.alphaInit);

    sprayer.axisX           = sprayer.kinkX - ...
                              param.sprayer.l3 * ...
                              cos(param.tractor.psiInit + param.sprayer.alphaInit + param.sprayer.betaInit);

    sprayer.axisY           = sprayer.kinkY - ...
                              param.sprayer.l3 * ...
                              sin(param.tractor.psiInit + param.sprayer.alphaInit + param.sprayer.betaInit);

    sprayer.psi             = tan(...
                              (sprayer.hitchY - sprayer.kinkY)/...
                              (sprayer.hitchX - sprayer.kinkX));
                          
    sprayer.rearLeftX       = sprayer.axisX + ...
                              param.sprayer.trackWidth/2 * ...
                              cos(sprayer.psi + pi/2);
   
    sprayer.rearLeftY       = sprayer.axisY + ...
                              param.sprayer.trackWidth/2 * ...
                              sin(sprayer.psi + pi/2);
                
    sprayer.rearRightX      = sprayer.axisX - ...
                              param.sprayer.trackWidth/2 * ...
                              cos(sprayer.psi + pi/2);
   
    sprayer.rearRightY      = sprayer.axisY - ...
                              param.sprayer.trackWidth/2 * ...
                              sin(sprayer.psi + pi/2);

    sprayer.alpha           = param.sprayer.alphaInit;

    sprayer.dpsi            = 0;

    sprayer.ds              = 0;

    %% set outputs
    tractorOut = tractor;
    sprayerOut = sprayer;
end
