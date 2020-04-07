%Fly F-16

clear all
clc

global AIL; 
global EL; 
global RDR; 
global THTL;

global XCG;

global X


tspan=[0,1000];

Trim

options = odeset('RelTol',1e-3,'MaxStep',0.2);

%AIL=-1.2e-7;
%THTL=0.1385;
%EL=-0.7588;
%RDR=6.2E-7;
%XCG=0.35;

%X(1)=502;
%X(2)=0.03691;
%X(3)=-4.0e-9;
%X(4)=0;
%X(5)=0.03691;
%X(6)=0.0;
%X(7)=0.0;
%X(8)=0.0;

[t,Y] = ode45(@F16Nonlinear,tspan,X);
[tt,Z] = ode15s(@F16Nonlinear,tspan,X);

figure(100)
plot3(Y(:,10),Y(:,11),Y(:,12),'LineWidth',3)
grid on
axis([-8000,88000,-8000,88000,-8000,88000])

figure(1)
plot(t,Y(:,1),tt,Z(:,1),'LineWidth',0.9)
title('\bf True Airspeed vs Time')
ylabel('True Airspeed (ft/sec)')
xlabel('time (sec)')

figure(2)
plot(t,Y(:,2),tt,Z(:,2),'LineWidth',0.9)
title('\bf Angle of Attack vs Time')
ylabel('Angle of Attack (rad)')
xlabel('time (sec)')

figure(3)
plot(t,Y(:,3),tt,Z(:,3),'LineWidth',0.9)
title('\bf Angle of Sideslip vs Time')
ylabel('Angle of Sideslip (rad)')
xlabel('time (sec)')

figure(4)
plot(t,Y(:,4),tt,Z(:,4),'LineWidth',0.9)
title('\bf Bank Angle vs Time')
ylabel('Bank Angle (rad)')
xlabel('time (sec)')

figure(5)
plot(t,Y(:,5),tt,Z(:,5),'LineWidth',0.9)
title('\bf Pull-Up Angle vs Time')
ylabel('Pull-Up Angle (rad)')
xlabel('time (sec)')

figure(6)
plot(t,Y(:,6),tt,Z(:,6),'LineWidth',0.9)
title('\bf Yaw Angle vs Time')
ylabel('Yaw Angle (rad)')
xlabel('time (sec)')

figure(7)
plot(t,Y(:,7),tt,Z(:,7),'LineWidth',0.9)
title('\bf Roll Rate vs Time')
ylabel('Roll Rate (rad/s)')
xlabel('time (sec)')

figure(8)
plot(t,Y(:,8),tt,Z(:,8),'LineWidth',0.9)
title('\bf Pitch Rate vs Time')
ylabel('Pitch Rate (rad/s)')
xlabel('time (sec)')

figure(9)
plot(t,Y(:,9),tt,Z(:,9),'LineWidth',0.9)
title('\bf Yaw Rate vs Time')
ylabel('Yaw Rate (rad/s)')
xlabel('time (sec)')

figure(13)
plot(t,Y(:,13),tt,Z(:,13),'LineWidth',0.9)
title('\bf Engine Power vs Time')
ylabel('Thrust (lbs)')
xlabel('time (sec)')
                                        %   Check on p187

                                        %THTL=0.9;
                                        %EL=20.0;
                                        %AIL=-15.0;
                                        %RDR=-20.0;

                                        %y=[500;0.5;-0.2;-1;1;-1;0.7;-0.8;0.9;1000;900;10000;90];
                                        %y=F16Nonlinear(0,y)