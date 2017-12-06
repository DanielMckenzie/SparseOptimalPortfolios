% This script compares three different investment strategies:
% 1. Naive, equally weighted portfolio
% 2. Least-squares, Markowitz portfolio computed using CVX.
% 3. Sparse portfolio computed using GSSP, for various sparsities.
%
%
clear, close all, clc
load('FF48.mat')

RR = IndustryPortfolios2./100;
numportfolios = 4;
numdates = size(RR,1);
MonthlyReturns = zeros(numportfolios,360);
AnnualReturns = zeros(numportfolios,30);
rho = 0.1/12; % `annualised' return of 10%
y = rho*ones(60,1);

for i = 60:12:408
    Inds = i-59:i;
    Portfolios = cell(numportfolios,1);
    Phi = RR(Inds,:);
    % Construct the equally weighted portfolio
    Portfolios{1} = ones(48,1)/48;
    AnnualReturns(1,i/12 - 4) = sum(RR(i+1:i+12,:)*Portfolios{1});
    MonthlyReturns(1,i-59:i-48) = RR(i+1:i+12,:)*Portfolios{1};
    %y = RR(Inds,:)*ones(48,1)./48;
    % Run the CVX based optimization
    mu_hat = ones(1,60)*Phi/60;
    C = [ones(1,48);mu_hat];
    cvx_begin
        variable w(48);
        minimize(norm(Phi*w-y));
        subject to
            C*w == [1;rho];
            zeros(48,1) <= w;
    cvx_end
    Portfolios{2} = w;
    AnnualReturns(2,i/12 - 4) = sum(RR(i+1:i+12,:)*Portfolios{2});
    MonthlyReturns(2,i-59:i-48) = RR(i+1:i+12,:)*Portfolios{2};
    % Run the Sparse-Convex based optimization, k=5
    w_ew = Phi*ones(48,1)/48; %returns on the equally weighted portfolio
    k = 5;
    x0 = zeros(48,1);
    x0(1) = 1/2;
    x0(2) = 1/2;
    f = @(w) (Phi*w - w_ew)'*(Phi*w - w_ew);
    g = @(w) Phi'*(Phi*w - w_ew);
    P = @(w) GSSP(w,1,k);
    [w,~] = PGMB(f,g,P,x0,0.1,1,0.25,1e-3,200);
    Portfolios{3} = w;
    AnnualReturns(3,i/12 - 4) = sum(RR(i+1:i+12,:)*Portfolios{3});
    MonthlyReturns(3,i-59:i-48) = RR(i+1:i+12,:)*Portfolios{3};
    % Run the Sparse-convex based optimization, k = 10
    k = 10;
    P = @(w) GSSP(w,1,k);
    [w,~] = PGMB(f,g,P,x0,0.1,1,0.25,1e-3,200);
    Portfolios{4} = w;
    AnnualReturns(4,i/12 - 4) = sum(RR(i+1:i+12,:)*Portfolios{4});
    MonthlyReturns(4,i-59:i-48) = RR(i+1:i+12,:)*Portfolios{4};
end

% Calculate the cumulative returns
 CumulativeReturns = zeros(size(MonthlyReturns));
 for j= 1:numportfolios
     CumulativeReturns(j,:) = cumsum(MonthlyReturns(j,:));
 end

colors = ['k', 'r', 'b', 'g'];
hold on
for j = 1:numportfolios
    opts = colors(j);
    plot(1:length(CumulativeReturns(j,:)), (1+CumulativeReturns(j,:)),opts);
end

% Making the plot look nice
legend('Equally Weighted', 'Least Squares', 'Sparse k=5', 'Sparse k=10')
set(gca,'fontsize',20)
xlabel('Months since July 1976', 'FontSize', 20)
ylabel('Value of Portfolio', 'FontSize', 20)

Means = mean(MonthlyReturns,2);
Risks = std(MonthlyReturns,0,2);
SharpeRatio = Means./Risks;
    
    


    