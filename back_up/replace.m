function z = replace(x)
%Identifies and replaces extreme values with values from the Spencer curve.
x_spenc = spencer(x); %Calculate the Spencer curve.
y = x./x_spenc;
mu = mean(y);
sigma = std(y);
lbound = mu - 3.5*sigma;
ubound = mu + 3.5*sigma;
for i = 1:length(y)
    if y(i) < lbound || y(i) > ubound
        x(i) = x_spenc(i);
    end
end
z = x;
