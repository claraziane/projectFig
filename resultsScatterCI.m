function fig_resultsScatterCI(data, CI, xLabels, yLabel)

% Define colors for plotting
addpath('/Volumes/Seagate/project_rhythmicBrain/Toolbox/rgb'); %To draw figures

if size(data,2) == 2
    Colors = [rgb('DarkOrange'); rgb('DodgerBlue'); rgb('Silver')];
    xGroup = [0.6 0.6; 2.4 2.4];
else
    Colors = [rgb('DarkOrange'); rgb('DarkOrange'); rgb('DarkOrange'); rgb('DodgerBlue'); rgb('Silver')];
    xGroup = [0.7 0.7; 1.7 1.7; 2.7 2.7; 3.7 3.7];
end

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
set(ax, 'xticklabel', xLabels);
set(ax, 'FontWeight', 'bold', 'FontSize', 20);
ylabel(yLabel)
hold on;

for iGroup = 1:size(data,2)

     % Plot 95% CI bars for each participant
    for iParticipant = 1:length(data)
        plot([xTicks(iParticipant,iGroup) xTicks(iParticipant,iGroup)], CI(iParticipant,:,iGroup), '-', 'Color', Colors(iGroup,:), 'LineWidth', 2)
    end
    % Plot scatter points for each participant
    scatter(xTicks(:,iGroup), data(:,iGroup), 200,  'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'w');
    scatter(xTicks(:,iGroup), data(:,iGroup), 200,  'MarkerEdgeColor', Colors(end,:), 'MarkerFaceColor', Colors(iGroup,:), 'MarkerFaceAlpha', .5);

    % Compute 95% CI for each group
    groupSEM = std(data(:,iGroup))  / sqrt(length(data(:,iGroup)));
    t        = tinv([0.025 0.975], length(data(:,iGroup))-1);
    groupCI = mean(data(:,iGroup)) + t * groupSEM;

    % Plot group CIs
    plot(xGroup(iGroup, 1:2), groupCI, '-', 'Color', Colors(iGroup,:), 'LineWidth', 5)

    % Plot group mean
    scatter(xGroup(iGroup,1), mean(data(:,iGroup)), 500, 'w', 'filled');
    scatter(xGroup(iGroup,1), mean(data(:,iGroup)), 500, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', Colors(iGroup,:), 'MarkerFaceAlpha', 0.8);
    hold on;

end

end