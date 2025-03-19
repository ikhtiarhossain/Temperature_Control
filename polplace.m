% Coefficients:
A = [1, -1.825, 0.8325];
B = [0, 0.00094, 0.00088];
C = [1, -0.0917];
D = [-34.43, -7.478];
% Reference factor:
Kr = 351.65;
% Polynomial degrees:
na = length(A) - 1;
nb = length(B) - 1;
nc = length(C) - 1;
nd = length(D) - 1;

N = 100;
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