function animationSprayer(sprayer)
%     plot([sprayer.hitchX sprayer.kinkX], ...
%          [sprayer.hitchY sprayer.kinkY], 'g');      % drawbar line
%     plot( sprayer.kinkX, sprayer.kinkY,  'go');     % kink
%     plot([sprayer.kinkX  sprayer.axisX], ...
%          [sprayer.kinkY  sprayer.axisY], 'g');      % 
%     plot( sprayer.axisX, sprayer.axisY, 'g*');      % sprayer axis

    plot([sprayer.hitchX sprayer.axisX], ...
         [sprayer.hitchY sprayer.axisY], 'g');      % drawbar line
    plot( sprayer.axisX, sprayer.axisY, 'g*');      % sprayer axis

end