%works out the rolling moment due to ailerons

function [output] = DNDR(ALPHA,BETA)

data=...
[-.018,-0.052,-0.052,-0.052,-0.054,-0.049,-0.059,-0.051,-0.030,-0.037,-0.026,-0.013;...
-0.028,-0.051,-0.043,-0.046,-0.045,-0.049,-0.057,-0.052,-0.030,-0.033,-0.030,-0.008;...
-0.037,-0.041,-0.038,-0.040,-0.040,-0.038,-0.037,-0.030,-0.027,-0.024,-0.019,-0.013;...
-0.048,-0.045,-0.045,-0.045,-0.044,-0.045,-0.047,-0.048,-0.049,-0.045,-0.033,-0.016;...
-0.043,-0.044,-0.041,-0.041,-0.040,-0.038,-0.034,-0.035,-0.035,-0.029,-0.022,-0.009;...
-0.052,-0.034,-0.036,-0.036,-0.035,-0.028,-0.024,-0.023,-0.020,-0.016,-0.010,-0.014;...
-0.062,-0.034,-0.027,-0.028,-0.027,-0.027,-0.023,-0.023,-0.019,-0.009,-0.025,-0.010];

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