function lab2()
    X = [
        -13.40, -12.63, -13.65, -14.23, -13.39, -12.36, ...
        -13.52, -13.44, -13.87, -11.82, -12.01, -11.40, ...
        -13.02, -12.61, -13.06, -13.75, -13.55, -14.01, ...
        -11.75, -12.95, -12.59, -13.60, -12.76, -11.05, ...
        -13.15, -13.61, -11.73, -13.00, -12.66, -12.67, ...
        -12.60, -12.47, -13.52, -12.61, -11.93, -13.11, ...
        -13.22, -11.87, -13.44, -12.70, -11.78, -12.30, ...
        -12.89, -13.29, -12.48, -10.44, -12.55, -12.64, ...
        -12.03, -14.60, -14.56, -13.30, -11.32, -12.24, ...
        -11.17, -12.50, -13.25, -12.55, -12.85, -12.67, ...
        -12.41, -12.58, -12.10, -13.54, -12.69, -12.87, ...
        -12.71, -12.77, -13.30, -12.74, -12.73, -12.64, ...
        -12.18, -11.20, -12.40, -13.78, -13.71, -10.74, ...
        -11.89, -13.20, -11.31, -14.26, -10.38, -12.88, ...
        -11.39, -11.35, -12.55, -12.84, -10.25, -12.40, ...
        -14.01, -11.47, -13.14, -12.69, -11.92, -12.86, ...
        -13.06, -12.57, -13.63, -12.34, -12.84, -14.03, ...
        -13.34, -11.64, -13.58, -10.44, -11.37, -11.01, ...
        -13.80, -13.27, -12.32, -10.69, -12.92, -13.29, ...
        -12.58, -13.98, -11.46, -11.82, -12.33, -11.47, ...
    ];

    % Уровень доверия
    gamma = 0.9;

    % Объём выборки
    n = length(X);
    % Оценка мат. ожидания
    M = mean(X);
    % Оценка дисперсии
    D = var(X);

    % Границы доверительного интервала для мат. ожидания
    [M_lo, M_hi] = mean_bounds(X, gamma);
    % Границы доверительного интервала для дисперсии
    [D_lo, D_hi] = var_bounds(X, gamma);

    fprintf('mean     = %9.5f\n', M);
    fprintf('variance = %9.5f\n', D);

    fprintf('mean     in (%9.5f, %9.5f)\n', M_lo, M_hi);
    fprintf('variance in (%9.5f, %9.5f)\n', D_lo, D_hi);

    % Создание массивов точечных оценок и границ дов. интервалов
    M_pe    = zeros(1, n);
    D_pe    = zeros(1, n);
    M_pe_lo = zeros(1, n);
    M_pe_hi = zeros(1, n);
    D_pe_lo = zeros(1, n);
    D_pe_hi = zeros(1, n);

    % Заполнение созданных массивов
    for i = 1 : n
        M_pe(i) = mean(X(1:i));
        D_pe(i) = var(X(1:i));

        [M_pe_lo(i), M_pe_hi(i)] = mean_bounds(X(1:i), gamma);
        [D_pe_lo(i), D_pe_hi(i)] = var_bounds(X(1:i), gamma);
    end

    % Построение графиков
    subplot(2, 1, 1);
    plot(1 : n, [(zeros(1, n) + M)', M_pe', M_pe_lo', M_pe_hi']);
    xlabel('n');
    ylabel('y');
    legend('$\hat \mu(\vec x_N)$', '$\hat \mu(\vec x_n)$', ...
           '$\underline{\mu}(\vec x_n)$', ...
           '$\overline{\mu}(\vec x_n)$', ...
           'Interpreter', 'latex', 'FontSize', 14);

    subplot(2, 1, 2);
    D_seq = (zeros(1, n) + D);
    D_seq = D_seq(10:end);
    D_pe = D_pe(10:end);
    D_pe_lo = D_pe_lo(10:end);
    D_pe_hi = D_pe_hi(10:end);
    plot(10 : n, [D_seq', D_pe', D_pe_lo', D_pe_hi']);
    xlim([10 n])
    xlabel('n');
    xlabel('n');
    ylabel('z');
    legend('$\hat S^2(\vec x_N)$', '$\hat S^2(\vec x_n)$', ...
           '$\underline{\sigma}^2(\vec x_n)$', ...
           '$\overline{\sigma}^2(\vec x_n)$', ...
           'Interpreter', 'latex', 'FontSize', 14);
end

% Границы доверительного интервала для мат. ожидания
function [lo, hi] = mean_bounds(X, gamma)
    n = length(X);
    M = mean(X);
    S = sqrt(var(X));

    alpha = (1 + gamma) / 2;
    interval = S / sqrt(n) * tinv(alpha, n - 1);

    lo = M - interval;
    hi = M + interval;
end

% Границы доверительного интервала для дисперсии
function [lo, hi] = var_bounds(X, gamma)
    n = length(X);
    D = var(X);

    lo = (n - 1) * D / chi2inv((1 + gamma) / 2, n - 1);
    hi = (n - 1) * D / chi2inv((1 - gamma) / 2, n - 1);
end
