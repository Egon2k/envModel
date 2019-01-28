function animationSprayer(sprayer)
    plot([sprayer.hitchX sprayer.kinkX], ...
         [sprayer.hitchY sprayer.kinkY], 'g');      % drawbar line
    plot( sprayer.kinkX, sprayer.kinkY,  'go');     % kink
    plot([sprayer.kinkX  sprayer.axisX], ...
         [sprayer.kinkY  sprayer.axisY], 'g');      % rear part line
    plot( sprayer.axisX, sprayer.axisY, 'g*');      % sprayer axis
end