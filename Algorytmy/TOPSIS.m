function [ranking, distances_to_ideal] = TOPSIS(data_table, weights, criteria_types)
    % data_table - macierz numeryczna alternatyw
    % weights - wektor wag
    % criteria_types - kryteria: 1 (maksymalizowane), -1 (minimalizowane)

    [num_alternatives, num_criteria] = size(data_table);

    % Normalizacja danych
    normalized_matrix = zeros(num_alternatives, num_criteria);
    for j = 1:num_criteria
        normalized_matrix(:, j) = data_table(:, j) / sqrt(sum(data_table(:, j).^2));
    end

    % Uwzględnienie wag
    weighted_matrix = normalized_matrix .* weights;

    % Wyznaczenie punktów idealnego i anty-idealnego
    ideal_solution = zeros(1, num_criteria);
    anti_ideal_solution = zeros(1, num_criteria);
    for j = 1:num_criteria
        if criteria_types(j) == 1
            ideal_solution(j) = max(weighted_matrix(:, j));
            anti_ideal_solution(j) = min(weighted_matrix(:, j));
        else
            ideal_solution(j) = min(weighted_matrix(:, j));
            anti_ideal_solution(j) = max(weighted_matrix(:, j));
        end
    end

    % Wypisanie punktu idealnego i nadir
    disp('Punkt idealny:');
    disp(ideal_solution);

    disp('Punkt nadir:');
    disp(anti_ideal_solution);

    % Wyznaczenie odległości od punktu idealnego i anty-idealnego
    distances_to_ideal = sqrt(sum((weighted_matrix - ideal_solution).^2, 2));
    distances_to_anti_ideal = sqrt(sum((weighted_matrix - anti_ideal_solution).^2, 2));

    % Obliczenie współczynnika bliskości
    closeness_coefficient = distances_to_anti_ideal ./ (distances_to_ideal + distances_to_anti_ideal);

    % Ranking alternatyw (od najlepszej do najgorszej)
    [~, sorted_indices] = sort(closeness_coefficient, 'descend');
    ranking = sorted_indices;
end