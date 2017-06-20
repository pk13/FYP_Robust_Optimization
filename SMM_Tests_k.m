% Test for varying CI bounds
N=20;
n=30;
n_f=4;
samples = 4;

deltaNorm_R = zeros(samples*10,1);
MSE_R = zeros(samples*10,1);
totalError_R = zeros(samples*10,1);
MSE = zeros(samples*10,1);
deltaNorm = zeros(samples*10,1);
totalError = zeros(samples*10,1);
i=0;

epsilon = normrnd(0, 0.1 ,[n,N]);
Sig = 0.1;
for kappa =1.5:0.2:(samples*1)
    e = ones(N,1);
i=i+1;
   [deltaNorm_R(i), MSE_R(i) ,totalError_R(i),  deltaNorm(i), MSE(i), totalError(i)]  = SecondMomentModel_SyntheticData(n_f, N, n, epsilon, kappa, Sig);
end
 
samplesArr =  1.5:0.2:(samples*1)
plot(samplesArr', MSE_R(1:13), 'r',  'LineWidth', 1);
hold on;
plot(samplesArr', deltaNorm_R(1:13), 'g',  'LineWidth', 1);
hold on;
plot(samplesArr', MSE(1:13), 'y',  'LineWidth', 1);
hold on;
plot(samplesArr', deltaNorm(1:13), 'k',  'LineWidth', 1);
% xlim([0 460])
xlabel('k') % x-axis label
ylabel('Error Measure') % y-axis label
legend('MSE_{robust}','Normalized Error','MSE_{analytical}','Normalized Error_{analytical},''Location','northwest')
title('Plot of Error Measures versus CI bound')
grid on;