function [AMACH,QBAR]=ADC(VT,ALT)   %air data computer

%this m-file is perfect. DO NOT TOUCH IT!!!

R0=2.377E-3;                    %Sea Level Air Density
TFAC=1.0-(0.703E-5).*ALT;       %I.S.A. parameter????
T=519.0*TFAC;                   %Air Temperature
if ALT >= 35000.0
    T=390;
end
RHO=R0*(TFAC.^4.14);            %Air Density
AMACH=VT/sqrt(1.4*1716.3*T);    %Mach Number        (2.2-3)
QBAR=0.5.*RHO.*VT.*VT;          %Dynamic Pressure   (2.2-1)
PS= 1715.0.*RHO.*T;             %Static Pressure