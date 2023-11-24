function plotCorrel(dataX, dataY, xLabel, yLabel, Titles, corrType)

% Declare colors for colors
addpath(genpath ...
    ('/Volumes/Seagate/project_rhythmicBrain/Toolbox/rgb')); %Toolbox draw figures
Colors = [rgb('DodgerBlue')];
subNum = ceil(length(Titles)/2);

fig = figure;
sgtitle([yLabel ' as a Function of ' xLabel], 'FontSize', 20)
figX = gca;

for iCondition = 1:size(dataX,2)

    % Compute correlation
    [rho, p] = corr(dataX(:,iCondition), dataY(:,iCondition), 'Type', corrType);

    % Plot correlation
    subplot(2,subNum,iCondition); scatter(dataX(:,iCondition), dataY(:,iCondition), 150, Colors, 'filled', 'MarkerFaceAlpha', 0.7,...
        'DisplayName', ['\rho = ' num2str(round(rho,2)) '; p = ' num2str(round(p,2))]);
        xlabel(xLabel, 'FontSize', 20); ylabel(yLabel, 'FontSize', 20);
        legend('FontSize', 16);
        title(Titles{iCondition}, 'FontSize', 16);

%         subplot(2,subNum,size(dataX,2)+1); scatter(dataX(:,iCondition), dataY(:,iCondition), 150, Colors(iCondition,:), 'filled', 'MarkerFaceAlpha', 0.7);
%         xlabel(xLabel, 'FontSize', 20); ylabel(yLabel, 'FontSize', 20);
%         title('All conditions', 'FontSize', 16);
%         hold on;

end

% % Pool all conditions together
% dataX = reshape(dataX, [size(dataX,1)*size(dataX,2) 1]);
% dataY = reshape(dataY, [size(dataY,1)*size(dataY,2) 1]);
% 
% % Compute correlation
% [rho, p] = corr(dataX, dataY, 'Type', corrType);
% 
% % Plot
% subplot(2,2,iCondition+1); 
%     legend(['\rho = ' num2str(round(rho,2)) '; p = ' num2str(round(p,2))],'Location','northeast','Orientation','horizontal')
%     legend('FontSize', 16);
% 
end