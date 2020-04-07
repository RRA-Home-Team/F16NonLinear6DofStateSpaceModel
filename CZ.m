%works out the aerodynamic z-axis force coefficient 

function [output] = CZ(ALPHA,BETA,EL)

data=...
[0.770 0.241,-0.100,-0.416,-0.731,-1.053,-1.366,-1.646,-1.917,-2.120,-2.248,-2.229];

%x=linspace(0.2.*(-2),0.2.*9,12);
%plot(x,data)

S=0.2.*ALPHA;       %Switch from ALPHA to horizontal lookup parameter
K=int8(S);          %find index of the nearest data point

if (K<=-2)           %find index of the nearest INNER data point (K)
    K=-1;            % X 0 0 0 0 0 0 0 0 0 0 X
elseif (K>=9)
    K=8;
end

DA=S-single(K);     %find direction to the other neighbouring data point
L=K+int8(sign(DA)); %find index of the latter data point (L)

%--------------------------------------------------------------------------

S= data(K+3) + abs(DA).*(data(L+3) - data(K+3));   %linear interpolate between (K L) on (M)

output=S.*(1-(BETA./57.3).^2) - 0.19.*(EL./25.0);