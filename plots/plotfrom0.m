function plotfrom0 (x,varargin)
figure;
plot(x,varargin{:});
ylim([0,max(x)]);
end