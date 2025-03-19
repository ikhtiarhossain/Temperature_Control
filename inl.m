%v1= 10;
%v2= 12;
%vr= 2;
v1 = 0.010;  % m3
v2 = 0.012; % m3
vr = 0.002; % m3

q= 0.001; % m3/s
rho= 997;
cap= 4.2;

a= (v1*v2)/(q^2);
b= (v1+v2)/(q);
c= 1;
ku= (1)/(rho*cap*q);
kuu= (5.166)/(rho*cap*q);
kv= 1;
L = 1;
s=tf('s');
G=(ku*exp(-L*s)/(a*s^2+b*s+c)) + exp(-L*s)/(a*s^2+b*s+c);
G1=(ku*exp(-L*s)/(a*s^2+b*s+c));
G2=(kuu*exp(-L*s)/(a*s^2+b*s+c));
step(G1,G)
ylabel('Temperature C\circ');
%legend('', 'Ku + Kv','Location','SouthEast')
%s=stepinfo((G1));
%bp = bodeplot(G1);
%Gd=c2d(G1,1);
%step(G1,'b',Gd,'r')
%Tk = 13.68*0.0151;
%Ti = 7.38;
%Td = 1.84;
%PID =(Tk*(1+(1/(Ti*s)) + Td*s));
Tk = 13.68*0.0151;
Ti = 5;
Td = 1;
PID =(Tk*(1+(1/(Ti*s)) + Td*s));
bode(PID)
comb = PID*G1;
closed_comb = feedback(comb,1);
%step(closed_comb)
%margin(comb)