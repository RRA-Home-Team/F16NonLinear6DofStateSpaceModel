function [output] = TGEAR(THTL)

%Power command vs. throttle relationship

if (THTL<=0.77)
    output = 64.94.*THTL;
else
    output = 217.38.*THTL-117.38;   %after burner???
end