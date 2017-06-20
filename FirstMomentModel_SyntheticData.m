function [deltaNorm_R, totalError_R, MSE_R] = FirstMomentModel_SyntheticData(n_f, N, n, e, epsilon)

f = rand(n_f, N);
F1 = [ones(1, N); f];
% Generate a value for the model
x_real = rand(n, n_f);
X_real = [ones(n,1), x_real];
% Calculate M by adding the random variables via the factor model
M1 = epsilon + X_real*F1;

% Calculate Robust equivalent by assuming a zero-mean epsilon
% The subscript _R denotes the Robust version, i.e. our algorithm's
% performance
cvx_begin sdp quiet
    cvx_precision high
    variable gam;
    variable X_R(n,1+n_f);
    minimize(gam);
    subject to
    M1*e == X_R*F1*e;
    [gam*eye(N), M1'-F1'*X_R'; M1-X_R*F1, gam*eye(n)] >= 0;
cvx_end

% Evaluate model performance
% Recall that subscript _R denotes the Robust version, i.e. our algorithm's
% performance

delta_R = (X_R - X_real)./X_real;
deltaNorm_R = norm((X_R - X_real))./norm(X_real);
difference_R = X_R-X_real;
totalError_R = sum(sum(difference_R));
MSE_R = immse(X_R ,X_real);

[U,S,V] = svd(F1*F1')
X_test2 = (U*U')^-1*pinv(F1*F1')*F1*M1'
MSE1 = immse(X_test2', X_real)
deltaNorm_2 = norm((X_test2'- X_real))./norm(X_real);

X_test = M1*F1'/(F1*F1')
MSE2 = immse(X_test, X_real)
deltaNorm = norm((X_test- X_real))./norm(X_real);

end