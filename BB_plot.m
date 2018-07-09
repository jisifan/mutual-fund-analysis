function [] = BB_plot(x,gt,ct,maxlocation,minlocation)
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
hold off;