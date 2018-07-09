format longG;
% read data
fileFullName = 'C:\Users\tangheng\Dropbox\����ʵϰ\data\����ָ���ۺ�ʱ����������.xlsx';
[datatemp,T,S] = xlsread(fileFullName);
dateSeries = T(3:end,1);
hs300Series = datatemp(:,1);
zz500Series = datatemp(:,2);
zz800Series = datatemp(:,3);
zz1000Series = datatemp(:,4);
zzltSeries = datatemp(:,5);

%process Series
series = hs300Series;
%outcome:change of phase
[phase,maxlocation,minlocation,gt,ct,check] = ...
    BB_algorithm(dateSeries,series,100000,0.3);
for i = 1:size(phase,1)
    fprintf('%s\t%d\n',char(dateSeries(phase(i,1))),phase(i,2));
end
BB_plot(dateSeries,series,gt,ct,maxlocation,minlocation);

%get result
series = hs300Series;
[hs300_phase,maxlocation,minlocation,hs300_gt,hs300_ct,check] = ...
    BB_algorithm(dateSeries,series,100000,0.3);

series = zz500Series;
[zz500_phase,maxlocation,minlocation,zz500_gt,zz500_ct,check] = ...
    BB_algorithm(dateSeries,series,100000,0.3);

series = zz800Series;
[zz800_phase,maxlocation,minlocation,zz800_gt,zz800_ct,check] = ...
    BB_algorithm(dateSeries,series,100000,0.3);

series = zz1000Series;
[zz1000_phase,maxlocation,minlocation,zz1000_gt,zz1000_ct,check] = ...
    BB_algorithm(dateSeries,series,100000,0.3);

series = zzltSeries;
[zzlt_phase,maxlocation,minlocation,zzlt_gt,zzlt_ct,check] = ...
    BB_algorithm(dateSeries,series,100000,0.3);

%write dateSeries in sheet1
%% all timeSeries
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'index'},1,'A1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',1:length(dateSeries),1,'A2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'date'},1,'B1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',dateSeries,1,'B2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'hs300Series'},1,'C1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',hs300Series,1,'C2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'zz500Series'},1,'D1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',zz500Series,1,'D2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'zz800Series'},1,'E1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',zz800Series,1,'E2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'zz1000Series'},1,'F1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',zz1000Series,1,'F2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'zzltSeries'},1,'G1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',zzltSeries,1,'G2');


%% write all three priceSeries in sheet2
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'hs300_phase'},2,'A1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',hs300_phase,2,'A2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'zz500_phase'},2,'D1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',zz500_phase,2,'D2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'zz800_phase'},2,'H1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',zz800_phase,2,'H2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'zz1000_phase'},2,'K1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',zz1000_phase,2,'K2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',{'zzlt_phase'},2,'N1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx',zzlt_phase,2,'N2');

%% write all extreme point's date in sheet2
extremeIndexList = sort(unique([hs300_phase(:,1);zz500_phase(:,1);zz800_phase(:,1);zz1000_phase(:,1);zzlt_phase(:,1)]));
extremeDateList = dateSeries(extremeIndexList);
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    {'index'},2,'A19');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    {'date'},2,'B19');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    extremeIndexList,2,'A20');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    extremeDateList,2,'B20');

%% write all extreme value in one matrix
phase = hs300_phase;
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    {'hs300_phase'},2,'C19');
[Lia1,Locb1] = ismember(extremeIndexList,phase(:,1));
emptyV = zeros(length(extremeIndexList),1);
emptyV = emptyV - 1;
for i = 1:length(extremeIndexList)
    if Lia1(i) ~= 0
        emptyV(i) = phase(Locb1(i),2);
    end
end
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    emptyV,2,'C20');

phase = zz500_phase;
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    {'zz500_phase'},2,'D19');
[Lia1,Locb1] = ismember(extremeIndexList,phase(:,1));
emptyV = zeros(length(extremeIndexList),1);
emptyV = emptyV - 1;
for i = 1:length(extremeIndexList)
    if Lia1(i) ~= 0
        emptyV(i) = phase(Locb1(i),2);
    end
end
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    emptyV,2,'D20');

phase = zz800_phase;
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    {'zz800_phase'},2,'E19');
[Lia1,Locb1] = ismember(extremeIndexList,phase(:,1));
emptyV = zeros(length(extremeIndexList),1);
emptyV = emptyV - 1;
for i = 1:length(extremeIndexList)
    if Lia1(i) ~= 0
        emptyV(i) = phase(Locb1(i),2);
    end
end
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    emptyV,2,'E20');

phase = zz1000_phase;
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    {'zz1000_phase'},2,'F19');
[Lia1,Locb1] = ismember(extremeIndexList,phase(:,1));
emptyV = zeros(length(extremeIndexList),1);
emptyV = emptyV - 1;
for i = 1:length(extremeIndexList)
    if Lia1(i) ~= 0
        emptyV(i) = phase(Locb1(i),2);
    end
end
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    emptyV,2,'F20');

phase = zzlt_phase;
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    {'zzlt_phase'},2,'G19');
[Lia1,Locb1] = ismember(extremeIndexList,phase(:,1));
emptyV = zeros(length(extremeIndexList),1);
emptyV = emptyV - 1;
for i = 1:length(extremeIndexList)
    if Lia1(i) ~= 0
        emptyV(i) = phase(Locb1(i),2);
    end
end
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result.xlsx', ...
    emptyV,2,'G20');




