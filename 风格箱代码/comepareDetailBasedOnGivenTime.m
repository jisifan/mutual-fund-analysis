format long g;
% read data
startTime = '2006-01-04';
endTime = '2018-08-01';
% indexcode = '000902.CSI';%zzlt index
indexcode = '000906.SH';%zz800
% indexcode = '000300.SH';%zz800
fundcode = '000001.OF';
fundStartDate = '2014-09-16';
%fundDuration = 360;%how many trade day did we use since fund setup
fundEndDate = '2018-04-28';%get fund data until this time(not use)
dateFormat = 'yyyy-mm-dd';
fileFullName = 'C:\Users\tangheng\Dropbox\summerIntern\代码\mutual-fund-analysis\fundCodeList-ultimate.xlsx';
outputFile = 'C:\Users\tangheng\Dropbox\summerIntern\代码\mutual-fund-analysis\comepareDetail.xlsm';

%% data prepare
w = windmatlab;
[w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd(indexcode,'close,adjfactor',startTime,endTime,'Currency=CNY','PriceAdj=B');
[w_tdays_data,w_tdays_codes,w_tdays_fields,w_tdays_times,w_tdays_errorid,w_tdays_reqid]=w.tdays(startTime,endTime);
index_fuquan = w_wsd_data(:,1) .* w_wsd_data(:,2);
timess = ismember(w_tdays_times,w_wsd_times);%test pricedata's corresponding date
tradedays = w_tdays_data(timess == ones(length(timess),1));
WindTimeList = w_tdays_times(timess == ones(length(timess),1));
save('datatemp.mat','index_fuquan','tradedays','WindTimeList');
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
[datatemp,T,S] = xlsread(fileFullName);
fundCodeList = T(:,1);
fundNameList = T(:,2);
fundStartTimeStamp = datenum(fundStartDate);

outputMatrix = [];
outputMatrix2 = [];
fundDateVector = [];
fundCodeVector = [];
fundNameVector = [];
fundInvestTypeVector = [];

%get first location(time)
Tstart = 1;
for i = 1:(size(period,1)-1)
    if fundStartTimeStamp >= WindSelectedTime(i+1)
        continue;
    end
    Tstart = i;
    break;
end

for fundI = 1:length(fundCodeList)
    fundcode = fundCodeList(fundI);
    fundname = fundNameList(fundI);
    periodPeerRank = [];%qujian huibao paiming
    dateLocation = [];%suozai ri qi
    peakOrTrough = [];
    

    [w_wss_data,w_wss_codes,w_wss_fields,w_wss_times,w_wss_errorid,w_wss_reqid]=w.wss(fundcode,'fund_setupdate');
    
    fundSetup = w_wss_data;%fund setup date
    
    % [w_tdays_data,w_tdays_codes,w_tdays_fields,w_tdays_times,w_tdays_errorid,w_tdays_reqid]=w.tdays(strrep(fundSetup,'/','-'),strrep(fundSetup,'/','-'));
    WDfundSetupTimeStamp = datenum(fundSetup);%fund setup timestamp
    
    if WDfundSetupTimeStamp > fundStartTimeStamp
        continue;
    end
    
    [w_wss_data,w_wss_codes,w_wss_fields,w_wss_times,w_wss_errorid,w_wss_reqid]=w.wss(fundcode,'fund_investtype');
    fundInvestType = w_wss_data;
    %the end time we analysis, duration means how long since fund setup
    
    %************************use duration, or use given end time;
    % fundEndDate = datestr(WDfundSetupTimeStamp+duration,dateFormat);
    WDfundEndTimeStamp = datenum(fundEndDate);
    % [w_tdays_data,w_tdays_codes,w_tdays_fields,w_tdays_times,w_tdays_errorid,w_tdays_reqid]=w.tdays(fundEndDate,fundEndDate);
    % WDfundEndTimeStamp = w_tdays_times;%fund end timestamp(not accurally end,just get data until this moment)s
    
    for i = Tstart:(size(period,1)-1)
        %fund not setup then continue
        location = 0;
        signal = false;
        if fundStartTimeStamp >= WindSelectedTime(i+1)
            continue;
            %fund just set up then use setup date as startdate
        elseif WindSelectedTime(i) <= fundStartTimeStamp && fundStartTimeStamp < WindSelectedTime(i+1)
            timestart = strcat('startdate=',strrep(fundStartDate,'/','-'));
            startlocation = find(WindTimeList==fundStartTimeStamp);
            if size(startlocation,1) == 0
                j = 1;
                while size(startlocation,1) == 0
                    startlocation = find(WindTimeList==fundStartTimeStamp+j);
                    j = j + 1;
                end
            end
            %fund just set up then use setup date as startdate
        else
            timestart = strcat('startdate=',strrep(dateSeries(period(i,1)),'/','-'));
            startlocation = period(i,1);
        end
        
        if WDfundEndTimeStamp >= WindSelectedTime(i+1)
            timeend = strcat('enddate=',strrep(dateSeries(period(i+1,1)),'/','-'));
            endlocation = find(WindTimeList==WDfundEndTimeStamp);
            if size(endlocation,1) == 0
                j = 1;
                while size(endlocation,1) == 0
                    endlocation = find(WindTimeList==WDfundEndTimeStamp-j);
                    j = j+1;
                end
            end
            %fund just set up then use setup date as startdate
        elseif WindSelectedTime(i) <= WDfundEndTimeStamp && WDfundEndTimeStamp < WindSelectedTime(i+1)
            timeend = {strcat('enddate=',fundEndDate)};
            endlocation = find(WindTimeList==WDfundEndTimeStamp);
            if size(endlocation,1) == 0
                j = 1;
                while size(endlocation,1) == 0
                    endlocation = find(WindTimeList==WDfundEndTimeStamp-j);
                    j = j+1;
                end
            end
            signal = true;
            %fund just set up then use setup date as startdate
        else
            break;
        end
        [w_wss_data,w_wss_codes,w_wss_fields,w_wss_times,w_wss_errorid,w_wss_reqid]=w.wss(fundcode,'peer_fund_return_rank_prop_per',timestart,timeend,'fundType=3');
        dateLocation = [dateLocation;startlocation];
        if signal || i == size(period,1)-1
            dateLocation = [dateLocation;endlocation];
        end
        peakOrTrough =[peakOrTrough;period(i,3)];
        if signal || i == size(period,1)-1
            peakOrTrough =[peakOrTrough;period(i+1,3)];
        end
        periodPeerRank = [periodPeerRank;w_wss_data];
    end
   
    fprintf('%s\n',char(fundcode));
    
    T1 = peakOrTrough(1:(end-1));%牛熊市
    T2 = datenum(dateSeries(dateLocation(2:end)))- datenum(dateSeries(dateLocation(1:end-1)));%天数
    
    if iscell(periodPeerRank)
        periodPeerRank = cell2mat(periodPeerRank);
    end
    
    temp_matrix = [T1,T2,periodPeerRank];%熊牛市，持续时间，排名
    outcome = [1,0,0,0;0,0,0,0;-1,0,0,0];%熊牛市，总天数，出现几次，平均排名
    bull = [];
    fluction = [];
    bear = [];
    if size(temp_matrix,1)>0 && size(temp_matrix,2)>0
        for i = 1:size(temp_matrix,1)
            if temp_matrix(i,1) == 1
                bull = [bull;temp_matrix(i,:)];
            elseif temp_matrix(i,1) == 0
                fluction = [fluction;temp_matrix(i,:)];
            elseif temp_matrix(i,1) == -1
                bear = [bear;temp_matrix(i,:)];
            end
        end
    end
   
    if size(bull,1)>0
        bullRank = bull(:,3)'*bull(:,2)/sum(bull(:,2));
        daysbull = sum(bull(:,2));
        Nbull = size(bull,1);
    else
        bullRank = 0;
        daysbull=0;
        Nbull=0;
    end
    
    if size(fluction,1)>0
        fluctionRank = fluction(:,3)'*fluction(:,2)/sum(fluction(:,2));
        daysfluction = sum(fluction(:,2));
        Nfluction = size(fluction,1);
    else
        fluctionRank = 0;
        daysfluction = 0;
        Nfluction = 0;
    end
    
    if size(bear,1)>0
        bearRank = bear(:,3)'*bear(:,2)/sum(bear(:,2));
        daysbear = sum(bear(:,2));
        Nbear = size(bear,1);
    else
        bearRank = 0;
        daysbear = 0;
        Nbear = 0;
    end
    
    outcome(1:3,2:4) = [daysbull,Nbull,bullRank;...
        daysfluction,Nfluction,fluctionRank;...
        daysbear,Nbear,bearRank];
    
    fundCodeVector = [fundCodeVector;fundcode];
    fundNameVector = [fundNameVector;fundname];
    outputMatrix = [outputMatrix;periodPeerRank'];
    outputMatrix2 = [outputMatrix2;Nbear,Nfluction,Nbull,daysbear,daysfluction,daysbull,bearRank,fluctionRank,bullRank];
    fundDateVector = [fundDateVector;fundSetup];
    fundInvestTypeVector = [fundInvestTypeVector;fundInvestType];
end


xlswrite(outputFile,{'基金代码','基金名称','基金投资类型','成立日期','熊市经历几次','震荡市经历几次','牛市经历几次','熊市经历总天数','震荡市经历总天数','牛市经历总天数','熊市经历平均排名','震荡市经历平均排名','牛市平均排名'},1,'A1');
xlswrite(outputFile,fundCodeVector,1,'A2');
xlswrite(outputFile,fundNameVector,1,'B2');
xlswrite(outputFile,fundInvestTypeVector,1,'C2');
xlswrite(outputFile,fundDateVector,1,'D2');
xlswrite(outputFile,outputMatrix2,1,'E2');


xlswrite(outputFile,{'基金代码','基金名称','基金投资类型','成立日期'},2,'A2');
xlswrite(outputFile,T1',2,'E1');
xlswrite(outputFile,T2',2,'E2');
xlswrite(outputFile,fundCodeVector,2,'A3');
xlswrite(outputFile,fundNameVector,2,'B3');
xlswrite(outputFile,fundInvestTypeVector,2,'C3');
xlswrite(outputFile,fundDateVector,2,'D3');
xlswrite(outputFile,outputMatrix,2,'E3');

% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',{'牛熊市（1：牛，0：震荡市，-1：熊）'},2,'A1');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',{'总天数'},2,'B1');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',{'经历几个'},2,'C1');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',{'平均排名'},2,'D1');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',outcome,2,'A2');