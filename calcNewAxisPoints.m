syms x;
syms y;

% line
syms m;
syms c;

% cycle
syms r;
syms hX;
syms hY;

if 0
	y = m*x + c;
    %r^2 = (x - hX)^2 + (y - hY)^2;

    x = solve(r^2 == (x - hX)^2 + (y - hY)^2,'x')
else
    x = (y - c)/m;
    %r^2 = (x - hX)^2 + (y - hY)^2;

    y = solve(r^2 == (x - hX)^2 + (y - hY)^2,'y')
end