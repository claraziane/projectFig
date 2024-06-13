function fig_resultsScatter(data, xLabel, yLabel)

% Define colors for plotting
addpath('/Users/claraziane/Documents/Académique/Informatique/MATLAB/rgb/'); %To draw figures

for iLabel = 1:length(xLabel)
    if strcmpi(xLabel{iLabel}(1:6), 'uncued')
        Colors(iLabel,:)     = rgb('LightBlue');
        ColorMeans(iLabel,:) = rgb('DodgerBlue');
        xGroup(iLabel,1:2)   = iLabel-1 + 0.7;
    else
        Colors(iLabel,:)     = rgb('NavajoWhite');
        ColorMeans(iLabel,:) = rgb('DarkOrange');
        xGroup(iLabel,1:2)   = iLabel-1 + 0.7;
    end
end
Colors(end+1,:) = rgb('LightGray');

xTicks(:,1) = randi([1, 40], size(data,1), 1);
xTicks(:,1) = 0.8 + (xTicks(:,1)/100);

for iCond = 2:size(data,2)
    xTicks(:,iCond) = xTicks(:,iCond-1)+1;
end

figure;
% Plot horizontal lines
plot(xTicks', data', 'Color', Colors(end,:), 'LineWidth', 2); hold on;

% Define x axis
ax = gca;
set(ax, 'xlim',  [0 size(data,2)+1])
set(ax, 'xtick', [1:size(data,2)])
set(ax, 'xticklabel', xLabel);
set(ax, 'FontWeight', 'bold', 'FontSize', 20);
ylabel(yLabel)
% title(figTitle);
hold on;

for iGroup = 1:size(data,2)

    % Plot scatter points for each participant
    scatter(xTicks(:,iGroup), data(:,iGroup), 200,  'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'w');
    scatter(xTicks(:,iGroup), data(:,iGroup), 200,  'MarkerEdgeColor', Colors(end,:), 'MarkerFaceColor', Colors(iGroup,:), 'MarkerFaceAlpha', .5);

    % Compute 95% CI for each group
    groupSEM = std(data(:,iGroup))  / sqrt(length(data(:,iGroup)));
    t        = tinv([0.025 0.975], length(data(:,iGroup))-1);
    groupCI = nanmean(data(:,iGroup)) + t * groupSEM;

    % Plot group CIs
    plot(xGroup(iGroup, 1:2), groupCI, '-', 'Color', ColorMeans(iGroup,:), 'LineWidth', 5)

    % Plot group mean
    scatter(xGroup(iGroup,1), nanmean(data(:,iGroup)), 500, 'w', 'filled');
    scatter(xGroup(iGroup,1), nanmean(data(:,iGroup)), 500, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', ColorMeans(iGroup,:), 'MarkerFaceAlpha', 0.8);
    hold on;
   
    set(gca, 'XTick', [1.2:2:(length(xLabel)+0.2)])

end

xLabel = xLabel(1:2:end);
for iLabel = 1:length(xLabel)
    xLabelFinal{iLabel} = xLabel(iLabel);
    xLabelFinal{iLabel} = xLabelFinal{1,iLabel}{1, 1}(5:end);
end
set(gca, 'XTickLabel', xLabelFinal)

end