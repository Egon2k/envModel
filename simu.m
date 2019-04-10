clear all


%% simulation
sim.dt                          = 0.1;              % sampling rate in [s]
sim.T                           = 10;               % simulated time in [s]

% tractor parameter
param.tractor.steeringAngleInit = 0;
param.tractor.wheelbase         = 6;                % [m]
param.tractor.hitchLength       = 0.72;             % [m]
param.tractor.psiInit           = 0;


%% sprayer parameter
param.sprayer.l2                = 5.5;              % {m]
param.sprayer.l3                = 0;                % {m]

figure(2)
clf;
figure(3)
clf;
pause(0.001);


for iterateAlpha = -30:10:30
    index = 1;
    
    param.sprayer.alphaInit         = iterateAlpha * pi/180;       % angle between tractor and sprayer
    param.sprayer.betaInit          = -10 * pi/180;       % kink angle
    param.sprayer.psiInit           = 10 * pi/180;
    
    for steering = -45:1:45
        % control
        control.tractor.steeringAngle   = steering*pi/180;
        control.tractor.frontWheelV     = 10;           % [m/s]
        control.sprayer.beta            = param.sprayer.betaInit;

        figure(1);
        clf;
        distance = 0;

        %% init
        [tractor, sprayer] = initStep(param);
        animation(0, control, tractor, sprayer);

        hitchXold = tractor.hitchX;
        hitchYold = tractor.hitchY;

        %% calculation
        for i = 1:(sim.T/sim.dt)
            [tractor, sprayer] = singleStep(param, control, sim, tractor, sprayer);
            animation(1, control, tractor, sprayer);

            distance = distance + sprayer.ds;

            if (distance > 0.2)
                break;
            end

            %pause(sim.dt/2);
        end

        % calculate the distance the hitch traveled
        x(index) = steering;
        hitchDistance(index) = sqrt((tractor.hitchX - hitchXold)^2 + ...
                                (tractor.hitchY - hitchYold)^2);
        hitchDirection(index) = atan2d((tractor.hitchY - hitchYold), ...
                                   (tractor.hitchX - hitchXold));
        distarray(index) = distance;

        index = index + 1;

        figure(2);
        hold on;
        plot(x,hitchDistance,'r');
        plot(x,distarray,'b');

        figure(3);
        hold on;
        plot(x,hitchDirection,'g.');

        fprintf('#');
    end
    
    fprintf('\n');
    pause(0.001);
end

figure(3)
fittingCurve = polyfit(x,hitchDirection,5)
plot(x,polyval(fittingCurve,x));
%fprintf('%d * x^3 + %d * x^2 + %d * x^1 + %d\n', fittingCurve(4), fittingCurve(3), fittingCurve(2), fittingCurve(1));
