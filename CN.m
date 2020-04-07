%works out the aerodynamic yawing moment coefficient 

function [output] = CN(ALPHA,BETA)

data=...
[0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000;...
 0.018, 0.019, 0.018, 0.019, 0.019, 0.018, 0.013, 0.007, 0.004,-0.014,-0.017,-0.033;...
 0.038, 0.042, 0.042, 0.042, 0.043, 0.039, 0.030, 0.017, 0.004,-0.035,-0.047,-0.057;...
 0.056, 0.057, 0.059, 0.058, 0.058, 0.053, 0.032, 0.012, 0.002,-0.046,-0.071,-0.073;...
 0.064, 0.077, 0.076, 0.074, 0.073, 0.057, 0.029, 0.007, 0.012,-0.034,-0.065,-0.041;...
 0.074, 0.086, 0.093, 0.089, 0.080, 0.062, 0.049, 0.022, 0.028,-0.012,-0.002,-0.013;...
 0.079, 0.090, 0.106, 0.106, 0.096, 0.080, 0.068, 0.030, 0.064, 0.015, 0.011,-0.001];

%x=linspace(0.2.*(-2),0.2.*9,12);
%y=linspace(0.2*0,0.2*5,7);
%[x,y]=meshgrid(x,y);
%surf(x,y,data)

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

S=0.2.*abs(BETA);         %Switch from EL to vertical lookup parameter
M=int8(S);          %find index of the nearest data point

if (M<=0)          %find index of the nearest INNER data point (M)
    M=1;
elseif (M>=6)
    M=5;
end

DB=S-single(M);     %find direction to the other neighbouring data point
N=M+int8(sign(DB)); %find index of the latter data point (N)

%--------------------------------------------------------------------------

T=data(M+1,K+3);         %find the nearest CFx inner data point
U=data(N+1,K+3);         %find the next nearest CFx inner data point

V= T + abs(DA).*(data(M+1,L+3) - T);   %linear interpolate between (K L) on (M)
W= U + abs(DA).*(data(N+1,L+3) - U);   %linear interpolate between (K L) on (N)

output=(V + (W-V).*abs(DB)).*sign(BETA);   %linear interpolate between (V W)