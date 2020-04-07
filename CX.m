%works out the aerodynamic x-axis force coefficient 

function [output] = CX(ALPHA,EL)    %PERFECT

data=...
[-0.099,-0.081,-0.081,-0.063,-0.025, 0.044, 0.097, 0.113, 0.145, 0.167, 0.174, 0.166;...
 -0.048,-0.038,-0.040,-0.021, 0.016, 0.083, 0.127, 0.137, 0.162, 0.177, 0.179, 0.167;...
 -0.022,-0.020,-0.021,-0.004, 0.032, 0.094, 0.128, 0.130, 0.154, 0.161, 0.155, 0.138;...
 -0.040,-0.038,-0.039,-0.025, 0.006, 0.062, 0.087, 0.085, 0.100, 0.110, 0.104, 0.091;...
 -0.083,-0.073,-0.076,-0.072,-0.046, 0.012, 0.024, 0.025, 0.043, 0.053, 0.047, 0.040];

%x=linspace(0.2.*(-2),0.2.*9,12);
%y=linspace(-2./12,2./12,5);
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

S=EL./12.0;         %Switch from EL to vertical lookup parameter
M=int8(S);          %find index of the nearest data point

if (M<=-2)          %find index of the nearest INNER data point (M)
    M=-1;
elseif (M>=2)
    M=1;
end

DE=S-single(M);     %find direction to the other neighbouring data point
N=M+int8(sign(DE)); %find index of the latter data point (N)

%--------------------------------------------------------------------------

T=data(M+3,K+3);         %find the nearest CFx inner data point
U=data(N+3,K+3);         %find the next nearest CFx inner data point

V= T + abs(DA).*(data(M+3,L+3) - T);   %linear interpolate between (K L) on (M)
W= U + abs(DA).*(data(N+3,L+3) - U);   %linear interpolate between (K L) on (N)

output=V + (W-V).*abs(DE);   %linear interpolate between (V W)