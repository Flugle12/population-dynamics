clear; clf; clc;

F_0 = 2000000;
t_0 = 0;
t_n = 50;
dt = 0.1;
t = t_0 : dt : t_n;

function F = malthus_model(t, F_0, R, D)
    F = F_0*exp((R-D)*t);
endfunction

// D = 0; r > 0
R1 = 0.1
D1= 0;
F1 = malthus_model(t, F_0, R1, D1);

// D, R > 0, D > R

R2 = 0.05;
D2 = 0.1;
F2 = malthus_model(t, F_0, R2, D2);

// D, R > 0, D < R
R3 = 0.1;
D3 = 0.05;
F3 = malthus_model(t, F_0, R3, D3);

//D,R > 0, D = R
R4 = 0.05;
D4 = 0.05;
F4 = malthus_model(t, F_0, R4, D4);

// All Graphs in 1
figure(1);
plot(t, F1, 'g-', 'LineWidth', 3);
plot(t, F2, 'r-', 'LineWidth', 3);
plot(t, F3, 'b-', 'LineWidth', 3);
plot(t, F4, 'k-', 'LineWidth', 3);

xlabel('time, t', 'fontsize', 3);
ylabel('Number of population, F(t)', 'fontsize', 3);
title('Comparison of all Malthus model scenarios', 'fontsize', 4);
legend(['D=0, R>0 (R=' + string(R1) + ')'; 
        'D>R (R=' + string(R2) + ', D=' + string(D2) + ')';
        'D<R (R=' + string(R3) + ', D=' + string(D3) + ')';
        'D=R (R=' + string(R4) + ', D=' + string(D4) + ')'], 1);
xgrid;

// Graph 2: separate graphs
figure(2);
subplot(2,2,1);
plot(t, F1, 'g-', 'LineWidth', 2);
title('D = 0, R > 0', 'fontsize', 3);
xlabel('Время, t', 'fontsize', 2);
ylabel('F(t)', 'fontsize', 2);
xgrid;
legend('O(e^n)', 2);

subplot(2,2,2);
plot(t, F2, 'r-', 'LineWidth', 2);
title('D > R', 'fontsize', 3);
xlabel('time, t', 'fontsize', 2);
ylabel('F(t)', 'fontsize', 2);
xgrid;
legend('exponent dying', 1);

subplot(2,2,3);
plot(t, F3, 'b-', 'LineWidth', 2);
title('D < R', 'fontsize', 3);
xlabel('time, t', 'fontsize', 2);
ylabel('F(t)', 'fontsize', 2);
xgrid;
legend('growth taking into account mortality', 2);

subplot(2,2,4);
plot(t, F4, 'k-', 'LineWidth', 2);
title('D = R', 'fontsize', 3);
xlabel('time, t', 'fontsize', 2);
ylabel('F(t)', 'fontsize', 2);
xgrid;
legend('stable', 1);
