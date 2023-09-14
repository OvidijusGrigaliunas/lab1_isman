%% Pagrindine
clc
clear all
data = importdata('data.txt');  
x1 = [];
x2= [];
D = [];
n= 0.1;
e = [1];
w1 = [];
w2 = [];
b = [];
num_of_cicles = 0;
for index = 1:13
    x1(index) = data(index,1);
    x2(index) =data(index,2);
    D(index) =data(index,3);
end
is_there_mistake = true;
while is_there_mistake
    for index = 1:13
        w1(1) = randn(1);
        w2(1) =randn(1);
        b(1) = randn(1);
        
        v = x1(index)*w1+x2(index)*w2+b;
        if v > 0
            y = 1;
        else
            y = -1;
        end
        e(index) = D(index) - y;
        w1(index+1) = w1(index) + n*e(index)*x1(index);
        w2(index+1) = w2(index) + n*e(index)*x2(index);
        b(index+1) = b(index) + n*e(index);
    end
    num_of_cicles =  num_of_cicles +1;
    is_there_mistake = ~(all(e(:) == 0));
end
disp('Ciklai:')
disp(num_of_cicles)
disp('Klaidos:')
disp(e)
%% Papildoma
clc
clear all
data = importdata('data.txt');  
x1_sum = 0;
x2_sum = 0;
D_sum = 0;
num_of_cicles = 0;
apple_data = [];
pear_data = [];
sum_data = [];
pear_data_sum = [];
for index = 1:13
    if data(index, 3) == 1
        apple_data(end+1, :)= data(index, :);
    elseif data(index, 3) == -1
        pear_data(end+1, :)= data(index, :);
    end
    x1_sum = x1_sum + data(index,1);
    x2_sum = x2_sum + data(index,2);
    D_sum = D_sum + 1;
end
sum_data = [x1_sum,x2_sum, D_sum]
x1_sum =0;
x2_sum= 0;
D_sum = 0;
for index = 1:length(apple_data)
    x1_sum = x1_sum + apple_data(index,1);
    x2_sum = x2_sum + apple_data(index,2);
    D_sum = D_sum + 1;
end
apple_data_sum = [x1_sum,x2_sum, D_sum]
x1_sum =0;
x2_sum= 0;
D_sum = 0;
for index = 1:length(pear_data)
    x1_sum = x1_sum + pear_data(index,1);
    x2_sum = x2_sum + pear_data(index,2);
    D_sum =D_sum + 1;
end
pear_data_sum = [x1_sum,x2_sum, D_sum]

ApplePx1 =(apple_data_sum(1)/apple_data_sum(3))*(sum_data(1)/sum_data(3))/(apple_data_sum(3)/sum_data(3))
ApplePx2 =(apple_data_sum(2)/apple_data_sum(3))*(sum_data(2)/sum_data(3))/(apple_data_sum(3)/sum_data(3))
AppleP = ApplePx2*ApplePx1

PearPx1 =(pear_data_sum(1)/pear_data_sum(3))*(sum_data(1)/sum_data(3))/(pear_data_sum(3)/sum_data(3))
PearPx2 =(pear_data_sum(2)/pear_data_sum(3))*(sum_data(2)/sum_data(3))/(pear_data_sum(3)/sum_data(3))
PearP=PearPx2*PearPx1