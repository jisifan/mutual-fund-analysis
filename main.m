format long g;
% read data
startTime = '2014-06-11';
endTime = '2018-07-11';
indexcode = '000300.SH';

w = windmatlab;
[w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd(indexcode,'close,adjfactor',startTime,endTime,'Currency=CNY','PriceAdj=B');
[w_tdays_data,w_tdays_codes,w_tdays_fields,w_tdays_times,w_tdays_errorid,w_tdays_reqid]=w.tdays(startTime,endTime);
index_fuquan = w_wsd_data(:,1) .* w_wsd_data(:,2);
timess = ismember(w_tdays_times,w_wsd_times);%test pricedata's corresponding date
tradedays = w_tdays_data(timess == ones(length(timess),1));

series = index_fuquan;
dateSeries = tradedays;

%outcome:change of phase
[phase,maxlocation,minlocation,gt,ct,check] = ...
    BB_algorithm(dateSeries,series,100000,0.2);
% for i = 1:size(phase,1)
%     fprintf('%s\t%d\n',char(dateSeries(phase(i,1))),phase(i,2));
% end
BB_plot(dateSeries,series,gt,ct,maxlocation,minlocation);

%% prepare data
% series = hs300Series;
% [hs300_phase,maxlocation,minlocation,hs300_gt,hs300_ct,check] = ...
%     BB_algorithm(dateSeries,series,100000,0.2);
% 
% %% all timeSeries
% %write dateSeries in sheet1
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',{'index'},1,'A1');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',(1:length(dateSeries))',1,'A2');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',{'date'},1,'B1');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',dateSeries,1,'B2');
% 
% %% write all three priceSeries in sheet2
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',{'time'},2,'A1');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',dateSeries(phase(:,1)),2,'A2');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',{'phase'},2,'B1');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',phase,2,'B2');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',{'bull_bear'},2,'D1');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',phase(2:end,2)-phase(1:end-1,2),2,'D2');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',{'duration'},2,'E1');
% xlswrite('C:\Users\tangheng\Dropbox\暑期实习\代码\mutual-fund-analysis\result2.xlsx',phase(2:end,1)-phase(1:end-1,1),2,'E2');
% 
% [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd('000300.SH','close,adjfactor','2018-06-11','2018-07-10','Currency=CNY','PriceAdj=B');
% [w_tdays_data,w_tdays_codes,w_tdays_fields,w_tdays_times,w_tdays_errorid,w_tdays_reqid]=w.tdays('2018-06-11','2018-07-11');
% 
