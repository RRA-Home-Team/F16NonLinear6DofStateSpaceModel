%works out the rolling moment due to ailerons

function [output] = DLDA(ALPHA,BETA)

data=...
[-.041,-0.052,-0.053,-0.056,-0.050,-0.056,-0.082,-0.059,-0.042,-0.038,-0.027,-0.017;...
-0.041,-0.053,-0.053,-0.053,-0.050,-0.051,-0.066,-0.043,-0.038,-0.027,-0.023,-0.016;...
-0.042,-0.053,-0.052,-0.051,-0.049,-0.049,-0.043,-0.035,-0.026,-0.016,-0.018,-0.014;...
-0.040,-0.052,-0.051,-0.052,-0.048,-0.048,-0.042,-0.037,-0.031,-0.026,-0.017,-0.012;...
-0.043,-0.049,-0.048,-0.049,-0.043,-0.042,-0.042,-0.036,-0.025,-0.021,-0.016,-0.011;...
-0.044,-0.048,-0.048,-0.047,-0.042,-0.041,-0.020,-0.028,-0.013,-0.014,-0.011,-0.010;...
-0.043,-0.049,-0.047,-0.045,-0.042,-0.037,-0.003,-0.013,-0.010,-0.003,-0.007,-0.008];

%x=linspace(0.2.*(-2),0.2.*9,12);
%y=linspace(0.1*-3,0.1*3,7);
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

S=0.1.*BETA;         %Switch from EL to vertical lookup parameter
M=int8(S);          %find index of the nearest data point

if (M<=-3)          %find index of the nearest INNER data point (M)
    M=-2;
elseif (M>=3)
    M=2;
end

DB=S-single(M);     %find direction to the other neighbouring data point
N=M+int8(sign(DB)); %find index of the latter data point (N)

%--------------------------------------------------------------------------

T=data(M+4,K+3);         %find the nearest CFx inner data point
U=data(N+4,K+3);         %find the next nearest CFx inner data point

V= T + abs(DA).*(data(M+4,L+3) - T);   %linear interpolate between (K L) on (M)
W= U + abs(DA).*(data(N+4,L+3) - U);   %linear interpolate between (K L) on (N)

output= V + (W-V).*abs(DB);   %linear interpolate between (V W)