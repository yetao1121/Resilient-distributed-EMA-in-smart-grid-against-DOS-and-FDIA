clear;clc;
n = 8;

% weight matrix
W = [
     2/8, 3/8, 3/8, 0/8, 0/8, 0/8, 0/8, 0/8;
     1/8, 4/8, 0/8, 1/8, 1/8, 1/8, 0/8, 0/8;
     2/8, 0/8, 2/8, 0/8, 0/8, 0/8, 2/8, 2/8;
     0/8, 4/8, 0/8, 4/8, 0/8, 0/8, 0/8, 0/8;
     0/8, 4/8, 0/8, 0/8, 4/8, 0/8, 0/8, 0/8;
     0/8, 4/8, 0/8, 0/8, 0/8, 4/8, 0/8, 0/8;
     0/8, 0/8, 4/8, 0/8, 0/8, 0/8, 4/8, 0/8;
     0/8, 0/8, 4/8, 0/8, 0/8, 0/8, 0/8, 4/8;
    ];
 
a = [0.0024, 0.0545, 0.0877, 0.0056, 0.0547, 0.1041, 0.0870, 0.0072];
b = [5.56, 18.43, 13.17, 4.32, 15.46, 10.03, 8.45, 6.60];
p_min = [60, 50, 100, 25, 40, 30, 80, 28];
p_max = [339.69, 100.34, 159.13, 479.10, 80.56, 123.98, 109.55, 290.4];

% Initialize
lambda_state = zeros(1, n);
P_state = zeros(1, n);
delta_state = zeros(1, n);
for i = 1 : 1 : n
    if i == 1 || i == 4 || i == 8
        lambda_state(i) = 2 * a(i) + b(i);
    else
        lambda_state(i) = -2 * a(i) + b(i);
    end
end

% save data for output result
for i = 1 : 1 : n
    Lambda{i} = lambda_state(i);
    P_axis{i} = 0;
    Delta{i} = 0;
end
k_axis = 0;
delta_p = 0;
social_welfare = 0;

eta = 0.001;
k_max = 350;

for k = 1 : 1 : k_max

    % lambda iteration
    for i = 1 : 1 : n
        sigma = 0;
        for j = 1 : 1 : n
            sigma = sigma + W(i, j) * lambda_state(j);
        end
        lambda_state(i) = sigma + eta * delta_state(i);

        Lambda{i}(end + 1) = lambda_state(i);
    end

    % power update
    for i = 1 : 1 : n
        tmp = 0;
        if i == 1 || i == 4 || i == 8
            tmp = (lambda_state(i) - b(i)) / (2 * a(i));
        else
            tmp = (b(i) - lambda_state(i)) / (2 * a(i));
        end
        if tmp < p_min(i)
            P_state(i) = p_min(i);
        elseif tmp > p_max(i)
            P_state(i) = p_max(i);
        else
            P_state(i) = tmp;
        end
        P_axis{i}(end + 1) = P_state(i);
    end

    % delta iteration
    for i = 1 : 1 : n
        sigma = 0;
        for j = 1 : 1 : n
            sigma = sigma + W(i, j) * delta_state(j);
        end
        if i == 1 || i == 4 || i == 8
            delta_state(i) = sigma + P_axis{i}(end - 1) - P_axis{i}(end);
        else
            delta_state(i) = sigma + P_axis{i}(end) - P_axis{i}(end - 1);
        end
        Delta{i}(end + 1) = delta_state(i);
    end
    
    k_axis(end + 1) = k;
end

figure(1);
for i = 1 : 1 : n
    plot(k_axis, Lambda{i}, 'lineWidth', 1);
    grid on;
    hold on;
end
xlabel('Iteration k');
ylabel('\lambda_{i}');

figure(2);
for i = 1 : 1 : n
    if i == 1 || i == 4 || i == 8
        plot(k_axis, P_axis{i}, 'lineWidth', 1);
        hold on;
    else
        plot(k_axis, -P_axis{i}, 'lineWidth', 1, 'linestyle', '--');
        hold on;
        grid on;
    end
end
xlabel('Iteration k');
ylabel('P_{i}');

figure(3);
for i = 1 : 1 : n
    plot(k_axis, Delta{i}, 'lineWidth', 1);
    hold on;
    grid on;
end
xlabel('Iteration k');
ylabel('delta_{i}');