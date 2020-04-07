function [] =CONSTR(X)

global AIL; 
global EL; 
global RDR; 
global THTL;

global RADGAM;
global SINGAM;
global RR;
global PR;
global TR;
global PHI;
global CPHI;
global SPHI;

CALPH = cos(X(2));
SALPH = sin(X(2));
CBETA = cos(X(3));
SBETA = sin(X(3));

X(4) = PHI;
D = X(2);
if (PHI~=0.0)
    D=-X(2);        %inverted
end
if (SINGAM~=0.0)    %climbing
    SGOBC = SINGAM./CBETA;
    X(5) = D + atan(SGOCB./sqrt(1.0-SGOCB.^2));
else
    X(5) = D;
end
X(7)=RR;
X(8)=PR;
X(9)=0.0;