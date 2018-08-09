function [] = BB_plot(dateSeries,x,gt,ct,maxlocation,minlocation)
% plot according to result from BB_algorithm

n = length(x);
hold off;
plot(1:n,x);
hold on;
plot(1:n,gt);
plot(1:n,ct);

for i = 1:length(maxlocation)
    plot([maxlocation(i),maxlocation(i)],[0,max(x)+1000],'r');
end

for i = 1:length(minlocation)
    plot([minlocation(i),minlocation(i)],[0,max(x)+1000],'b');
end

maxX = double((int32(max(x))/int32(1000))*1000+2000);
yticks = 0:1000:maxX;

gap = double(int32(length(x))/int32(8));
xticks = 1:gap:length(x);
if (length(x) - xticks(length(xticks)))/xticks(length(xticks)) > (1/16)
    xticks = [xticks,length(x)];
end
set(gca,'xtick',xticks);
set(gca, 'xticklabel' ,[dateSeries(xticks);'...'],'yTick',yticks); 
% text(-90,-1190,dateSeries(1))
hold off;
% print('C:\Users\tangheng\Dropbox\summerIntern\ДњТы\mutual-fund-analysis\test.jpg', '-djpeg', '-r600')