%% This equations calculate alpha and beta when you drive in a cycle with a given radius R

R = 16.93/2;
l1 = 0.72;
l2 = 5.5;


Rh = sqrt(R^2 + l1^2);

gamma = acos((Rh^2-l2^2-R^2)/(-2*l2*R));

beta = (pi/2 - gamma)*180/pi

delta1 = acos((R^2-Rh^2-l2^2)/(-2*l2*R));
delta2 = asin(R/Rh);

alpha = (pi - (delta1 + delta2))*180/pi