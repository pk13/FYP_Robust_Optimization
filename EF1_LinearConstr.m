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
% Objective quadprog function 0.5*x'Hx + f'x subject to:  A*x <= b  and Aeq*x = beq 
% X = quadprog(H,f,A,b,Aeq,beq,LB,UB) defines a set of lower and upper
% bounds on the design variables, X, so that the solution is in the range LB <= X <= UB.
H = 2*Sigma;
f = zeros(n,1);
% Constraints:
% weights sum to one
Aeq = ones(1,n);
beq = 1;
% no short selling
lb = zeros(n,1);
ub = ones(n,1);
% return is set to pre-defined level
A = -mew';
b = 0;
% set return arbitrarily equal to value of an equally weighted portfolio
setReturn = abs(mew'*wEqual);
%----------Initialisations----------
% m is the iteration variable for different "set-return" values
m = 100;
weightsOpt = 0;
sigmaOpt = 0;
weightedReturnVec = zeros(m,1);
weightedRiskVec = zeros(m,1);
for i = 1 : m
% Produces a vector of optimal portfolio weights
[weightsOpt, weightedRisk] = quadprog(H,f,A,b,Aeq,beq,lb,ub);
weightedReturnVec(i) = weightsOpt'*mew;
weightedRiskVec(i)= weightedRisk;
% Update the set return constraint
b =  - setReturn*i/(0.6*m);
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
