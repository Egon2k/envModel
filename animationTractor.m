function animationTractor(tractor)
    plot( tractor.frontX, tractor.frontY, 'ro');     % front axis
    plot([tractor.frontX tractor.rearX], ...
         [tractor.frontY tractor.rearY], 'r');      % wheelbase line
    plot( tractor.rearX,  tractor.rearY,  'rx');     % rear axis
    plot([tractor.rearX tractor.hitchX], ...
         [tractor.rearY tractor.hitchY], 'b');      % hitch line
    plot( tractor.hitchX, tractor.hitchY, 'b*');     % hitch
end