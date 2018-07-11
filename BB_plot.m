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
xlim([1,3145]);
maxX = double((int32(max(x))/int32(1000))*1000+2000);
xlength = maxX/1000+1;
maxT = double((int32(length(x))/int32(500))*500);
if maxT > length(x)
    maxT = maxT - 500;
end
tlength = maxT/500;
a = linspace(500,maxT,tlength);
b = linspace(0,maxX,xlength);
set(gca, 'xticklabel' ,dateSeries(a),'yTick',b); 
text(-90,-1190,dateSeries(1))
hold off;