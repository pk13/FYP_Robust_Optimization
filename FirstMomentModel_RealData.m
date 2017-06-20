function [X_R] = FirstMomentModel_RealData(M1, F1, N, n, n_f, e)
% Calculate Robust model by assuming a zero-mean epsilon
cvx_begin sdp quiet
    cvx_precision high
    variable gam;
    variable X_R(n,1+n_f);
    minimize(gam);
    subject to
    M1*e == X_R*F1*e;
    [gam*eye(N), M1'-F1'*X_R'; M1-X_R*F1, gam*eye(n)] >= 0;
cvx_end
end