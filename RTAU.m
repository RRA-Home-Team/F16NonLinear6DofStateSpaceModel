function [output] = RTAU(DP)

if (DP<=25.0)
    output=1.0;
elseif (DP>=50)
    output=0.1;
else
    output=1.9-0.036.*DP;
end