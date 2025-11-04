clear; clf; clc;

x_0 = 1e6;
R = 0.1;
t_0 = 0;
t_n = 150;
dt = 0.1;
t = t_0 : dt : t_n;

function x = verhulst_model(t, x_0, R, k)
    numer = k * x_0 * exp(R * t);
    denom = k - x_0 + x_0 * exp(R * t);
    x = numer ./ denom;
endfunction

// x_0 < k
k1 = 5e6;
x1 = verhulst_model(t, x_0, R, k1);

// x_0 > k
k2 = 0.5e6;
x2 = verhulst_model(t, x_0, R, k2);

// x_0 == k
k3 = 1e6;
x3 = verhulst_model(t, x_0, R, k3);

// Graph 1
figure(1);
plot(t, x1, 'g-', 'LineWidth', 3);
plot(t, x2, 'r-', 'LineWidth', 3);
plot(t, x3, 'b-', 'LineWidth', 3);

plot([t_0, t_n], [k1, k1], 'g--', 'LineWidth', 1);
plot([t_0, t_n], [k2, k2], 'r--', 'LineWidth', 1);
plot([t_0, t_n], [k3, k3], 'b--', 'LineWidth', 1);

xlabel('time, t', 'fontsize', 3);
ylabel('number of population, x(t)', 'fontsize', 3);
title('Verhulst Model (Logistic Growth)', 'fontsize', 4);
legend(['x₀ < k (x₀=' + string(x_0) + ', k=' + string(k1) + ')';
        'x₀ > k (x₀=' + string(x_0) + ', k=' + string(k2) + ')'; 
        'x₀ = k (x₀=' + string(x_0) + ', k=' + string(k3) + ')';
        'k for x₀ < k';
        'k for x₀ > k';
        'k for x₀ = k'], 1);
xgrid;

// Graph 2
figure(2);
subplot(2,2,1);
plot(t, x1, 'g-', 'LineWidth', 2);
plot([t_0, t_n], [k1, k1], 'g--', 'LineWidth', 1);
plot([t_0, t_n], [k1/2, k1/2], 'g:', 'LineWidth', 1);
title('Scenario 1: x₀ < k', 'fontsize', 3);
xlabel('time, t', 'fontsize', 2);
ylabel('x(t)', 'fontsize', 2);
xgrid;
legend(['Population'; 'Capacity k'; 'Inflection point'], 4);

subplot(2,2,2);
plot(t, x2, 'r-', 'LineWidth', 2);
plot([t_0, t_n], [k2, k2], 'r--', 'LineWidth', 1);
plot([t_0, t_n], [k2/2, k2/2], 'r:', 'LineWidth', 1);
title('Scenario 2: x₀ > k', 'fontsize', 3);
xlabel('time, t', 'fontsize', 2);
ylabel('x(t)', 'fontsize', 2);
xgrid;
legend(['Population'; 'Capacity k'; 'Inflection point'], 1);

subplot(2,2,3);
plot(t, x3, 'b-', 'LineWidth', 2);
plot([t_0, t_n], [k3, k3], 'b--', 'LineWidth', 1);
title('Scenario 3: x₀ = k', 'fontsize', 3);
xlabel('time, t', 'fontsize', 2);
ylabel('x(t)', 'fontsize', 2);
xgrid;
legend(['Population'; 'Capacity k'], 1);

// Graph 4
subplot(2,2,4);
dx1 = R * x1 .* (1 - x1/k1);
dx2 = R * x2 .* (1 - x2/k2);
dx3 = R * x3 .* (1 - x3/k3);

plot(t, dx1, 'g-', 'LineWidth', 2);
plot(t, dx2, 'r-', 'LineWidth', 2);
plot(t, dx3, 'b-', 'LineWidth', 2);
title('Growth Rate dx/dt', 'fontsize', 3);
xlabel('time, t', 'fontsize', 2);
ylabel('dx/dt', 'fontsize', 2);
xgrid;
legend(['x₀ < k'; 'x₀ > k'; 'x₀ = k'], 1);
