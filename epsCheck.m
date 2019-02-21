function [ out ] = epsCheck( in )
    if abs(in) <= eps
        out = 0;
    else
        out = in;
    end
end

