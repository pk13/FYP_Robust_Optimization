% Load market indices to be used as factors
load Data_GlobalIdx2
nIndices  = size(Data,2)-1;     % # of 5
yields = Data(:,end);             % daily effective yields
yields = 360 * log(1 + yields);   % continuously-compounded, annualized yield
prices = Data(:,1:end-1);

plot(dates, ret2tick(tick2ret(prices,[],'continuous'),[],[],[],'continuous'))
datetick('x')

xlabel('Date')
ylabel('Index Value')
title ('Normalized Daily Index Closings')
legend(series{1:end-1}, 'Location', 'NorthWest')

%%%%%%%%%%%%%%% Factor Analysis %%%%%%%%%%%%%%%
% Make our portfolio
load BlueChipStockMoments
% mret = MarketMean;
% mrsk = sqrt(MarketVar);
% cret = CashMean;
% crsk = sqrt(CashVar);
% n: number of assets
[~,n] = size(AssetList);
mew = AssetMean;

% Portfolio average return
meanPortf = mean(mew);
Sigma = AssetCovar;

% factorMeans = mean(prices);
% Fnorm= factorMeans';
% Fnorm = factorMeans'/norm(factorMeans');
% F = [1 ; Fnorm];

%%%%%%%%%%% MAIN PART %%%%%%%%%%%%
% Aim is to compare the models and prove that robustness is an improvement
% Define main parameters for Real historical data using the three-factor
% model
N=45;
n=1;
n_f=3;
e = ones(N,1);

% Construct Factor Matrix and Mean Returns Matrix using the Real Datasets
f1 = [double(MKT(1:45,2))' ; double(SMB(1:45,2))'; double(HML(1:45,2))'];
F1 = [ones(1, N); f1];
M1 = [double(VOD(1:45,2))'];
M2real = [double(VOD(46:50,2))'];
% epsilon = randfixedsum(n, N, 0, -0.1, 0.1);
% Calculate Robust Model value

[X_R] = ModelPerformanceRealData(M1, F1, N, n, n_f, e);

% Keep track of the epsilon assumed
epsilonCalc = M1-X_R*F1;

% Predict Robust Mean Returns using Factor Model
N2 = 5;
f2 = [double(MKT(46:50, 2))' ; double(SMB(46:50,2))'; double(HML(46:50,2))'];
F2 = [ones(1, N2); f2];

samplesArr = 46:1:50;
M2 = X_R*F2;
delta = M2 - M2real;
MSE = (immse(M2, M2real));
plot(samplesArr, M2real);
hold on;
grid on;
plot(samplesArr, M2, 'r');
xlabel('Mean Returns') % x-axis label
ylabel('Error Measure') % y-axis label
set(gca,'xtick',45:50)
legend('Real Mean Returns','Projected Robust Mean Returns','Location','northwest')
title('Plot of Mean Returns versus Time Horizon (days)')