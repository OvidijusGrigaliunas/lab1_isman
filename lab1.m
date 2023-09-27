%% Pagrindine
clc
clear all
files = dir('.');
% Obuolių nuotraukų masyvas
A = {};
% Kriaušių nuotraukų masyvas
P = {};
% Nuskaitomi visi failai aplankale
% Priklausant nuo failo pavadinimo, nuotraukos bus priskirtos A arba P
% Masyvui
for k=1:length(files)
   if startsWith(files(k).name,'apple_')
       A{end+1} = imread(files(k).name);
   elseif startsWith(files(k).name,'pear_')
       P{end+1} = imread(files(k).name);
   end
end
% Spalvos duomenys
x1= []; 
% Apvalumo duomenys
x2= [];
% Masyvas nusakantis ar tai obuolis ar kriaušė
D = [];
% Toliau yra naudojantis duotomis funkcijomis apdorojamos nuotraukos
% Obuolių duomenys
for i=1:length(A)
    x1(end+1)=spalva_color(A{i}); 
    x2(end+1)=apvalumas_roundness(A{i}); 
    D(end+1) = 1;
end
% Kriaušių duomenys
for i=1:length(P)
    x1(end+1)=spalva_color(P{i}); 
    x2(end+1)=apvalumas_roundness(P{i}); 
    D(end+1) = -1;
end
% Žingsnis
n = 0.1;
% Atliktų ciklų skaičius
num_of_cicles = 0;
% Nustatomos pradinės vertės
w1(1) = randn(1);
w2(1) =randn(1);
b(1) = randn(1);
% Klaidų masyvas
e = [1];
% Kol klaidų masyve visos vertės nėra lygios 0, tol ciklas tęsis
while ~(all(e(:) == 0))
    for index = 1:length(x1)
        v = x1(index)*w1(1)+x2(index)*w2(1)+b(index);
        if v > 0
            y = 1;
        else
            y = -1;
        end
        e(index) = D(index) - y;
        % Atnaujinamos vertės 
        % Jei yra atliekamas paskutintas for ciklas, yra atnaujimas pirmas
        % masyvo elementas.
        if index ~= length(x1)
            w1(index+1) = w1(index) + n*e(index)*x1(index);
            w2(index+1) = w2(index) + n*e(index)*x2(index);
            b(index+1) = b(index) + n*e(index);
        else  
            w1(1) = w1(index) + n*e(index)*x1(index);
            w2(1) = w2(index) + n*e(index)*x2(index);
            b(1) = b(index) + n*e(index);
        end 
        
    end
   
    num_of_cicles =  num_of_cicles +1;
end
disp('Ciklai:')
disp(num_of_cicles)
disp('Klaidos:')
disp(e)
%% Papildoma
clc
clear all
files = dir('.');
A = {};
P = {};
%  Duomenų gavimas
for k=1:length(files)
    files(k).name;
   if startsWith(files(k).name,'apple_')
       A{end+1} = imread(files(k).name);
   elseif startsWith(files(k).name,'pear_')
      P{end+1} = imread(files(k).name);
   end
end
x1= []; 
x2= [];
D = [];
for i=1:length(A)
    x1(end+1)=spalva_color(A{i}); 
    x2(end+1)=apvalumas_roundness(A{i}); 
    D(end+1) = 1;
end
for i=1:length(P)
    x1(end+1)=spalva_color(P{i}); 
    x2(end+1)=apvalumas_roundness(P{i}); 
    D(end+1) = -1;
end
data = [x1(:), x2(:), D(:)];
% Duomenų gavimo pabaiga


% Savybės (apvalumas ir spalva)
X = data(:, 1:2);
% Klasė (kriaušė arba obuolis)
Y = data(:, 3); 

% Pagal klasę yra atskiriamos vertės
classAppleData = X(Y == 1, :);
classPearData = X(Y == -1, :);

% Išankstinės tikimybės apskaičiavimas
priorClassApple = sum(Y == 1) / length(Y);
priorClassPear = sum(Y == -1) / length(Y);

% Apskaišiuojamas klasių savybių vidurkis
meanClassApple = mean(classAppleData);
meanClassPear = mean(classPearData);
% Apskaičiuojamas standartinis nuokrypis
stdClassApple = std(classAppleData);
stdClassPear = std(classPearData);

% Gauso tikimybės tankio funkciją (paimta iš
% https://en.wikipedia.org/wiki/Naive_Bayes_classifier)
gaussianApple = @(x, j) (1 / (sqrt(2 * pi) * stdClassApple(j))) * exp(-((x - meanClassApple(j))^2) / (2 * stdClassApple(j)^2));
gaussianPear = @(x, j) (1 / (sqrt(2 * pi) * stdClassPear(j))) * exp(-((x - meanClassPear(j))^2) / (2 * stdClassPear(j)^2));

predictions = [];

% Atliekami numatymai pagal turimus duomenis
for i = 1:size(X, 1)
    % Apskaičiuojama kiekvienos klasės duomenų taško tikimybę
    likelihoodClassApple = prod(arrayfun(@(j) gaussianApple(X(i, j), j), 1:2));
    likelihoodClassPear = prod(arrayfun(@(j) gaussianPear(X(i, j), j), 1:2));
    
    % Apskaičiuojamos užpakalines tikimybes
    posteriorClassApple = priorClassApple * likelihoodClassApple;
    posteriorClassPear = priorClassPear * likelihoodClassPear;
    
    % Numatymui priskirkite klasę, kurios užpakalinė tikimybė yra didžiausia
    if posteriorClassApple > posteriorClassPear
        predictions(i,1) = 1;
    else
        predictions(i,1) = -1;
    end
end

disp(predictions);



