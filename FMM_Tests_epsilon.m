% Test for varying epsilon assumption

n=30;
N=50;
n_f = 10;
e = ones(N,1);

samples = 8;

timeElapsed = zeros(samples,1);
deltaNorm = zeros(samples,1);
deltaNorm_R = zeros(samples,1);
totalError_R = zeros(samples,1);
samplesArr= zeros(samples,1);
MSE = zeros(samples,1);
MSE_R = zeros(samples,1);
i=0;

% Set a lower bound for epsilon
a = 0.000001;
b = 100;
% Set the increment initially to a and increment so that it is multiplied
% by 10 every time
epsilonIncr = a;
zeta = 1;
for epsilonIncr = 1:9
epsilon = randfixedsum(n, N, 0, -a * zeta, a*zeta);
i = i + 1;
tic
   [deltaNorm_R(i), totalError_R(i), MSE_R(i)] = FirstMomentModel_SyntheticData(n_f, N, n, e, epsilon);
timeElapsed(i) = toc;

samplesArr(i) = zeta*a;
zeta = zeta * 10;
end
 
loglog(samplesArr, deltaNorm_R,  'LineWidth', 1);
hold on;
loglog(samplesArr, MSE_R, 'r',  'LineWidth', 1);
hold on;
loglog(samplesArr, abs(totalError_R), 'g',  'LineWidth', 1);
xlabel('Epsilon bound') % x-axis label
ylabel('Error Measure') % y-axis label
legend('Normalized Error','MSE','Total Error', 'Location','northwest')
title('Logarithmic plot of Error Measures versus Epsilon bound')

figure;
semilogx(samplesArr, deltaNorm_R, 'LineWidth', 1);
hold on;
semilogx(samplesArr, MSE_R, 'r', 'LineWidth', 1);
hold on;
semilogx(samplesArr, abs(totalError_R), 'g', 'LineWidth', 1);
xlabel('Epsilon bound') % x-axis label
ylabel('Error Measure') % y-axis label
legend('Normalized Error','MSE','Total Error', 'Location','northwest')
title('Semi-Logarithmic (x) plot of Error Measures versus Epsilon bound')
