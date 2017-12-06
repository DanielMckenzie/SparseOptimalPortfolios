% Experimenting with the FF48 data set (without dividends).
% Finding optimal portfolio using CVX
% This script demonstrates the lack of resilience to noise.
% 
clear, clc, close all

load('FF48.mat')
RR = (IndustryPortfolios2./100);
Inds = 61:120;
Phi = RR(Inds,:);


rho = 0.1/12; % `annualised' return of 10%
y = rho*ones(60,1);
W = zeros(48,10);

for j = 1:3
    if j >=2
        Phi2 = Phi + 0.01*randn(size(Phi));
    else
        Phi2 = Phi;
    end
    mu_hat = ones(1,60)*Phi2/60;
    C = [ones(1,48);mu_hat];
    cvx_begin
        variable w(48);
        minimize(norm(Phi2*w-y));
        subject to
            C*w == [1;rho];
            zeros(48,1) <= w;
    cvx_end
    W(:,j) = w;
end

colors = ['k', 'r', 'b', 'g'];
%hold on
% for j = 1:4
%     opts = strcat(colors(j),'*');
%     w_current = W(:,j);
%     w_current(w_current <= 1e-1) = nan;
%     plot(1:48,w_current,opts);
% end

figure, hold on
for j = 1:3
    opts = strcat(colors(j),'*');
    w_current = W(:,j);
    vals = sort(w_current,'descend');
    thresh1 = vals(5);
    thresh2 = vals(11);
    %w_current(w_current >= thresh1) = nan;
    w_current(w_current <= thresh2) = nan;
    plot(1:48,w_current,opts);
end

set(gca,'fontsize',20)
xlabel('Stocks', 'FontSize', 20)
ylabel('Weights', 'FontSize', 20)
