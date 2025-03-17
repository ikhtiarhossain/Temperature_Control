v1= 10;
v2= 12;
vr= 2;

q= 1;
rho= 997;
cap= 4200;

a= (v1*v2)/(q^2);
b= (v1*v2)/(q);
c= 1;
ku= (1)/(rho*cap*q);
kv= 1;
L = 1;
s=tf('s');
G=ku*exp(-L*s)/(a*s^2+b*s+c)
step(G)
s=stepinfo((G))