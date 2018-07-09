format longG;
% read data
fileFullName = 'C:\Users\tangheng\Dropbox\暑期实习\data\多种指数综合时间序列数据.xlsx';
[datatemp,T,S] = xlsread(fileFullName);
dateSeries = T(3:end,1);
hs300Series = datatemp(:,1);
zz500Series = datatemp(:,2);
zz800Series = datatemp(:,3);
zz1000Series = datatemp(:,4);
zzltSeries = datatemp(:,5);

%process Series
series = zz500Series;
%outcome:change of phase
[phase,maxlocation,minlocation,gt,ct,check] = ...
    BB_algorithm(dateSeries,series,100000,0.3);
for i = 1:size(phase,1)
    fprintf('%s\t%d\n',char(dateSeries(phase(i,1))),phase(i,2));
end
BB_plot(series,gt,ct,maxlocation,minlocation);



