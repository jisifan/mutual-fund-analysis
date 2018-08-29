function [] = BB_plot2(dateSeries,x,gt,ct,maxlocation,minlocation)
% plot according to result from BB_algorithm

n = length(x);
hold off;
plot(1:n,x);
hold on;
plot(1:n,gt);
plot(1:n,ct);

for i = 1:length(maxlocation)
    plot([maxlocation(i),maxlocation(i)],[0,max(x)+1],'r');
end

for i = 1:length(minlocation)
    plot([minlocation(i),minlocation(i)],[0,max(x)+1],'b');
end

gap = double(int32(length(x))/int32(8));
xticks = 1:gap:length(x);
if (length(x) - xticks(length(xticks)))/xticks(length(xticks)) > (1/16)
    xticks = [xticks,length(x)];
end
set(gca,'xtick',xticks)
set(gca, 'xticklabel' ,dateSeries(xticks,:))

hold off;
% print('C:\Users\tangheng\Dropbox\summerIntern\ДњТы\mutual-fund-analysis\test.jpg', '-djpeg', '-r600')