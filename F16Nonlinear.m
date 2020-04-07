%**************************************************************************
%****  An F-16 Model from "Aircraft Control & Simulation" by D.McCabe  ****
%**************************************************************************

function XD = F16Nonlinear(t,X)

global AIL; 
global EL; 
global RDR; 
global THTL;

global XCG;

XD=zeros(13,1);

%+--------------+--------------------------------------+------------------+
%|  Var         |   Description:                       |    Units         |
%+--------------+--------------------------------------+------------------+
%| VT=X(1)      |   Airframe total air velocity        |    m/s           | 
%| ALPHA=X(2)   |   Angle of Attack                    |    rad           | 
%| BETA=X(3)    |   Angle of Sideslip                  |    rad           | 
%| PHI=X(4)     |   Roll Angle                         |    rad           |
%| THETA=X(5)   |   Pitch Angle                        |    rad           |
%| PSI=X(6)     |   Yaw Angle                          |    rad           |
%| P=X(7)       |   Roll Rate                          |    rad/s         |
%| Q=X(8)       |   Pitch Rate                         |    rad/s         | 
%| R=X(9)       |   Yaw Rate                           |    rad/s         |
%| xEarth=X(10) |   Earth Cartesian x coordinate       |    m             |
%| yEarth=X(11) |   Earth Cartesian y coordinate       |    m             |
%| ALT=X(12)    |   Earth Cartesian z coordinate       |    m             |
%| POW=X(13)    |   Power Level                        |    %             |
%+--------------+--------------------------------------+------------------+
%| AIL=U(1)     |   Aileron Deflection Angle           |    rad           |
%| THETA=U(2)   |   Pitch Angle                        |    rad           |
%| PSI=U(3)     |   Yaw Angle                          |    rad           |
%+--------------+--------------------------------------+------------------+

Ixx=  9496.0;
Iyy= 55814.0;
Izz= 61300.0;   
Ixz=   982.0;   

IxzS =  Ixz.^2;
XPQ =   Ixz.*(Ixx-Iyy+Izz);
GAM =   Ixx.*Izz-Ixz.^2;
XQR =   Izz.*(Izz-Iyy)+IxzS;
ZPQ =   (Ixx-Iyy)*Ixx+IxzS;
YPR =   Izz-Ixx;

WEIGHT= 20490.446;
GD=     32.17;
MASS=   WEIGHT./GD;
S=      300;                    %Wing Area             
B=      30;                     %Wing Span
CBAR=   11.32;                  %Mean Wing Chord
XCGR=   0.35;                   %x-axis centre of gravity***
HX=     160;                    %something to do with engine

RTOD= 57.29578;

%Assign State & Control Variables:

    VT=X(1); ALPHA=X(2).*RTOD; BETA=X(3).*RTOD; PHI=X(4); THETA=X(5);
    PSI=X(6); P=X(7); Q=X(8); R=X(9); xEarth=X(10); yEarth=X(11);
    ALT=X(12); POW=X(13);

    [AMACH,QBAR]=ADC(VT,ALT);   %atmosphere computer
    CPOW=TGEAR(THTL);
    XD(13)=PDOT(POW,CPOW);
    T=THRUST(POW,ALT,AMACH);    %thrust force

%Look-up tables and component buildup:

    CXT= CX(ALPHA,EL);          %aerodynamic x force per area
    CYT= CY(BETA,AIL,RDR);      %aerodynamic y force per area
    CZT= CZ(ALPHA,BETA,EL);     %aerodynamic z force per area

    DAIL= AIL./20.0; DRDR= RDR./30.0;

    
    CLT= CL(ALPHA,BETA) + DLDA(ALPHA,BETA).*DAIL + DLDR(ALPHA,BETA).*DRDR;
    CMT= CM(ALPHA,EL);
    CNT= CN(ALPHA,BETA) + DNDA(ALPHA,BETA).*DAIL + DNDR(ALPHA,BETA).*DRDR;

%Add damping derivatives:
    
    TVT= 0.5./VT; B2V= B.*TVT;  CQ= CBAR.*Q.*TVT;
    D= DAMP(ALPHA);
    CXT=CXT+CQ*D(1);
    CYT=CYT+B2V.*(D(2).*R+D(3).*P);
    CZT=CZT+CQ.*D(4);
    CLT=CLT+B2V.*(D(5).*R+D(6).*P);
    CMT=CMT+CQ.*D(7)+CZT.*(XCGR-XCG);
    CNT=CNT+B2V.*(D(8).*R+D(9).*P)-CYT.*(XCGR-XCG).*CBAR./B;

%Get ready for state equations

    CBTA=cos(X(3));     U=VT.*cos(X(2)).*CBTA;
    V=VT.*sin(X(3));    W=VT.*sin(X(2)).*CBTA;
    
    STH=sin(THETA);     CTH=cos(THETA);     SPH=sin(PHI);
    CPH=cos(PHI);       SPSI=sin(PSI);      CPSI=cos(PSI);
    QS=QBAR.*S;         QSB=QS.*B;          RMQS=QS./MASS;
    GCTH=GD.*CTH;       QSPH=Q.*SPH;
    AY=RMQS.*CYT;       AZ=RMQS.*CZT;
    
%Force equations

    UDOT = R.*V - Q.*W - GD.*STH + (QS.*CXT+T)./MASS;
    VDOT = P.*W - R.*U + GCTH.*SPH + AY;
    WDOT = Q.*U - P.*V + GCTH.*CPH + AZ;
    DUM = (U.^2 + W.^2);
    
    XD(1) = (U.*UDOT + V.*VDOT + W.*WDOT)./VT;
    XD(2) = (U.*WDOT - W.*UDOT)./DUM;
    XD(3) = (VT*VDOT - V.*XD(1)).*CBTA./DUM;
    
%Kinematics

    XD(4) = P + (STH./CTH).*(QSPH + R.*CPH);
    XD(5) = Q.*CPH - R.*SPH;
    XD(6) = (QSPH + R.*CPH)./CTH;
    
%Moments

    ROLL =  QSB.*CLT;
    PITCH = QS.*CBAR.*CMT;
    YAW =   QSB.*CNT;
    PQ =    P.*Q;
    QR =    Q.*R;
    QHX =   Q.*HX;
    
    XD(7)= (XPQ*PQ -XQR.*QR + Izz.*ROLL + Ixz.*(YAW + QHX))./GAM;
    XD(8)= (YPR.*P.*R - Ixz.*(P.^2 - R.^2) + PITCH - R.*HX)./Iyy;
    XD(9)= (ZPQ.*PQ - XPQ.*QR + Ixz.*ROLL + Ixx.*(YAW + QHX))./GAM;
    
%Navigation

    T1= SPH.*CPSI;  T2= CPH.*STH;   T3= SPH.*SPSI;
    S1= CTH.*CPSI;  S2= CTH.*SPSI;  S3= T1.*STH - CPH.*SPSI;
    S4= T3.*STH +CPH.*CPSI;     S5=SPH.*CTH;    S6= T2.*CPSI + T3;
    S7= T2.*SPSI - T1;      S8= CPH.*CTH;
    
    XD(10)= U.*S1 + V.*S3 + W.*S6;
    XD(11)= U.*S2 + V.*S4 + W.*S7;
    XD(12)= U.*STH - V.*S5 - W.*S8;