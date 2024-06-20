function fig_resultsScatter(data, xLabel, yLabel)

% Define colors for plotting
addpath('/Volumes/Seagate/project_rhythmicBrain/Toolbox/rgb'); %To draw figures

% Figure out number of conditions
nLabels = 1;
condType = 1;
for iLabel = 1:length(xLabel)
    if strcmpi(xLabel{iLabel,1}(1:8), 'stimWalk')
        nLabels = nLabels +1;
    elseif strcmpi(xLabel{iLabel,1}(1:8), 'syncWalk')
        nLabels = nLabels +1;
    end

    if strcmpi(xLabel{iLabel,1}(end-1:end), 'ST')
        nLabels = nLabels-1;
        condType = 2;
    end
end
nConditions = (size(data,2)/nLabels);

i = 1;
if condType == 1
    nConditions = nConditions * nLabels;
    for iCondition = 1:nConditions
        for iTime = 1:size(data,3)

            dataTemp(:,i) = data(:,iCondition,iTime);

            i = i+1;
        end
    end
    data = dataTemp;
end


for iLabel = 1:length(xLabel)
    if strcmpi(xLabel{iLabel}(end-1:end), 'ST')
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

for iLabel = 2:nLabels
    xTicks(:,:,iLabel) = xTicks(:,:,iLabel-1);
end

figure;
condStart = 1;
% Plot horizontal lines
% if size(xLabel,1) == size(data,2)
    for iLabel = 1:nLabels
        iTick = 1;
        for iTime = 1:size(data,3)
            for iCondition = condStart:condType:condStart + nConditions-1
                subplot(1,nLabels,iLabel); plot(xTicks(:,iTick:iTick+1,iLabel)', data(:,iCondition:iCondition+1, iTime)', 'Color', Colors(end,:), 'LineWidth', 2); hold on;
                iTick = iTick + condType;
            end
        end
        condStart = condStart + nConditions;

        % Define axis
        ax(iLabel) = gca;
        set(ax(iLabel), 'xtick', [1:size(data,2)])
        set(ax(iLabel), 'xticklabel', xLabel(iCondition:iCondition+1));
        ylabel(yLabel)
        hold on;
    end

% else
%     for iCondition = 1:size(data,2)-1
%         if iCondition == (size(data,2)/nLabels)+1 % MUST BE FIXED FOR MORE THAN 2 LABELS
%             iLabel = iLabel+1;
%         end
% 
%         subplot(1,nLabels,iLabel); plot(xTicks(:,iCondition:iCondition+1,iLabel)', data(:,iCondition:iCondition+1,iLabel)', 'Color', Colors(end,:), 'LineWidth', 2); hold on;
%     end
% 
% end

% Define axis
set(ax, 'ylim', [min(reshape([ax(1).YLim ax(2).YLim], 1, [])) max(reshape([ax(1).YLim ax(2).YLim], 1, []))])
set(ax, 'xlim',  [0 size(data,2)+1])
set(ax, 'FontWeight', 'bold', 'FontSize', 20);
% title(figTitle);
hold on;

condStart = 1;
for iLabel = 1:nLabels
    iTick = 1;
    for iTime = 1:size(data,3)
        for iCondition = condStart:condStart + nConditions-1

            % Plot scatter points for each participant
            subplot(1,nLabels,iLabel); scatter(xTicks(:,iTick,iLabel), data(:,iCondition, iTime), 200,  'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'w');
            subplot(1,nLabels,iLabel); scatter(xTicks(:,iTick,iLabel), data(:,iCondition, iTime), 200,  'MarkerEdgeColor', Colors(end,:), 'MarkerFaceColor', Colors(iTick,:), 'MarkerFaceAlpha', .5);

            % Compute 95% CI for each condition
            groupSEM = nanstd(data(:,iCondition, iTime))  / sqrt(length(data(:,iCondition, iTime)));
            t        = tinv([0.025 0.975], length(data(:,iCondition, iTime))-1);
            groupCI = nanmean(data(:,iCondition, iTime)) + t * groupSEM;

            % Plot group CIs
            subplot(1,nLabels,iLabel);...
                plot(xGroup(iTick, 1:2), groupCI, '-', 'Color', ColorMeans(iTick,:), 'LineWidth', 5)

            % Plot group mean
            subplot(1,nLabels,iLabel);...
                scatter(xGroup(iTick,1), nanmean(data(:,iCondition, iTime)), 500, 'w', 'filled');
            subplot(1,nLabels,iLabel);...
                scatter(xGroup(iTick,1), nanmean(data(:,iCondition, iTime)), 500, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', ColorMeans(iTick,:), 'MarkerFaceAlpha', 0.8);
            hold on;

            iTick = iTick + 1;
        end
    end
    condStart = condStart + nConditions;
end

end