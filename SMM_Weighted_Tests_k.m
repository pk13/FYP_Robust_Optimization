% Test for varying CI bounds
N=20;
n=30;
n_f=4;
samples = 60;

deltaNorm_R = zeros(samples*10,1);
MSE_R = zeros(samples*10,1);
totalError_R = zeros(samples*10,1);
MSE = zeros(samples*10,1);
deltaNorm = zeros(samples*10,1);
totalError = zeros(samples*10,1);
i=0;

epsilon = normrnd(0, 1 ,[n,N]);
Sig = 1;
% w1=50;
% w2=5;
% for kappa2 = 9 : 2 :(samples*1)
%     e = ones(N,1);
% i=i+1;
%    [deltaNorm_R(i), MSE_R(i) ,totalError_R(i),  deltaNorm(i), MSE(i), totalError(i)]  = SecondMomentModel_Weighted_SyntheticData(n_f, N, n, epsilon, kappa2, Sig, gamma2, w1, w2);
% end

for w1 = 1:5:20
for w2 = 1:5:20
[deltaNorm_R(w1,w2), MSE_R(w1,w2) ,totalError_R(w1,w2),  deltaNorm(w1,w2), MSE(w1,w2), totalError(w1,w2), gamma2(w1,w2), kappa2(w1,w2)]  = SecondMomentModel_Weighted_SyntheticData(n_f, N, n, epsilon, Sig, w1, w2);
end
end

% Plot surface plots
samplew1 = 1:5:20;
samplew2 = 1:5:20;
MSE_C = [ MSE_R(1,:); MSE_R(6,:); MSE_R(11,:); MSE_R(16,:)];
MSE_W = [ MSE_C(:,1) MSE_C(:,1)  MSE_C(:,1) MSE_C(:,1)];

MSEc = [ MSE(1,:); MSE(6,:); MSE(11,:); MSE(16,:)];
MSEw = [ MSEc(:,1) MSEc(:,1)  MSEc(:,1) MSEc(:,1)];

surf(samplew2, samplew1, MSE_W);
ylabel('w_1') % x-axis label
xlabel('w_2') % y-axis label
zlabel('MSE_R') % z-axis label

gammac = [ gamma2(1,:); gamma2(6,:); gamma2(11,:); gamma2(16,:)];
gammaw = [ gammac(:,1) gammac(:,1)  gammac(:,1) gammac(:,1)];

kappac = [ kappa2(1,:); kappa2(6,:); kappa2(11,:); kappa2(16,:)];
kappaw = [ kappac(:,1) kappac(:,1)  kappac(:,1) kappac(:,1)];

% samplesArr = 20 : 2 :(samples*1)
% subplot(1,2,1);
% plot(samplesArr', MSE_R(6:26), 'r',  'LineWidth', 1);
% hold on;
% plot(samplesArr', MSE(6:26), 'b',  'LineWidth', 1);
% legend('MSE_{robust}', 'MSE_{real}', 'Location','northwest');
% xlabel('k^2') % x-axis label
% ylabel('Error Measure') % y-axis label
% title('Plot of Error Measures versus CI bound')
% grid on;
% subplot(1,2,2);
% plot(samplesArr', deltaNorm_R(6:26), 'g',  'LineWidth', 1);
% hold on;
% plot(samplesArr', deltaNorm(6:26), 'k',  'LineWidth', 1);
% legend('Normalized Error_{robust}', 'Normalized Error_{real}', 'Location','northwest')
% 
% % xlim([0 460])
% xlabel('k^2') % x-axis label
% ylabel('Error Measure') % y-axis label
% title('Plot of Error Measures versus CI bound')
% grid on;