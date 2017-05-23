%% Experimenting with the FF48 data set (without dividends).
clear, clc, close all
numportfolios = 20;

load('FF48.mat')
RR = IndustryPortfolios2./100;

numdates = size(RR,1);
MonthlyReturns = zeros(numportfolios+1,360);
AnnualReturns = zeros(numportfolios+1,30);

for i = 60:12:408
    Inds = i-59:i;
    Portfolios = cell(numportfolios,1);
    Phi = RR(Inds,:);
    y = RR(Inds,:)*ones(48,1)./48;
    for j = 1:numportfolios
        wOpt = GSSPIPT(Phi,y,200,2*j+8,1);
        Portfolios{j} = wOpt;
        AnnualReturns(j,i/12 - 4) = sum(RR(i+1:i+12,:)*Portfolios{j});
        MonthlyReturns(j,i-59:i-48) = RR(i+1:i+12,:)*Portfolios{j};
    end
    AnnualReturns(numportfolios+1,i/12-4) = sum(RR(i+1:i+12,:)*(ones(48,1)./48));
    MonthlyReturns(numportfolios+1,i-59:i-48) = RR(i+1:i+12,:)*(ones(48,1)./48);
end

MeanReturns = mean(AnnualReturns,2)
Risk = std(AnnualReturns,0,2)
SharpeRatio = MeanReturns./Risk

MeanMonthlyReturns = mean(MonthlyReturns,2);
MonthlyRisk = std(MonthlyReturns,0,2);
MonthlySharpeRatio = MeanMonthlyReturns./MonthlyRisk;

[[10:2:50]', MeanMonthlyReturns*100, MonthlyRisk*100, MonthlySharpeRatio]


% CumulativeReturns = zeros(size(MonthlyReturns));
% for j= 1:numportfolios+1
%     CumulativeReturns(j,:) = cumsum(MonthlyReturns(j,:));
% end
% 
% hold on
% plot(1:length(CumulativeReturns(1,:)), CumulativeReturns(1,:),'r')
% plot(1:length(CumulativeReturns(1,:)), CumulativeReturns(11,:),'k')
% figure
% hold on
% plot(1:length(CumulativeReturns(1,:)), CumulativeReturns(6,:),'r')
% plot(1:length(CumulativeReturns(1,:)), CumulativeReturns(11,:),'k')
% figure
% hold on
% plot(1:length(CumulativeReturns(1,:)), CumulativeReturns(10,:),'r')
% plot(1:length(CumulativeReturns(1,:)), CumulativeReturns(11,:),'k')


       
    
    
    
    

