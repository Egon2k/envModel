function [ out ] = epsCheck( in )
    if in <= eps
        out = 0;
    else
        out = in;
    end
end

