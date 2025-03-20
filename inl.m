
s=tf('s');

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
%kuu= (5.166)/(rho*cap*q);
kv= 1;
L = 2;

%G=(ku*exp(-L*s)/(a*s^2+b*s+c)) + exp(-L*s)/(a*s^2+b*s+c);
G1=(ku*exp(-L*s)/(a*s^2+b*s+c));
%G2=(kuu*exp(-L*s)/(a*s^2+b*s+c));
%step(G1,G)
%ylabel('Temperature C\circ');
%legend('', 'Ku + Kv','Location','SouthEast')
%s=stepinfo((G1));
%bp = bodeplot(G1);
%OLD Tk = 13.68*0.0151;
%OLD Ti = 7.38;
%OLD Td = 1.84;
%OLD PID =(Tk*(1+(1/(Ti*s)) + Td*s));
%Tk = 13.68*0.265;
%Ti = 12.5;
%Td = 3;
%PID =(Tk*(1+(1/(Ti*s)) + Td*s));
%bode(PID)
%comb = PID*G1;
%closed_comb = feedback(comb,1);
%step(closed_comb)
%margin(comb)

Gd=c2d(G1,1);
step(G1,'b',Gd,'r')

Gd;
A = Gd.Denominator{1}
B = Gd.Numerator{1}
P = [1, -0.4, 0.04];

% P = AC + BD
syms c1 d0 d1
eqn1 = A(2) + c1 + B(2)*d0 == P(2);
eqn2 = A(3) + A(2)*c1 + B(2)*d1 + B(3)*d0 == P(3);
eqn3 = A(3)*c1 + B(3)*d1 == 0;
sol = solve([eqn1, eqn2, eqn3], [c1, d0, d1]);
C = double([1, sol.c1]);
D = double([sol.d0, sol.d1]);
Kr = sum(P) / sum (B);

na = 2;
nb = 2;
nc = 1;
nd = 1;

N = 50;
r = ones(1, N); % r(k) = 1 (step signal)
u = zeros(1, N);
y = zeros(1, N);

for k = 1:N
    if k > max([na, nb, nc, nd])
        y(k) = -sum(A(2:end) .* y(k-1:-1:k-na)) + sum(B(2:end) .* u(k-1:-1:k-nb));
        % U(Z)C(z) = KrR(z) - D(z)Y(z)
        u(k) = (Kr * r(k-nc) - sum(D(2:end) .* y(k-1:-1:k-nd)) - sum(C(2:end) .* u(k-1:-1:k-nc))) / C(1);
    end
end

% Plot
figure;
subplot(2,1,1);
stem(0:N-1, y, 'filled');
title('Output Y(k)');
xlabel('Sample number (k)'); ylabel('Output Y'); grid;

subplot(2,1,2);
stem(0:N-1, u, 'filled');
title('Control Signal u(k)');
xlabel('Sample number (k)'); ylabel('Control signal u'); grid;