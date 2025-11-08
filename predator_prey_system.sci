clear; clf; clc;

x0 = 1e6;  
y0 = 1e6;  

t_start = 0;
t_end = 50;
dt = 0.1;
t = t_start:dt:t_end;

function dydt = predator_prey_system(t, y, R, P1, P2, D)
    x = y(1);
    y_pred = y(2);
    
    dxdt = R * x - P1 * x * y_pred;
    
    dydt_pred = P2 * x * y_pred - D * y_pred;
    
    dydt = [dxdt; dydt_pred];
endfunction

function analyze_predator_prey_points(R, P1, P2, D)
    printf("=== АНАЛИЗ СТАЦИОНАРНЫХ ТОЧЕК ===\n");
    
    printf("Точка 1: (0, 0)\n");
    printf("  Обе популяции вымерли\n");
    
    x_star = D / P2;
    y_star = R / P1;
    printf("Точка 2: (%.0f, %.0f)\n", x_star, y_star);
    printf("  Стационарное сосуществование\n");
    printf("  Равновесные численности:\n");
    printf("    Жертвы: %.0f\n", x_star);
    printf("    Хищники: %.0f\n", y_star);
    

    printf("\nАНАЛИЗ УСТОЙЧИВОСТИ:\n");
    printf("Матрица Якоби в точке (%.0f, %.0f):\n", x_star, y_star);
    J11 = R - P1 * y_star;
    J12 = -P1 * x_star;
    J21 = P2 * y_star;
    J22 = P2 * x_star - D;
    
    printf("[%.4f, %.4f]\n", J11, J12);
    printf("[%.4f, %.4f]\n", J21, J22);
    
    // Собственные значения
    trace_J = J11 + J22;
    det_J = J11 * J22 - J12 * J21;
    
    printf("След матрицы: %.4f\n", trace_J);
    printf("Определитель: %.4f\n", det_J);
    
    // Для точки сосуществования в классической модели Лотки-Вольтерры
    // след = 0, определитель > 0 -> центр (нейтрально устойчивый)
    if abs(trace_J) < 1e-10 & det_J > 0 then
        printf("Тип точки: ЦЕНТР (нейтрально устойчивый)\n");
        printf("Популяции будут колебаться вокруг этой точки\n");
    elseif trace_J < 0 & det_J > 0 then
        printf("Тип точки: УСТОЙЧИВЫЙ ФОКУС\n");
        printf("Популяции будут затухать к равновесию\n");
    elseif trace_J > 0 & det_J > 0 then
        printf("Тип точки: НЕУСТОЙЧИВЫЙ ФОКУС\n");
        printf("Популяции будут расходиться от равновесия\n");
    else
        printf("Тип точки: СЕДЛО (неустойчиво)\n");
    end
    
    printf("\nПЕРИОД КОЛЕБАНИЙ (приближенно):\n");
    if det_J > 0 then
        T = 2 * %pi / sqrt(det_J);
        printf("T ≈ %.2f единиц времени\n", T);
    end
endfunction

// =============================================
// 4. РАЗЛИЧНЫЕ СЦЕНАРИИ ВЗАИМОДЕЙСТВИЯ
// =============================================

scenarios = [
    "Классические колебания", 
    "Быстрый рост хищников", 
    "Вымирание хищников",
    "Сильные колебания",
    "Стабилизация"
];

// Параметры для каждого сценария
params = [
// R,   P1,    P2,    D,    сценарий
  0.1,  1e-6,  1e-6,  0.05, 1;    // Классические колебания
  0.1,  1e-6,  2e-6,  0.05, 2;    // Быстрый рост хищников
  0.05, 1e-6,  1e-6,  0.1,  3;    // Вымирание хищников
  0.2,  2e-6,  2e-6,  0.1,  4;    // Сильные колебания
  0.08, 1e-6,  1e-6,  0.08, 5     // Стабилизация
];

solutions = list();

for i = 1:size(params, 1)
    R = params(i, 1); P1 = params(i, 2);
    P2 = params(i, 3); D = params(i, 4);
    scenario = params(i, 5);
    
    printf("\n=== СЦЕНАРИЙ %d: %s ===\n", i, scenarios(scenario));
    printf("Параметры: R=%.2f, P1=%.1e, P2=%.1e, D=%.2f\n", R, P1, P2, D);
    
    analyze_predator_prey_points(R, P1, P2, D);
    
    y0_vec = [x0; y0];
    t0 = 0;
    y_sol = ode(y0_vec, t0, t, list(predator_prey_system, R, P1, P2, D));
    
    solutions(i) = struct('t', t, 'x', y_sol(1,:), 'y', y_sol(2,:), ...
                         'params', [R, P1, P2, D], ...
                         'scenario', scenarios(scenario));
    
    x_mean = mean(y_sol(1,:));
    y_mean = mean(y_sol(2,:));
    x_amplitude = max(y_sol(1,:)) - min(y_sol(1,:));
    y_amplitude = max(y_sol(2,:)) - min(y_sol(2,:));
    
    printf("\nСТАТИСТИКА КОЛЕБАНИЙ:\n");
    printf("Средняя численность жертв: %.0f\n", x_mean);
    printf("Средняя численность хищников: %.0f\n", y_mean);
    printf("Амплитуда жертв: %.0f\n", x_amplitude);
    printf("Амплитуда хищников: %.0f\n", y_amplitude);
end

colors = ['b', 'r', 'g', 'm', 'c'];

figure(1);
for i = 1:length(solutions)
    sol = solutions(i);
    subplot(2,3,i);
    plot(sol.t, sol.x, colors(i)+'-', 'LineWidth', 2);
    plot(sol.t, sol.y, colors(i)+'--', 'LineWidth', 2);
    title(sol.scenario, 'fontsize', 3);
    xlabel('Время', 'fontsize', 2);
    ylabel('Численность', 'fontsize', 2);
    xgrid;
    legend(['Жертвы'; 'Хищники'], 1);
end

figure(2);
for i = 1:length(solutions)
    sol = solutions(i);
    subplot(2,3,i);
    plot(sol.x, sol.y, 'k-', 'LineWidth', 2);
    plot(sol.x(1), sol.y(1), 'go', 'MarkerSize', 6, 'LineWidth', 2);
    plot(sol.x($), sol.y($), 'ro', 'MarkerSize', 6, 'LineWidth', 2);
    
    R = sol.params(1); P1 = sol.params(2); P2 = sol.params(3); D = sol.params(4);
    x_star = D / P2;
    y_star = R / P1;
    plot(x_star, y_star, 'bx', 'MarkerSize', 8, 'LineWidth', 3);
    
    title('Фазовый портрет: '+sol.scenario, 'fontsize', 3);
    xlabel('Жертвы (x)', 'fontsize', 2);
    ylabel('Хищники (y)', 'fontsize', 2);
    xgrid;
end

figure(3);
for i = 1:length(solutions)
    sol = solutions(i);
    R = sol.params(1); P1 = sol.params(2); P2 = sol.params(3); D = sol.params(4);
    
    dxdt = R * sol.x - P1 * sol.x .* sol.y;
    dydt = P2 * sol.x .* sol.y - D * sol.y;
    
    subplot(2,3,i);
    plot(sol.t, dxdt, 'b-', 'LineWidth', 2);
    plot(sol.t, dydt, 'r-', 'LineWidth', 2);
    plot(sol.t, zeros(size(sol.t)), 'k:', 'LineWidth', 1);
    title('Скорости роста: '+sol.scenario, 'fontsize', 3);
    xlabel('Время', 'fontsize', 2);
    ylabel('dx/dt, dy/dt', 'fontsize', 2);
    xgrid;
    legend(['dx/dt (жертвы)'; 'dy/dt (хищники)'], 1);
end

printf("\n=== ДЕТАЛЬНЫЙ АНАЛИЗ КЛАССИЧЕСКОГО СЦЕНАРИЯ ===\n");

classic_sol = solutions(1);
R = classic_sol.params(1); P1 = classic_sol.params(2);
P2 = classic_sol.params(3); D = classic_sol.params(4);

[x_max, idx_x_max] = max(classic_sol.x);
[x_min, idx_x_min] = min(classic_sol.x);
[y_max, idx_y_max] = max(classic_sol.y);
[y_min, idx_y_min] = min(classic_sol.y);

printf("Жертвы: максимум = %.0f (t=%.1f), минимум = %.0f (t=%.1f)\n", ...
       x_max, classic_sol.t(idx_x_max), x_min, classic_sol.t(idx_x_min));
printf("Хищники: максимум = %.0f (t=%.1f), минимум = %.0f (t=%.1f)\n", ...
       y_max, classic_sol.t(idx_x_max), y_min, classic_sol.t(idx_x_min));


printf("\nФАЗОВЫЙ АНАЛИЗ:\n");

time_diff = classic_sol.t(idx_y_max) - classic_sol.t(idx_x_max);
printf("Сдвиг между максимумами: %.2f единиц времени\n", time_diff);
printf("Хищники отстают от жертв на %.1f%% периода\n", 100 * time_diff / (classic_sol.t($) - classic_sol.t(1)));

printf("\n=== АНАЛИЗ ВЛИЯНИЯ ПАРАМЕТРОВ ===\n");

D_values = [0.01, 0.05, 0.1, 0.2];
figure(4);

for j = 1:length(D_values)
    D_test = D_values(j);
    y_sol_test = ode([x0; y0], t0, t, list(predator_prey_system, R, P1, P2, D_test));
    
    subplot(2,2,j);
    plot(t, y_sol_test(1,:), 'b-', 'LineWidth', 2);
    plot(t, y_sol_test(2,:), 'r-', 'LineWidth', 2);
    title('Влияние D: D='+string(D_test), 'fontsize', 3);
    xlabel('Время', 'fontsize', 2);
    ylabel('Численность', 'fontsize', 2);
    xgrid;
    legend(['Жертвы'; 'Хищники'], 1);
    
    // Стационарная точка
    x_star_test = D_test / P2;
    y_star_test = R / P1;
    printf("D=%.2f: стационарная точка (%.0f, %.0f)\n", D_test, x_star_test, y_star_test);
end
