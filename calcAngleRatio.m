function [ factor ] = calcAngleRatio( alpha, l1, l2 )
% Calculates ratio between alpha and beta in a perfect cycle.
    if alpha ~= 0
        a = (l1.^2 + 2 .* l1 * l2 .* cos(alpha) + l2.^2) ./ ...
                  (2 .* (l1 + l2 .* cos(alpha)));

        beta = asin((a - l1) ./ a .* sin(alpha));

        factor = beta ./ alpha;
    else
        factor = 0;
    end
end

