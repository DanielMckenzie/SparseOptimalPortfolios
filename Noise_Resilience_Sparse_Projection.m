% Experimenting with the FF48 data set (without dividends).
% Testing resilience to small amounts of noise.
% Use sparse projection following Kyrillidis et al.
% Daniel Mckenzie
% 5th December 2017
%
% 
clear, clc, close all

load('FF48.mat')
RR = (IndustryPortfolios2./100);
Inds = 61:120;
Phi = RR(Inds,:);
k = 10;
x0 = zeros(48,1);
x0(1) = 1/2;
x0(2) = 1/2;
W = zeros(48,3);

for j = 1:3
    if j >=2
        Phi2 = Phi + 0.01*randn(size(Phi));
    else
        Phi2 = Phi;
    end
    w_ew = Phi2*ones(48,1)/48;
    f = @(w) (Phi2*w - w_ew)'*(Phi2*w - w_ew);
    g = @(w) Phi2'*(Phi2*w - w_ew);
    P = @(w) GSSP(w,1,k);
    [w,~] = PGMB(f,g,P,x0,0.1,1,0.25,1e-3,200);
    W(:,j) = w;
end

colors = ['k', 'r', 'b', 'g'];


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
legend({'X', 'X_1', 'X_2'}, 'Fontsize', 12)
