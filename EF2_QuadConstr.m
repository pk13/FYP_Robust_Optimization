% This script demonstrates the use of SDP solver on the basis of
% the Markowitz mean-variance portfolio optimization problen 
clear close all clc warning 'off'
%Load standard matlab example for monthly total returns of a universe of 30 "blue-chip" stocks
load BlueChipStockMoments
mret = MarketMean;
mrsk = sqrt(MarketVar);
cret = CashMean;
crsk = sqrt(CashVar);
% n: number of assets
[~,n] = size(AssetList);
mew = AssetMean;
Sigma = AssetCovar;
% equal weights functions for comparison purposes 
wEqual = 1/n*ones(n,1);
returnWEqual = mew'*wEqual;
riskWEqual = wEqual'*Sigma*wEqual;

%----------Initialisations----------
% m is the iteration variable for different "set-return" values
m = 50; 
% set return equal to value of an equally weighted portfolio
setRisk = abs(wEqual'*AssetCovar*wEqual);
weightedRiskVec = zeros(m,1);
weightedReturnVec = zeros(m,1);
w = zeros(n,1);
g=0; 
for i = 1 : m
% Set maximum level of risk as a constant plus a variable
g = 0.0015 + setRisk*3*i/m;
e = ones(n,1);
cvx_begin sdp quiet
cvx_precision high
variable w(n);
maximize(mew'*w);

subject to
e'*w == 1;
for j=1:n
    w(j)>=0;
end
[g, w'; w, inv(Sigma)] >= 0;
cvx_end
weightedRiskVec(i)  = w'*Sigma*w;
weightedReturnVec(i) = w'*mew;
e = (eig([g, w'; w, inv(Sigma)]));
end
% plot efficient frontier
hold on;
plot(weightedRiskVec, weightedReturnVec, '','LineWidth',1.5)
legend('Efficient Frontier','Location','NorthWest')
title('Mean-Variance Efficient Frontier','FontSize',17)
xlabel('\sigma')
ylabel('\mu')
ticks = get(gca,'YTick');
set(gca,'YTickLabel',[num2str(ticks'*100),repmat('%',length(ticks),1)])
ticks = get(gca,'XTick');
set(gca,'XTickLabel',[num2str(ticks'*100),repmat('%',length(ticks),1)])