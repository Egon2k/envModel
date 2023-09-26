function animation(flag, control, tractor, sprayer)
% S-function animaiton using the figure command
% Autor: Christian Fröschle
% =============================================================
ZOOM_LEVEL    =  20; % 0  = static view 
                    % >0 = activate follow-me mode
CENTER_TARGET =  2; % 1 [default] = center on tractors rear axis
                    % 2           = center on sprayers axis

figure(1);

if ZOOM_LEVEL ~= 0
    switch CENTER_TARGET
        case 1
            axis([tractor.rearX - ZOOM_LEVEL tractor.rearX + ZOOM_LEVEL ...
                  tractor.rearY - ZOOM_LEVEL tractor.rearY + ZOOM_LEVEL]);
        case 2
            axis([sprayer.axisX - ZOOM_LEVEL sprayer.axisX + ZOOM_LEVEL ...
                  sprayer.axisY - ZOOM_LEVEL sprayer.axisY + ZOOM_LEVEL]);
        otherwise
            axis([tractor.rearX - ZOOM_LEVEL tractor.rearX + ZOOM_LEVEL ...
                  tractor.rearY - ZOOM_LEVEL tractor.rearY + ZOOM_LEVEL]);
    end
end

switch flag,
  case 0,
    if ZOOM_LEVEL == 0
        axis([-25 40 -50 15]);
    end
    animationInit();
    animationTractor(control, tractor);
    animationSprayer(control, sprayer);
  case 1,
    animationTractor(control, tractor);
    animationSprayer(control, sprayer);
  otherwise
    error(['unhandled flag = ',num2str(flag)]);
end
end


function animationInit()
    global lineTractor ...
           lineTractorHitch ...
           lineTractorSteer ...
           lineTractorRearAxle ...
           lineSprayerDrawbar ...
           lineSprayer ...
           lineSprayerAxle;

    axis square;
    hold on;

    lineTractor        = line('LineWidth',2,'Color','red');
    lineTractorHitch   = line('LineWidth',2,'Color','black');
    lineTractorSteer   = line('LineWidth',2,'Color','black');
    lineTractorRearAxle = line('LineWidth',2,'Color','green');
    lineSprayerDrawbar = line('LineWidth',2,'Color','cyan');
    lineSprayer        = line('LineWidth',2,'Color','cyan');
    lineSprayerAxle    = line('LineWidth',2,'Color','green');
    
end

function animationTractor(control, tractor)
	global lineTractor ...
           lineTractorHitch ...
           lineTractorSteer ...
           lineTractorRearAxle;

    xData = [tractor.frontX, tractor.rearX];
    yData = [tractor.frontY, tractor.rearY];
    set(lineTractor,'xData',xData,'yData',yData);
 
    xData = [tractor.rearX, tractor.hitchX];
    yData = [tractor.rearY, tractor.hitchY];
    set(lineTractorHitch,'xData',xData,'yData',yData);
    
    xData = [tractor.rearLeftX, tractor.rearRightX];
    yData = [tractor.rearLeftY, tractor.rearRightY];
    set(lineTractorRearAxle,'xData',xData,'yData',yData);
    
    xData = [tractor.frontX, tractor.frontX + cos(tractor.psi + control.tractor.steeringAngle)*1];
    yData = [tractor.frontY, tractor.frontY + sin(tractor.psi + control.tractor.steeringAngle)*1];
    set(lineTractorSteer,'xData',xData,'yData',yData);

%     plot( tractor.frontX, tractor.frontY, 'ro');     % front axis
%     plot([tractor.frontX tractor.rearX], ...
%          [tractor.frontY tractor.rearY], 'r');      % wheelbase line
%     plot( tractor.rearX,  tractor.rearY,  'ro');     % rear axis
%     plot([tractor.rearX tractor.hitchX], ...
%          [tractor.rearY tractor.hitchY], 'b');      % hitch line
%     plot( tractor.hitchX, tractor.hitchY, 'b*');     % hitch

      plot( tractor.rearLeftX, tractor.rearLeftY, 'ro');     % rear left
      plot( tractor.rearRightX, tractor.rearRightY, 'ro');     % rear left
end


function animationSprayer(control, sprayer)
    global lineSprayerDrawbar ...
           lineSprayer ...
           lineSprayerAxle;

    xData = [sprayer.hitchX, sprayer.kinkX];
    yData = [sprayer.hitchY, sprayer.kinkY];
    set(lineSprayerDrawbar,'xData',xData,'yData',yData);

    xData = [sprayer.kinkX, sprayer.axisX];
    yData = [sprayer.kinkY, sprayer.axisY];
    set(lineSprayer,'xData',xData,'yData',yData);
    
    xData = [sprayer.rearLeftX, sprayer.rearRightX];
    yData = [sprayer.rearLeftY, sprayer.rearRightY];
    set(lineSprayerAxle,'xData',xData,'yData',yData);
    
    
    %xData = [sprayer.hitchX, sprayer.hitchX - 10 * cos(sprayer.psi + sprayer.alpha + control.sprayer.beta)];
    %yData = [sprayer.hitchY, sprayer.hitchY - 10 * sin(sprayer.psi + sprayer.alpha + control.sprayer.beta)];
    %set(lineSprayerReplace,'xData',xData,'yData',yData);
    

%     plot([sprayer.hitchX sprayer.kinkX], ...
%          [sprayer.hitchY sprayer.kinkY], 'g');      % drawbar line
%     plot( sprayer.kinkX, sprayer.kinkY,  'go');     % kink
%     plot([sprayer.kinkX  sprayer.axisX], ...
%          [sprayer.kinkY  sprayer.axisY], 'g');      % rear part line
%     plot( sprayer.axisX, sprayer.axisY, 'co');      % sprayer axis
      plot( sprayer.rearLeftX, sprayer.rearLeftY, 'co');     % rear left
      plot( sprayer.rearRightX, sprayer.rearRightY, 'co');     % rear left
end

