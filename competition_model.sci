clear; clf; clc;

x0 = 1e6;
y0 = 1e6;

t_start = 0;
t_end = 100;
dt = 0.1;
t = t_start:dt:t_end;

function dydt = competition_model(t, y, R1, R2, k1, k2, alpha, beta)
    x = y(1);
    y_pop = y(2);
    
    dxdt = R1 * x * (k1 - x - alpha * y_pop) / k1;
    dydt_pop = R2 * y_pop * (k2 - y_pop - beta * x) / k2;
    
    dydt = [dxdt; dydt_pop];
endfunction

R1_1 = 0.1; R2_1 = 0.1;
k1_1 = 3e6; k2_1 = 3e6;
alpha_1 = 0.5; beta_1 = 0.5;

R1_2 = 0.1; R2_2 = 0.1;
k1_2 = 3e6; k2_2 = 3e6;
alpha_2 = 0.8; beta_2 = 1.2;

R1_3 = 0.1; R2_3 = 0.1;
k1_3 = 3e6; k2_3 = 3e6;
alpha_3 = 1.2; beta_3 = 0.8;

R1_4 = 0.15; R2_4 = 0.08;
k1_4 = 3e6; k2_4 = 3e6;
alpha_4 = 0.7; beta_4 = 0.9;

y0_vec = [x0; y0];
t0 = 0;
y1 = ode(y0_vec, t0, t, list(competition_model, R1_1, R2_1, k1_1, k2_1, alpha_1, beta_1));
x1 = y1(1,:);
y1_pop = y1(2,:);

y2 = ode(y0_vec, t0, t, list(competition_model, R1_2, R2_2, k1_2, k2_2, alpha_2, beta_2));
x2 = y2(1,:);
y2_pop = y2(2,:);

y3 = ode(y0_vec, t0, t, list(competition_model, R1_3, R2_3, k1_3, k2_3, alpha_3, beta_3));
x3 = y3(1,:);
y3_pop = y3(2,:);

y4 = ode(y0_vec, t0, t, list(competition_model, R1_4, R2_4, k1_4, k2_4, alpha_4, beta_4));
x4 = y4(1,:);
y4_pop = y4(2,:);

figure(1);

subplot(2,2,1);
plot(t, x1, 'b-', 'LineWidth', 2);
plot(t, y1_pop, 'r-', 'LineWidth', 2);
title('Сценарий 1: Сосуществование', 'fontsize', 3);
xlabel('Время', 'fontsize', 2);
ylabel('Численность', 'fontsize', 2);
xgrid;
legend(['Популяция x'; 'Популяция y'], 1);

subplot(2,2,2);
plot(t, x2, 'b-', 'LineWidth', 2);
plot(t, y2_pop, 'r-', 'LineWidth', 2);
title('Сценарий 2: Выигрывает x', 'fontsize', 3);
xlabel('Время', 'fontsize', 2);
ylabel('Численность', 'fontsize', 2);
xgrid;
legend(['Популяция x'; 'Популяция y'], 1);

subplot(2,2,3);
plot(t, x3, 'b-', 'LineWidth', 2);
plot(t, y3_pop, 'r-', 'LineWidth', 2);
title('Сценарий 3: Выигрывает y', 'fontsize', 3);
xlabel('Время', 'fontsize', 2);
ylabel('Численность', 'fontsize', 2);
xgrid;
legend(['Популяция x'; 'Популяция y'], 1);

subplot(2,2,4);
plot(t, x4, 'b-', 'LineWidth', 2);
plot(t, y4_pop, 'r-', 'LineWidth', 2);
title('Сценарий 4: Разные темпы роста', 'fontsize', 3);
xlabel('Время', 'fontsize', 2);
ylabel('Численность', 'fontsize', 2);
xgrid;
legend(['Популяция x'; 'Популяция y'], 1);

// График 2: Фазовые портреты
figure(2);

subplot(2,2,1);
plot(x1, y1_pop, 'k-', 'LineWidth', 2);
plot(x1(1), y1_pop(1), 'go', 'MarkerSize', 8, 'LineWidth', 2);
plot(x1($), y1_pop($), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
title('Фазовый портрет: Сосуществование', 'fontsize', 3);
xlabel('Популяция x', 'fontsize', 2);
ylabel('Популяция y', 'fontsize', 2);
xgrid;

subplot(2,2,2);
plot(x2, y2_pop, 'k-', 'LineWidth', 2);
plot(x2(1), y2_pop(1), 'go', 'MarkerSize', 8, 'LineWidth', 2);
plot(x2($), y2_pop($), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
title('Фазовый портрет: Выигрывает x', 'fontsize', 3);
xlabel('Популяция x', 'fontsize', 2);
ylabel('Популяция y', 'fontsize', 2);
xgrid;

subplot(2,2,3);
plot(x3, y3_pop, 'k-', 'LineWidth', 2);
plot(x3(1), y3_pop(1), 'go', 'MarkerSize', 8, 'LineWidth', 2);
plot(x3($), y3_pop($), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
title('Фазовый портрет: Выигрывает y', 'fontsize', 3);
xlabel('Популяция x', 'fontsize', 2);
ylabel('Популяция y', 'fontsize', 2);
xgrid;

subplot(2,2,4);
plot(x4, y4_pop, 'k-', 'LineWidth', 2);
plot(x4(1), y4_pop(1), 'go', 'MarkerSize', 8, 'LineWidth', 2);
plot(x4($), y4_pop($), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
title('Фазовый портрет: Разные темпы', 'fontsize', 3);
xlabel('Популяция x', 'fontsize', 2);
ylabel('Популяция y', 'fontsize', 2);
xgrid;

scenarios = [
    "Сосуществование", "Выигрывает x", "Выигрывает y", "Разные темпы роста"
];

for i = 1:4
    select i
    case 1
        x_final = x1($); y_final = y1_pop($);
        alpha = alpha_1; beta = beta_1;
    case 2
        x_final = x2($); y_final = y2_pop($);
        alpha = alpha_2; beta = beta_2;
    case 3
        x_final = x3($); y_final = y3_pop($);
        alpha = alpha_3; beta = beta_3;
    case 4
        x_final = x4($); y_final = y4_pop($);
        alpha = alpha_4; beta = beta_4;
    end
    
    disp(" ");
    disp("СЦЕНАРИЙ " + string(i) + ": " + scenarios(i));
    disp("Параметры: α = " + string(alpha) + ", β = " + string(beta));
    disp("Финальные численности:");
    disp("  Популяция x: " + string(round(x_final)));
    disp("  Популяция y: " + string(round(y_final)));
    
    // Анализ исхода конкуренции
    if x_final > 1000 & y_final > 1000 then
        disp("  Исход: Сосуществование");
    elseif x_final > 1000 & y_final <= 1000 then
        disp("  Исход: Выигрывает популяция x");
    elseif x_final <= 1000 & y_final > 1000 then
        disp("  Исход: Выигрывает популяция y");
    else
        disp("  Исход: Вымирание обеих популяций");
    end
end

disp(" ");
disp("УСЛОВИЯ СУЩЕСТВОВАНИЯ СТАЦИОНАРНЫХ ТОЧЕК:");
disp("Точка сосуществования существует при:");
disp("  α < k₁/k₂ и β < k₂/k₁");

for i = 1:4
    select i
    case 1
        k1 = k1_1; k2 = k2_1; alpha = alpha_1; beta = beta_1;
    case 2
        k1 = k1_2; k2 = k2_2; alpha = alpha_2; beta = beta_2;
    case 3
        k1 = k1_3; k2 = k2_3; alpha = alpha_3; beta = beta_3;
    case 4
        k1 = k1_4; k2 = k2_4; alpha = alpha_4; beta = beta_4;
    end
    
    condition1 = alpha < k1/k2;
    condition2 = beta < k2/k1;
    
    disp(" ");
    disp("Сценарий " + string(i) + ":");
    disp("  α < k₁/k₂: " + string(alpha) + " < " + string(k1/k2) + " = " + string(condition1));
    disp("  β < k₂/k₁: " + string(beta) + " < " + string(k2/k1) + " = " + string(condition2));
    
    if condition1 & condition2 then
        disp("  Обе условия выполнены → возможно сосуществование");
    else
        disp("  Условия не выполнены → конкурентное исключение");
    end
end
