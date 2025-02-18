function [ranking, min_distances] = MREF(data, weights, types)
    % MREF - metoda wielokryterialnej optymalizacji z miarą Czebyszewa
    % data - macierz alternatyw (wiersze to alternatywy, kolumny to kryteria)
    % weights - wagi dla kryteriów (wektor kolumnowy)
    % types - typy kryteriów (1 = maksymalizuja, -1 = minimalizuja)
    % ranking - ranking alternatyw od najlepszej do najgorszej
    % min_distances - minimalne odległości dla każdej alternatywy

    % Sprawdzanie poprawności danych wejściowych
    if size(data, 2) ~= length(weights) || length(weights) ~= length(types)
        error('Rozmiar wag i typów kryteriów musi być zgodny z liczbą kolumn w macierzy danych.');
    end

    % Punkty referencyjne (domyślnie: minimum, maksimum, mediany w każdej kolumnie)
    references = [min(data); max(data); median(data)];

    % Normalizacja kryteriów
    [normalized, normalized_ref] = normalize_criteria(data, types, references);

    % Wypisanie punktów referencyjnych
    disp('Punkt idealny:');
    disp(references(2, :));

    disp('Punkt nadir:');
    disp(references(1, :));

    % Obliczanie odległości Czebyszewa
    distances = Czebyszew(normalized, normalized_ref);

    % Minimalna odległość względem dowolnego punktu referencyjnego
    min_distances = min(distances, [], 2);

    % Ranking alternatyw (od najlepszej do najgorszej)
    [~, ranking_indices] = sort(min_distances);

    % Zwracanie wynikowego rankingu i odległości
    ranking = ranking_indices;
end

function [normalized, normalized_ref] = normalize_criteria(alternatives, criteria, references)
    % Normalizacja kryteriów dla alternatyw i punktów referencyjnych
    % alternatives - macierz alternatyw
    % criteria - typy kryteriów (-1 - min, 1 - max)
    % references - punkty referencyjne

    normalized = zeros(size(alternatives));
    normalized_ref = zeros(size(references));

    for i = 1:length(criteria)
        if criteria(i) == -1  % Minimalizacja
            normalized(:, i) = (alternatives(:, i) - min(alternatives(:, i))) / (max(alternatives(:, i)) - min(alternatives(:, i)));
            normalized_ref(:, i) = (references(:, i) - min(alternatives(:, i))) / (max(alternatives(:, i)) - min(alternatives(:, i)));
        elseif criteria(i) == 1  % Maksymalizacja
            normalized(:, i) = (max(alternatives(:, i)) - alternatives(:, i)) / (max(alternatives(:, i)) - min(alternatives(:, i)));
            normalized_ref(:, i) = (max(alternatives(:, i)) - references(:, i)) / (max(alternatives(:, i)) - min(alternatives(:, i)));
        else
            error('Nieprawidłowy typ kryterium. Użyj 0 (minimalizacja) lub 1 (maksymalizacja).');
        end
    end
end

function distances = Czebyszew(normalized, normalized_ref)
    % Obliczanie odległości Czebyszewa
    % normalized - znormalizowane alternatywy
    % normalized_ref - znormalizowane punkty referencyjne

    num_alternatives = size(normalized, 1);
    num_references = size(normalized_ref, 1);
    distances = zeros(num_alternatives, num_references);

    for i = 1:num_alternatives
        for j = 1:num_references
            distances(i, j) = max(abs(normalized(i, :) - normalized_ref(j, :)));
        end
    end
end