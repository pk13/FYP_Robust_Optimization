function [deltaNorm_R, MSE_R,totalError_R,  deltaNorm, MSE, totalError ] = SecondMomentModel_SyntheticData(n_f, N, n, epsilon, kappa, Sig)

e = ones(N,1);
% epsilon = normrnd(0.05, 0.001 ,[n,N]);
f = rand(n_f, N);
F1 = [ones(1, N); f];
x_real = rand(n, n_f);
X_real = [ones(n,1), x_real];
M1 = epsilon + X_real*F1;
eSelector = eye(N,N);

% Sig=0.001;
% kappa=3.1;

cvx_begin sdp quiet
    cvx_precision high
    variable X_R(n,1+n_f);
    minimize(norm(M1-X_R*F1));
    subject to
%     abs((M1-X_R*F1)*e)<=0;
    M1*e == X_R*F1*e;
    for i=1:N
        e1 = eSelector(:,i);
        [kappa^2*eye(1), e1'*(M1-X_R*F1)' ; (M1-X_R*F1)*e1, Sig*eye(n)] >= 0;
    end
cvx_end

% Evaluate model performance
delta_R = (X_R - X_real)./X_real;
deltaNorm_R = norm((X_R - X_real))./norm(X_real);
difference_R = X_R-X_real;
totalError_R = sum(sum(difference_R));
MSE_R = immse(X_R ,X_real);

X_test = M1*F1'/(F1*F1');
MSE = immse(X_test, X_real);
deltaNorm = norm((X_test- X_real))./norm(X_real);
totalError = sum(sum(difference_R));

meanarray= mean(epsilon);
meanmean = mean(meanarray);
end