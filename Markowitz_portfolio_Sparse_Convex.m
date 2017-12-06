% Experimenting with FF48 data set (without dividends).
% Finding optimal portfolio using Projected Gradient descent (with
% backtracking) using Kyrillidis et al ('Sparse Projections on to the
% Simplex', 2013) description of the projection on to (simplex) intersect
% (k-sparse vectors) 
% Daniel Mckenzie 
% 5th December 2017
% 
% 
clear, clc, close all

load('FF48.mat')
RR = (IndustryPortfolios2./100);
Inds = 61:120;
Phi = RR(Inds,:);
w_ew = Phi*ones(48,1)/48;
k = 10;
x0 = zeros(48,1);
x0(1) = 1/2;
x0(2) = 1/2;

f = @(w) (Phi*w - w_ew)'*(Phi*w - w_ew);
g = @(w) Phi'*(Phi*w - w_ew);
P = @(w) GSSP(w,1,k);

[w,~] = PGMB(f,g,P,x0,0.1,1,0.25,1e-3,200);

