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
a = [500,1000,1500,2000,2500,3000];
b = [0,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000];
set(gca, 'xticklabel' ,dateSeries(a),'yTick',b); 
text(-90,-1190,dateSeries(1))
hold off;