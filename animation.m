function animation(flag, control, tractor, sprayer)
% S-function animaiton using the figure command
% Autor: Christian Fröschle
% =============================================================
switch flag,
  case 0,                                                
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
           lineSprayerDrawbar ...
           lineSprayer;

    figure(1)
    axis([-43 43 -45 5]);
    hold on;
    
    lineTractor        = line('LineWidth',2,'Color','red');
    lineTractorHitch   = line('LineWidth',2,'Color','black');
    lineTractorSteer   = line('LineWidth',2,'Color','black');
    lineSprayerDrawbar = line('LineWidth',2,'Color','cyan');
    lineSprayer        = line('LineWidth',2,'Color','cyan');
end

function animationTractor(control, tractor)
    global lineTractor ...
           lineTractorHitch ...
           lineTractorSteer;
    
    xData = [tractor.frontX, tractor.rearX];
    yData = [tractor.frontY, tractor.rearY];
    set(lineTractor,'xData',xData,'yData',yData);
    
    xData = [tractor.rearX, tractor.hitchX];
    yData = [tractor.rearY, tractor.hitchY];
    set(lineTractorHitch,'xData',xData,'yData',yData);
    
    xData = [tractor.frontX, tractor.frontX + cos(tractor.psi + control.tractor.steeringAngle)*1];
    yData = [tractor.frontY, tractor.frontY + sin(tractor.psi + control.tractor.steeringAngle)*1];
    set(lineTractorSteer,'xData',xData,'yData',yData);
    
    
%     plot( tractor.frontX, tractor.frontY, 'ro');     % front axis
%     plot([tractor.frontX tractor.rearX], ...
%          [tractor.frontY tractor.rearY], 'r');      % wheelbase line
     plot( tractor.rearX,  tractor.rearY,  'ro');     % rear axis
%     plot([tractor.rearX tractor.hitchX], ...
%          [tractor.rearY tractor.hitchY], 'b');      % hitch line
%     plot( tractor.hitchX, tractor.hitchY, 'b*');     % hitch
end


function animationSprayer(control, sprayer)
    global lineSprayerDrawbar lineSprayer;

    xData = [sprayer.hitchX, sprayer.kinkX];
    yData = [sprayer.hitchY, sprayer.kinkY];
    set(lineSprayerDrawbar,'xData',xData,'yData',yData);
    
    xData = [sprayer.kinkX, sprayer.axisX];
    yData = [sprayer.kinkY, sprayer.axisY];
    set(lineSprayer,'xData',xData,'yData',yData);    


%     plot([sprayer.hitchX sprayer.kinkX], ...
%          [sprayer.hitchY sprayer.kinkY], 'g');      % drawbar line
%     plot( sprayer.kinkX, sprayer.kinkY,  'go');     % kink
%     plot([sprayer.kinkX  sprayer.axisX], ...
%          [sprayer.kinkY  sprayer.axisY], 'g');      % rear part line
     plot( sprayer.axisX, sprayer.axisY, 'co');      % sprayer axis
end

