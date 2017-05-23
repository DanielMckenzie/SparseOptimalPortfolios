function x = GSSPIPT(A,b,numIters,s,lambda)
% Iterative projected thresholding to solve Ax = b subject to sum_{i}x_i =
% lambda and x_i >= 0 for all i. Uses the GSSP algorithm described in 
% Kyrillidis et al 'Sparse Projections on to the Simplex' 2013, JMLR.
% INPUT: Sensing matrix A, signal b. NumIters is number of iterations. 
% s is sparsity estimate. lambda describes the hyperplane.
% OUTPUT: recovered sparse signal x.
% Daniel Mckenzie 2017

[m,n] = size(A);
tol = 1e-4;

x = zeros(n,1); % initial guess for x

for i = 1:numIters
    y = x - 0.1*A'*(A*x - b);
    x = GSSP(y,lambda,s);
end
end