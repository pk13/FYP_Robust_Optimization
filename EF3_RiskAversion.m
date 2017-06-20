% This script demonstrates the use of function QUADPROG on the basis of
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
% equal weights function for comparison purposes 
wEqual = 1/n*ones(n,1);
returnWEqual = mew'*wEqual;
riskWEqual = wEqual'*Sigma*wEqual;
%---------------------------
H = 2*Sigma;
f = -mew';
% Constraints:
% weights sum to one
Aeq = ones(1,n);
beq = 1;
% no short selling
lb = zeros(n,1);
ub = ones(n,1);
%----------Initialisations----------
% m is the iteration variable
m = 50;
weightsOpt = 0;
sigmaOpt = 0;
weightedReturnVec = zeros(m,1);
weightedRiskVec = zeros(m,1);
% Set risk aversion coefficient = 0 initially;
lambda = 0;
for i = 1 : m
% Produces a vector of optimal portfolio weights
[weightsOpt, output] = quadprog(lambda*H,f,[],[],Aeq, beq, lb, ub);
weightedReturnVec(i) = weightsOpt'*mew;
% Recalculate risk with optimal weights
weightedRiskVec(i)=weightsOpt'*Sigma*weightsOpt; 
% Update the risk aversion coefficient
lambda = i/20;
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