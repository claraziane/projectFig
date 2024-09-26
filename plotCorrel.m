function plotCorrel(dataX, dataY, xLabel, yLabel, Titles, corrType)

% Declare colors for colors
addpath(genpath ...
    ('/Users/claraziane/Documents/Académique/Informatique/MATLAB/rgb/')); %Toolbox draw figures
Colors = [rgb('DarkOrange'); rgb('LightGray')];
subNum = ceil(length(Titles)/2);

fig = figure;
% sgtitle([yLabel ' as a Function of ' xLabel], 'FontSize', 20)
figX = gca;

for iCondition = 1:size(dataX,2)
    for iElement = 1:size(dataX,1)
        if isnan(dataX(iElement,iCondition))
            dataY(iElement,iCondition) = nan;
        end

        if isnan(dataY(iElement,iCondition))
            dataX(iElement,iCondition) = nan;
        end
    end

    X = dataX(~isnan(dataX(:,iCondition)),iCondition);
    Y = dataY(~isnan(dataY(:,iCondition)),iCondition);

    % Compute correlation
    [rho, p] = corr(X, Y, 'Type', corrType);

    % Linear regression (\ performs a least-squares regression)
    regX = [ones(length(X),1) X];
    regCoeff = regX \ Y; % Find intercept (1st line) and slope (2nd line)
    regY     = regX * regCoeff; % Find predicted Y

    % Plot correlation
    %     subplot(length(Titles),subNum,iCondition); scatter(X, Y, 150, Colors(1,:), 'filled', 'MarkerFaceAlpha', 0.7); hold on;
    subplot(2,subNum,iCondition); scatter(X, Y, 150, Colors(1,:), 'filled', 'MarkerFaceAlpha', 0.7); hold on;
    plot(X, regY, 'color', Colors(end,:), 'LineWidth', 2)
    if iCondition >= subNum+1
        xlabel(xLabel, 'FontSize', 20); 
    end

    if ismember(iCondition, [1 (subNum+1)])
        ylabel(yLabel, 'FontSize', 20);
    end
    title(Titles{iCondition}, ['\rho = ' num2str(round(rho,2)) '; p = ' num2str(round(p,2))], 'FontSize', 16);

    clear X Y

end

end