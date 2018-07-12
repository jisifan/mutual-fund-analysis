format long g;
% read data
startTime = '2006-01-04';
endTime = '2018-07-11';
indexcode = '000902.CSI';%zzlt index 
fundcode = '000001.OF';
%fundDuration = 360;%how many trade day did we use since fund setup
fundEndDate = endTime;%get fund data until this time(not use)
dateFormat = 'yyyy-mm-dd';

w = windmatlab;
% [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd(indexcode,'close,adjfactor',startTime,endTime,'Currency=CNY','PriceAdj=B');
% [w_tdays_data,w_tdays_codes,w_tdays_fields,w_tdays_times,w_tdays_errorid,w_tdays_reqid]=w.tdays(startTime,endTime);
% index_fuquan = w_wsd_data(:,1) .* w_wsd_data(:,2);
% timess = ismember(w_tdays_times,w_wsd_times);%test pricedata's corresponding date
% tradedays = w_tdays_data(timess == ones(length(timess),1));
% WindTimeList = w_tdays_times(timess == ones(length(timess),1));
% save('datatemp.mat','index_fuquan','tradedays','WindTimeList');
load('datatemp.mat');

series = index_fuquan;
dateSeries = tradedays;


%outcome:change of period
[period,maxlocation,minlocation,gt,ct,check] = ...
    BB_algorithm(dateSeries,series,100000,0.2);
WindSelectedTime = WindTimeList(period(:,1));%select all wind timestamp corresponding to period location
% for i = 1:size(period,1)
%     fprintf('%s\t%d\n',char(dateSeries(period(i,1))),period(i,2));
% end
BB_plot(dateSeries,series,gt,ct,maxlocation,minlocation);

%% start doing with data

fileFullName = 'C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\fundCodeList.xlsx';
[datatemp,T,S] = xlsread(fileFullName);
fundCodeList = T(:,1);
fundNameList = T(:,2);

outputMatrix = [];
fundDateVector = [];











for fundI = 1:length(fundCodeList)
fundcode = fundCodeList(fundI);
periodPeerRank = [];%qujian huibao paiming
dateLocation = [];%suozai ri qi
peakOrTrough = [];
[w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd(fundcode,'sec_name',strrep(dateSeries(period(1,1)),'/','-'),strrep(dateSeries(period(1,1)),'/','-'),'Currency=CNY','PriceAdj=B');
fundname = w_wsd_data;%fund name
[w_wss_data,w_wss_codes,w_wss_fields,w_wss_times,w_wss_errorid,w_wss_reqid]=w.wss(fundcode,'fund_setupdate');

fundSetup = w_wss_data;%fund setup date
% [w_tdays_data,w_tdays_codes,w_tdays_fields,w_tdays_times,w_tdays_errorid,w_tdays_reqid]=w.tdays(strrep(fundSetup,'/','-'),strrep(fundSetup,'/','-'));
WDfundSetupTimeStamp = datenum(fundSetup);%fund setup timestamp

%the end time we analysis, duration means how long since fund setup

%************************use duration, or use given end time;
% fundEndDate = datestr(WDfundSetupTimeStamp+duration,dateFormat);
WDfundEndTimeStamp = datenum(fundEndDate);
% [w_tdays_data,w_tdays_codes,w_tdays_fields,w_tdays_times,w_tdays_errorid,w_tdays_reqid]=w.tdays(fundEndDate,fundEndDate);
% WDfundEndTimeStamp = w_tdays_times;%fund end timestamp(not accurally end,just get data until this moment)s

for i = 1:(size(period,1)-1)
    %fund not setup then continue
    location = 0;
    signal = false;
    if WDfundSetupTimeStamp >= WindSelectedTime(i+1)
        continue;
    %fund just set up then use setup date as startdate
    elseif WindSelectedTime(i) <= WDfundSetupTimeStamp && WDfundSetupTimeStamp < WindSelectedTime(i+1)
        timestart = strcat('startdate=',strrep(fundSetup,'/','-'));
        startlocation = find(WindTimeList==WDfundSetupTimeStamp);
    %fund just set up then use setup date as startdate
    else 
        timestart = strcat('startdate=',strrep(dateSeries(period(i,1)),'/','-'));
        startlocation = period(i,1);
    end
    
    if WDfundEndTimeStamp >= WindSelectedTime(i+1)
        timeend = strcat('enddate=',strrep(dateSeries(period(i+1,1)),'/','-'));
        endlocation = find(WindTimeList==WDfundEndTimeStamp);
    %fund just set up then use setup date as startdate
    elseif WindSelectedTime(i) <= WDfundEndTimeStamp && WDfundEndTimeStamp < WindSelectedTime(i+1)
        timeend = {strcat('enddate=',fundEndDate)};
        endlocation = find(WindTimeList==WDfundEndTimeStamp);
        signal = true;
    %fund just set up then use setup date as startdate
    else 
        break;
    end
    [w_wss_data,w_wss_codes,w_wss_fields,w_wss_times,w_wss_errorid,w_wss_reqid]=w.wss(fundcode,'peer_fund_return_rank_prop_per',timestart,timeend,'fundType=1');
    dateLocation = [dateLocation;startlocation];
    if signal || i == size(period,1)-1
        dateLocation = [dateLocation;endlocation];
    end
    peakOrTrough =[peakOrTrough;period(i,2)];
    if signal || i == size(period,1)-1
        peakOrTrough =[peakOrTrough;period(i+1,2)];
    end
    periodPeerRank = [periodPeerRank;w_wss_data];
end


fprintf('%s\n',char(fundcode));

T1 = peakOrTrough(2:end)-peakOrTrough(1:end-1);%ţ����
T2 = dateLocation(2:end)-dateLocation(1:end-1);%����

temp_matrix = [T1,T2,periodPeerRank];%��ţ�У�����ʱ�䣬����
outcome = [1,0,0,0;0,0,0,0;-1,0,0,0];%��ţ�У������������ּ��Σ�ƽ������
bull = [];
fluction = [];
bear = [];
for i = 1:size(temp_matrix,1)
    if temp_matrix(i,1) == 1
        bull = [bull;temp_matrix(i,:)];
    elseif temp_matrix(i,1) == 0
        fluction = [fluction;temp_matrix(i,:)];
    elseif temp_matrix(i,1) == -1
        bear = [bear;temp_matrix(i,:)];
    end
end

bullRank = bull(:,3)'*bull(:,2)/sum(bull(:,2));
fluctionRank = fluction(:,3)'*fluction(:,2)/sum(fluction(:,2));
bearRank = bear(:,3)'*bear(:,2)/sum(bear(:,2));
outcome(1:3,2:4) = [sum(bull(:,2)),size(bull,1),bullRank;...
    sum(fluction(:,2)),size(fluction,1),fluctionRank;...
    sum(bear(:,2)),size(bear,1),bearRank];

outputMatrix = [outputMatrix;size(bear,1),size(fluction,1),size(bull,1),sum(bear(:,2)),sum(fluction(:,2)),sum(bull(:,2)),bearRank,fluctionRank,bullRank];
fundDateVector = [fundDateVector;fundSetup];
end

xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\allFundCompare.xlsx',{'�������','��������','��������','���о�������','���о�������','ţ�о�������','���о���������','���о���������','ţ�о���������','���о���ƽ������','���о���ƽ������','ţ��ƽ������'},1,'A1');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\allFundCompare.xlsx',fundCodeList,1,'A2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\allFundCompare.xlsx',fundNameList,1,'B2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\allFundCompare.xlsx',fundDateVector,1,'C2');
xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\allFundCompare.xlsx',outputMatrix,1,'D2')

% xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result2.xlsx',{'ţ���У�1��ţ��0�����У�-1���ܣ�'},2,'A1');
% xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result2.xlsx',{'������'},2,'B1');
% xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result2.xlsx',{'��������'},2,'C1');
% xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result2.xlsx',{'ƽ������'},2,'D1');
% xlswrite('C:\Users\tangheng\Dropbox\����ʵϰ\����\mutual-fund-analysis\result2.xlsx',outcome,2,'A2');
