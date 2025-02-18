function [ranking, dist_positive] = Topsis_GT(data, weights, types, dec_weights)
    % Topsis_GT: rozszerzenie klasycznej metody TOPSIS uwzględniający proces grupowego podejmowania decyzji
    % weights: wektor n-elementowy z wagami kryteriów
    % types: wektor n-elementowy określający typ kryterium (1 = maksymalizujące, -1 = minimalizujące).
    % dec_weights: wektor d-elementowy z wagami decydentów
    [m, n, d] = size(data); % Rozmiar danych: alternatywy, kryteria, decydenci
    
    % Krok 1: Agregacja ocen decydentów
    aggregated_data = zeros(m, n); % Inicjalizacja macierzy zsumowanych ocen
    for k = 1:d
        aggregated_data = aggregated_data + data(:, :, k) * dec_weights(k);
    end
    
    % Krok 2: Normalizacja macierzy decyzyjnej
    norm_data = aggregated_data ./ sqrt(sum(aggregated_data.^2));
    
    % Krok 3: Ważona macierz normalizowana
    weighted_data = norm_data .* weights;
    
    % Krok 4: Wyznaczenie ideałów pozytywnego i negatywnego
    ideal_positive = max(weighted_data .* (types == 1), [], 1) - ...
                     min(weighted_data .* (types == -1), [], 1);
    ideal_negative = min(weighted_data .* (types == 1), [], 1) - ...
                     max(weighted_data .* (types == -1), [], 1);
    
    % Wypisanie punktu idealnego i nadir
    disp('Punkt idealny:');
    disp(ideal_positive);
    
    disp('Punkt nadir:');
    disp(ideal_negative);
    
    % Krok 5: Obliczenie odległości od ideałów
    dist_positive = sqrt(sum((weighted_data - ideal_positive).^2, 2));
    dist_negative = sqrt(sum((weighted_data - ideal_negative).^2, 2));
    
    % Krok 6: Wyznaczenie miary bliskości do ideału pozytywnego
    closeness = dist_negative ./ (dist_positive + dist_negative);
    
    % Krok 7: Tworzenie rankingu
    [~, ranking] = sort(closeness, 'descend');
end