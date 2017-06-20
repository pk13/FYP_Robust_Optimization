% Load market indices to be used as factors
% load Data_GlobalIdx2
% nIndices  = size(Data,2)-1;     % # of 5
% yields = Data(:,end);             % daily effective yields
% yields = 360 * log(1 + yields);   % continuously-compounded, annualized yield
% prices = Data(:,1:end-1);
% 
% plot(dates, ret2tick(tick2ret(prices,[],'continuous'),[],[],[],'continuous'))
% datetick('x')
% 
% xlabel('Date')
% ylabel('Index Value')
% title ('Normalized Daily Index Closings')
% legend(series{1:end-1}, 'Location', 'NorthWest')
% 
% %%%%%%%%%%%%%%% Factor Analysis %%%%%%%%%%%%%%%
% % Make our portfolio
% load BlueChipStockMoments
% % mret = MarketMean;
% % mrsk = sqrt(MarketVar);
% % cret = CashMean;
% % crsk = sqrt(CashVar);
% % n: number of assets
% [~,n] = size(AssetList);
% mew = AssetMean;
% 
% % Portfolio average return
% meanPortf = mean(mew);
% Sigma = AssetCovar;

% factorMeans = mean(prices);
% Fnorm= factorMeans';
% Fnorm = factorMeans'/norm(factorMeans');
% F = [1 ; Fnorm];

%%%%%%%%%%% MAIN PART %%%%%%%%%%%%
% Get comstruted dataset
[MKT, HML, SMB, VOD, BP, SHELL, GSK, SL] = DatasetHandling();
% Aim is to compare the models and prove that robustness is an improvement
% Define main parameters for Real historical data using the three-factor
% model
N=90;
n=5;
n_f=3;
e = ones(N,1);

% Construct Factor Matrix and Mean Returns Matrix using the Real Datasets
f1 = [double(MKT(1:90,2))' ; double(SMB(1:90,2))'; double(HML(1:90,2))'];
F1 = [ones(1, N); f1];
M1 = [double(VOD(1:90,2))'; double(BP(1:90,2))'; double(SHELL(1:90,2))';double(GSK(1:90,2))'; double(SL(1:90,2))'];
% The actual stock prices from day 91 to 100
M2real = [double(VOD(91:100,2))'; double(BP(91:100,2))'; double(SHELL(91:100,2))';double(GSK(91:100,2))'; double(SL(91:100,2))'];

% epsilon = randfixedsum(n, N, 0, -0.1, 0.1);
% Calculate Robust Model value

[X_R] = FirstMomentModel_RealData(M1, F1, N, n, n_f, e);

% Keep track of the epsilon assumed
epsilonCalc = M1-X_R*F1;

% Predict Robust Mean Returns using Factor Model
N2 = 10;
f2 = [double(MKT(91:100, 2))' ; double(SMB(91:100,2))'; double(HML(91:100,2))'];
F2 = [ones(1, N2); f2];

%%% Plot the stock prices from day 1 to 90
% samplesArr = 1:1:90;
% plot(samplesArr, M1(1,:), 'b');
% hold on;
% grid on;
% plot(samplesArr, M1(2,:), 'r');
% hold on;
% plot(samplesArr, M1(3,:), 'g');
% hold on;
% plot(samplesArr, M1(4,:), 'y');
% hold on;
% plot(samplesArr, M1(5,:),'k');
% xlabel('Time (days)') % x-axis label
% ylabel('Stock Returns (%)') % y-axis label
% set(gca,'xtick',0:5:90)
% legend('VOD','BP', 'SHELL', 'GSK', 'SL','Location','northwest')
% title('Plot of Stock Price Returns versus Time Horizon (days)')


% Calculate errors of model
samplesArr = 91:1:100;
M2 = X_R*F2;
delta = M2 - M2real;
MSE = zeros(n,1);
deltaNorm_R = zeros(n,1);
for j=1:10
MSE(j) = (immse(M2(:,j), M2real(:,j)));
deltaNorm_R(j) = norm((M2(:,j) - M2real(:,j)))./norm(M2real(:,j));
end
semilogy(samplesArr, MSE, 'r');
hold on;
semilogy(samplesArr, deltaNorm_R, 'b');
xlabel('Time (days)') % x-axis label
ylabel('Error Measure') % y-axis label
legend('MSE' , 'Normalized Error', 'Location','northwest');
title('Semi log plot of Error Measures versus Time Horizon for 5 stocks')

%%% Plot the projected stock prices from day 91 to 100sp1 = subplot(3,2,1);
sp1= subplot(3,2,1);
plot(samplesArr, M2real(1,:), 'b');
hold on;
grid on;
xlabel('Time (days)') % x-axis label
ylabel('Stock Returns (%)') % y-axis label
plot(samplesArr, M2(1,:), 'r');
legend('VOD_{real}', 'VOD_{robust}', 'Location','northwest')

sp2 = subplot(3,2,2);
plot(samplesArr, M2real(2,:), 'b');
hold on;
xlabel('Time (days)') % x-axis label
ylabel('Stock Returns (%)') % y-axis label
plot(samplesArr, M2(2,:), 'r');
legend('BP_{real}', 'BP_{robust}', 'Location','northwest')

sp3 = subplot(3,2,3);
plot(samplesArr, M2real(3,:), 'b');
hold on;
xlabel('Time (days)') % x-axis label
ylabel('Stock Returns (%)') % y-axis label
plot(samplesArr, M2(3,:), 'r');
legend('SHELL_{real}', 'SHELL_{robust}', 'Location','northwest')

sp4 = subplot(3,2,4);
plot(samplesArr, M2real(4,:), 'b');
hold on;
xlabel('Time (days)') % x-axis label
ylabel('Stock Returns (%)') % y-axis label
plot(samplesArr, M2(4,:), 'r');
legend('GSK_{real}', 'GSK_{robust}', 'Location','northwest')

sp5 = subplot(3,2,5);
plot(samplesArr, M2real(5,:), 'b');
hold on;
xlabel('Time (days)') % x-axis label
ylabel('Stock Returns (%)') % y-axis label
plot(samplesArr, M2(5,:), 'r');
legend('SL_{real}', 'SL_{robust}', 'Location','northwest')

grid(sp1, 'on');
grid(sp2, 'on');
grid(sp3, 'on');
grid(sp4, 'on');
grid(sp5, 'on');

set(gca,'xtick', 91:100)
% title('Plot of Mean Returns versus Time Horizon (days)')