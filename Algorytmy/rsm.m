function [ranking, dist_to_ideal] = rsm(data, weights, lambda)
% RSM - Reference Set Method
%   data_table - tabela z danymi (pierwsza kolumna - nazwy, reszta - kryteria numeryczne)
%   weights - wektor wag dla każdego kryterium
%   lambda - współczynnik równoważący odległości od punktu idealnego i antyidealnego
    
    % Normalizacja danych
    min_values = min(data, [], 1);
    max_values = max(data, [], 1);
    normalized_data = (data - min_values) ./ (max_values - min_values);
    
    % Dodanie wag do znormalizowanych danych
    weighted_data = normalized_data .* weights;

    % Wyznaczenie punktów idealnych i antyidealnych
    ideal_point = max(weighted_data, [], 1);
    anti_ideal_point = min(weighted_data, [], 1);

    % Wypisanie punktów idealnego i antyidealnego
    disp('Punkt idealny:');
    disp(ideal_point);
    
    disp('Punkt nadir:');
    disp(anti_ideal_point);

    % Obliczenie odległości od punktów idealnego i antyidealnego
    dist_to_ideal = sqrt(sum((weighted_data - ideal_point).^2, 2));
    dist_to_anti_ideal = sqrt(sum((weighted_data - anti_ideal_point).^2, 2));

    % Wyliczenie ostatecznych skoringów
    final_scores = lambda * dist_to_anti_ideal - (1 - lambda) * dist_to_ideal;

    % Uporządkowanie wyników i wyznaczenie rankingu
    [~, ranking_indices] = sort(final_scores, 'descend');
    ranking = ranking_indices;
end