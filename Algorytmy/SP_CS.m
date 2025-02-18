function [ranking, distances_to_aspiration] = SP_CS(data_table, weights, data_criterium)
    % SP-CS - Algorytm z krzywą szkieletową
    % data_table - dane (macierz numeryczna)
    % weights - wektor wag 
    % data_criterium - kryterium (1 = maksymalizują, -1 = minimalizują)
    % ranking - ranking alternatyw
    % distances_to_aspiration - odległości od punktu aspiracji

    % Dane są już w formie macierzy numerycznej
    numerical_data = data_table;

    [rows, cols] = size(numerical_data);
    normalizedMatrix = zeros(rows, cols);

    % Normalizacja kryteriów
    for j = 1:cols
        if data_criterium(j) == 1
            % Benefit criteria
            maxValue = max(numerical_data(:, j));
            normalizedMatrix(:, j) = numerical_data(:, j) / maxValue;
        else
            % Cost criteria
            minValue = min(numerical_data(:, j));
            normalizedMatrix(:, j) = minValue ./ numerical_data(:, j);
        end
    end
    
    % Uwzględnienie wag
    weightedMatrix = normalizedMatrix .* weights;

    % Status quo i aspiracje
    status_quo = min(weightedMatrix, [], 1);   % Najgorsze wartości
    aspiration = max(weightedMatrix, [], 1);  % Najlepsze wartości

    % Wypisanie punktu aspiracji i status quo
    disp('Punkt aspiracji:');
    disp(aspiration);
    
    disp('Punkt status quo:');
    disp(status_quo);
    
    % Obliczanie odległości od punktu aspiracji
    distances_to_aspiration = sqrt(sum((weightedMatrix - aspiration).^2, 2));

    % Konstrukcja krzywej szkieletowej
    num_points = 100; % Liczba punktów na krzywej
    gamma = zeros(num_points, cols); % Prealokacja macierzy gamma

    for j = 1:cols
        gamma(:, j) = linspace(status_quo(j), aspiration(j), num_points)';
    end

    % Obliczanie funkcji skoringowej
    scores = zeros(rows, 1);
    for i = 1:rows
        point = weightedMatrix(i, :);
        distances = max(abs(gamma - point), [], 2); % Metryka Czebyszewa
        [min_distance, idx] = min(distances);
        t = idx / num_points; % Parametr krzywej
        scores(i) = min_distance + t; % Skoring
    end

    % Ranking alternatyw
    [~, ranking] = sort(scores, 'descend');
end