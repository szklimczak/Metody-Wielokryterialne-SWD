function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 06-Jan-2025 12:34:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function wczytaj_dane_Callback(hObject, eventdata, handles)
% Wczytaj dane z pliku Excel
    try
        [file, path] = uigetfile({'*.xlsx;*.xls', 'Pliki Excel (*.xlsx, *.xls)'}, 'Wybierz plik z danymi');
        if isequal(file, 0)
            msgbox('Nie wybrano pliku.', 'Błąd', 'error');
            return;
        end

        fullpath = fullfile(path, file);

        % Wczytaj dane z Arkusza1 (Alternatywy)
        alternatywy = readtable(fullpath, 'Sheet', 'Arkusz1', 'VariableNamingRule', 'preserve');
        set(handles.uitable1, 'Data', table2cell(alternatywy));

        % Wczytaj dane z Arkusza2 (Punkty odniesienia)
        punkty_odniesienia = readtable(fullpath, 'Sheet', 'Arkusz2', 'VariableNamingRule', 'preserve');
        set(handles.uitable2, 'Data', table2cell(punkty_odniesienia));

        % Rozpoznanie pliku i ustawienie parametrów
        if contains(file, 'phones', 'IgnoreCase', true)
            handles.weights = [0.3, 0.25, 0.2, 0.15, 0.1];
            handles.types = [-1, 1, -1, 1, 1];
            handles.lambda = 0.7;
            handles.dec_weights = [0.5, 0.5, 0.5, 0.5, 0.5];
        elseif contains(file, 'footbalers', 'IgnoreCase', true)
            handles.weights = [0.6, 0.3, 0.15, 0.25, 0.005, 0.3, 0.2];
            handles.types = [1, 1, 1, 1, 1, 1, -1];
            handles.lambda = 0.5;
            handles.dec_weights = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5];
        elseif contains(file, 'cars', 'IgnoreCase', true)
            handles.weights = [1, 1, 1, 1, 1];
            handles.types = [-1, -1, 1, 1, -1];
            handles.lambda = 0.5;
            handles.dec_weights = [0.5, 0.5, 0.5, 0.5, 0.5];
        elseif contains(file, 'gym', 'IgnoreCase', true)
            handles.weights = [1, 1, 1, 1];
            handles.types = [-1, 1, -1, -1];
            handles.lambda = 0.5;
            handles.dec_weights = [0.5, 0.5, 0.5, 0.5];
        else
            handles.weights = ones(1, size(alternatywy, 2) - 1); % Domyślne wagi
            handles.weights = handles.weights / sum(handles.weights); % Normalizacja wag
            handles.types = ones(1, size(alternatywy, 2) - 1); % Domyślne kierunki
            handles.lambda = 0.5; % Domyślny parametr
            handles.dec_weights = ones(1, size(alternatywy, 2) - 1);
        end

        guidata(hObject, handles); % Zapisz zmienne w handles

        % Wyświetl komunikat o sukcesie
        msgbox('Dane zostały pomyślnie wczytane.', 'Sukces', 'help');
    catch ME
        % Obsługa błędów
        msgbox(['Wystąpił błąd podczas wczytywania danych: ', ME.message], 'Błąd', 'error');
    end


% --- Executes on selection change in metoda.
function metoda_Callback(hObject, eventdata, handles)
% hObject    handle to metoda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns metoda contents as cell array
%        contents{get(hObject,'Value')} returns selected item from metoda


% --- Executes during object creation, after setting all properties.
function metoda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to metoda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tworz_ranking_Callback(hObject, eventdata, handles)
% hObject    handle to tworz_ranking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Pobranie danych z tabel GUI
    alternatywy = get(handles.uitable1, 'Data'); % Tabela "Alternatywy z kryteriami"

    if isempty(alternatywy)
        msgbox('Brak danych w tabeli alternatyw! Wczytaj dane najpierw.', 'Błąd', 'error');
        return;
    end
    
    % Wybrana metoda
    selected_method = get(handles.metoda, 'Value');
    methods = get(handles.metoda, 'String');
    selected_method_name = methods{selected_method};

    if strcmp(selected_method_name, 'Topsis (GT)')
        % Przekształcenie danych z tabel
        data = cell2mat(alternatywy(:, 2:end)); % Dane alternatyw (bez nazw)

        weights = handles.weights;
        types = handles.types;
        dec_weights = handles.dec_weights;

        % Obliczenie rankingu metodą Topsis (GT)
        [ranking, ~] = Topsis_GT(data, weights, types, dec_weights);
        % Przygotowanie wyników rankingu
        wynik = alternatywy(ranking, :); % Posortowane dane alternatyw
        
        % Wyświetlenie rankingu w tabeli
        set(handles.tabela_ranking, 'Data', wynik);

        % Powiadomienie użytkownika
        msgbox('Ranking został utworzony metodą Topsis (GT)!', 'Sukces');

    elseif strcmp(selected_method_name, 'Metoda zbiorów odniesienia (RSM)')
        data = cell2mat(alternatywy(:, 2:end)); % Dane alternatyw (bez nazw)
        handles.weights = handles.weights / sum(handles.weights); % Normalizacja wag
        % Obliczenie rankingu metodą RSM
        [ranking, ~] = rsm(data, handles.weights, handles.lambda);
        % Przygotowanie wyników rankingu
        wynik = alternatywy(ranking, :); % Posortowane dane alternatyw

        % Wyświetlenie rankingu w tabeli
        set(handles.tabela_ranking, 'Data', wynik);
        
        % Powiadomienie użytkownika
        msgbox('Ranking został utworzony za pomocą metody RSM!', 'Sukces');
    
    elseif strcmp(selected_method_name, 'Metoda wielu punktów odniesienia (MREF)')
        % Przekształcenie danych z tabel
        data = cell2mat(alternatywy(:, 2:end)); % Dane alternatyw (bez nazw)

        weights = handles.weights;
        types = handles.types;

        % Obliczenie rankingu metodą MREF
        [ranking, ~] = MREF(data, weights, types);

        % Przygotowanie wyników rankingu
        wynik = alternatywy(ranking, :); % Posortowane dane alternatyw
        
        % Wyświetlenie rankingu w tabeli
        set(handles.tabela_ranking, 'Data', wynik);

        % Powiadomienie użytkownika
        msgbox('Ranking został utworzony metodą MREF!', 'Sukces');

    elseif strcmp(selected_method_name, 'Metoda SP-CS')
        % Przekształcenie danych z tabel na macierz numeryczną
        data = cell2mat(alternatywy(:, 2:end)); % Dane alternatyw (bez nazw)
    
        weights = handles.weights;
        types = handles.types;
    
        % Obliczenie rankingu metodą SP-CS
        [ranking, ~] = SP_CS(data, weights, types);
    
        % Przygotowanie wyników rankingu
        wynik = alternatywy(ranking, :); % Posortowane dane alternatyw
    
        % Wyświetlenie rankingu w tabeli
        set(handles.tabela_ranking, 'Data', wynik);
    
        % Powiadomienie użytkownika
        msgbox('Ranking został utworzony metodą SP-CS!', 'Sukces');
    elseif strcmp(selected_method_name, 'TOPSIS')
        % Przekształcenie danych z tabel na macierz numeryczną
        data = cell2mat(alternatywy(:, 2:end)); % Dane alternatyw (bez nazw)
    
        weights = handles.weights; % Wagi kryteriów
        criteria_types = handles.types; % Typy kryteriów
    
        % Obliczenie rankingu metodą TOPSIS
        [ranking, ~] = TOPSIS(data, weights, criteria_types);
    
        % Przygotowanie wyników rankingu
        wynik = alternatywy(ranking, :); % Posortowane dane alternatyw
    
        % Wyświetlenie rankingu w tabeli
        set(handles.tabela_ranking, 'Data', wynik);
    
        % Powiadomienie użytkownika
        msgbox('Ranking został utworzony metodą klasyczny TOPSIS!', 'Sukces');
    else
        msgbox('Wybierz poprawną metodę z listy.', 'Błąd', 'error');
    end


% --- Executes on button press in porownaj_metody.
function porownaj_metody_Callback(hObject, eventdata, handles)
% hObject    handle to porownaj_metody (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Pobranie danych z tabeli GUI
    alternatywy = get(handles.uitable1, 'Data'); % Tabela "Alternatywy z kryteriami"
    if isempty(alternatywy)
        msgbox('Brak danych w tabeli alternatyw! Wczytaj dane najpierw.', 'Błąd', 'error');
        return;
    end

    % Automatyczne generowanie nazw kolumn (Kryterium_1, Kryterium_2, ...)
    num_cols = size(alternatywy, 2);
    col_names = [{'Alternatywy'}, strcat('Kryterium_', string(1:(num_cols - 1)))];

    % Tworzenie tabeli danych
    try
        data_table = cell2table(alternatywy, 'VariableNames', col_names);
    catch ME
        msgbox(['Błąd podczas tworzenia tabeli danych: ', ME.message], 'Błąd', 'error');
        return;
    end

    % Przekształcenie danych na macierz liczb i nazwy alternatyw
    try
        data = data_table{:, 2:end}; % Dane liczbowe (bez nazw)
        nazwy_alternatyw = data_table{:, 1}; % Nazwy alternatyw
    catch ME
        msgbox(['Błąd podczas przetwarzania danych: ', ME.message], 'Błąd', 'error');
        return;
    end

    % Pobranie wag, typów i parametru lambda
    weights = handles.weights;
    types = handles.types;
    lambda = handles.lambda;
    dec_weights = handles.dec_weights;

    % Inicjalizacja tabeli wyników
    results = table(nazwy_alternatyw, 'VariableNames', {'Alternatywy'});
    time_results = zeros(1, 5); % Tablica na czas wykonania każdej metody
    distances_best = zeros(1, 5); % Odległości od punktu idealnego dla najlepszych alternatyw

    % Wywołanie metod i zapisanie rankingów
    try
        tic;
        [ranking_TopsisGT, dist_TopsisGT] = Topsis_GT(data, weights, types, dec_weights);
        time_results(1) = toc;
        results.Topsis_GT = ranking_TopsisGT;
        distances_best(1) = dist_TopsisGT(ranking_TopsisGT(1)); % Odległość dla najlepszego
    catch
        msgbox('Błąd w metodzie Topsis (GT).', 'Błąd', 'error');
    end

    try
        tic;
        weights_rsm = handles.weights / sum(handles.weights); % Normalizacja wag
        [ranking_RSM, dist_RSM] = rsm(data, weights_rsm, lambda);
        time_results(2) = toc;
        results.RSM = ranking_RSM;
        distances_best(2) = dist_RSM(ranking_RSM(1)); % Odległość dla najlepszego
    catch
        msgbox('Błąd w metodzie RSM.', 'Błąd', 'error');
    end

    try
        tic;
        [ranking_MREF, dist_MREF] = MREF(data, weights, types);
        time_results(3) = toc;
        results.MREF = ranking_MREF;
        distances_best(3) = dist_MREF(ranking_MREF(1)); % Odległość dla najlepszego
    catch
        msgbox('Błąd w metodzie MREF.', 'Błąd', 'error');
    end

    try
        tic;
        [ranking_SP_CS, dist_SP_CS] = SP_CS(data, weights, types);
        time_results(4) = toc;
        results.SP_CS = ranking_SP_CS;
        distances_best(4) = dist_SP_CS(ranking_SP_CS(1)); % Odległość dla najlepszego
    catch
        msgbox('Błąd w metodzie SP-CS.', 'Błąd', 'error');
    end

    try
        tic;
        [ranking_TOPSIS, dist_TOPSIS] = TOPSIS(data, weights, types);
        time_results(5) = toc;
        results.TOPSIS = ranking_TOPSIS;
        distances_best(5) = dist_TOPSIS(ranking_TOPSIS(1)); % Odległość dla najlepszego
    catch
        msgbox('Błąd w metodzie klasyczny TOPSIS.', 'Błąd', 'error');
    end

    % Wizualizacja porównania rankingów
    try
        figure;
        hold on;
        plot(ranking_TopsisGT, 'o-', 'DisplayName', 'Topsis (GT)');
        plot(ranking_RSM, 'x-', 'DisplayName', 'RSM');
        plot(ranking_MREF, 's-', 'DisplayName', 'MREF');
        plot(ranking_SP_CS, 'd-', 'DisplayName', 'SP-CS');
        plot(ranking_TOPSIS, '*-', 'DisplayName', 'TOPSIS');
        legend('Location', 'best');
        xlabel('Alternatywy');
        ylabel('Ranking');
        title('Porównanie rankingów metod');
        hold off;
    catch ME
        msgbox(['Błąd podczas wizualizacji: ', ME.message], 'Błąd', 'error');
    end

    % Wykres czasu wykonania
    try
        figure;
        bar(time_results);
        xticklabels({'Topsis (GT)', 'RSM', 'MREF', 'SP-CS', 'TOPSIS'});
        xlabel('Metody');
        ylabel('Czas wykonania (s)');
        title('Czas wykonania metod porównawczych');
        grid on;
    catch ME
        msgbox(['Błąd podczas generowania wykresu czasu wykonania: ', ME.message], 'Błąd', 'error');
    end

    % Wyświetlenie tabeli wyników w GUI
    try
        set(handles.tabela_ranking, 'Data', table2cell(results));
    catch ME
        msgbox(['Błąd podczas wyświetlania wyników: ', ME.message], 'Błąd', 'error');
    end

    % Generowanie wykresu słupkowego dla najlepszych alternatyw
    try
        figure;
        bar(distances_best);
        xticklabels({'Topsis (GT)', 'RSM', 'MREF', 'SP-CS', 'TOPSIS'});
        xlabel('Metody');
        ylabel('Odległość od punktu idealnego');
        title('Odległości od punktu idealnego dla najlepszych alternatyw');
        grid on;
    catch ME
        msgbox(['Błąd podczas generowania wykresu: ', ME.message], 'Błąd', 'error');
    end