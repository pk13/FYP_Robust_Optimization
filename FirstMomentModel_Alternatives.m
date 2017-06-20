function [deltaNorm_A, totalError_A, MSE_A] = FirstMomentModel_Alternatives(n_f, N, n, e, epsilon)

f = rand(n_f, N);
F1 = [ones(1, N); f];
% Generate a value for the model
x_real = rand(n, n_f);
X_real = [ones(n,1), x_real];
% Calculate M by adding the random variables via the factor model
M1 = epsilon + X_real*F1;


% ALTERNATIVE MODELS --- ONLY FOR REFERENCE
% FITPOLY VERSION
% Xa=ones(n, n_f+1);
% XF1= Xa*F1;
% fitpoly = fit(F1(:,1), M1(:,1), 'poly1')
% % Plot the fit with the plot method.
% plot(fitpoly, F1, M1)
% % tbl = table(Xa, M1, F1, 'VariableNames',{'FactorLoadings','MeanReturns', 'Factors'});
% % lm = fitlm(tbl,'M1~Xa*F1')

% SDP VERSION
% cvx_begin sdp quiet
%     cvx_precision high
%     variable epsi;
%     variable X(n,1+n_f);
%     minimize(epsi);
%     subject to
%     epsi>=0
%     M1 == X*F1 - epsi;
% cvx_end

% PINV VERSION
% X'  = pinv(F1*F1')*F1*(M1')*pinv(M1*M1');

% MATRIX MANIPULATIONS VERSION
% X_test = M1*F1'/(F1*F1');
% MSE = immse(X_test, X_real);
% deltaNorm = norm((X_test- X_real))./norm(X_real);
% totalError = sum(sum(difference_R));

% % % Linear optimization approximation
X=zeros(n_f+1,n);
f=ones(n_f+1, 1);
% Allow negative correlations between asset and factor
A=zeros(1, n_f+1);
B=zeros(1, 1);
for j = 1:n
    X(:,j) = linprog(f, A , B , F1(:,:)' , M1(j,:)');
end
% Transpose X to appropriate dimensions
X=X';

delta_A = (X - X_real)./X_real;
deltaNorm_A = norm((X - X_real))./norm(X_real);
difference_A = X-X_real;
totalError_A = sum(sum(difference_A));
MSE_A = immse(X,X_real);
end