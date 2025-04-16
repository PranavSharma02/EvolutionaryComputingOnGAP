function compareAllAlgorithms()
    % File paths
    greedyFile = 'gap_greedy_results.csv';
    optimalFile = 'gap_max_results.csv';
    gaFile = 'gap12_binary_avg_results.csv';
    
    % Read all files
    greedyData = readtable(greedyFile);
    optimalData = readtable(optimalFile);
    gaData = readtable(gaFile);
    
    % Filter for file index 12
    greedyFiltered = greedyData(greedyData.FileID == 12, :);
    optimalFiltered = optimalData(optimalData.FileID == 12, :);
    
    % Number of GA instances
    numGaInstances = height(gaData);
    
    % Get first n instances from each dataset
    greedyUtil = greedyFiltered.TotalUtility(1:numGaInstances);
    optimalUtil = optimalFiltered.TotalUtility(1:numGaInstances);
    gaUtil = gaData.AverageProfit;
    instanceNames = greedyFiltered.InstanceID(1:numGaInstances);
    
    % Calculate performance ratios
    greedyRatios = (greedyUtil ./ optimalUtil) * 100;
    gaRatios = (gaUtil ./ optimalUtil) * 100;
    
    % Create grouped bar chart
    figure('Name', 'Algorithm Comparison', 'Position', [100, 100, 900, 500]);
    
    % Plot utilities
    barData = [greedyUtil, gaUtil, optimalUtil];
    b = bar(barData);
    
    % Set colors
    b(1).FaceColor = [0.2 0.6 0.2]; % Green for Greedy
    b(2).FaceColor = [0.8 0.4 0]; % Orange for GA
    b(3).FaceColor = [0 0.4 0.8]; % Blue for Optimal
    
    % Add data labels on top of each bar
    for i = 1:length(b)
        xData = b(i).XEndPoints;
        yData = b(i).YData;
        
        % Round GA values to integers for display
        if i == 2
            labels = string(round(yData));
        else
            labels = string(yData);
        end
        
        text(xData, yData, labels, 'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom', 'FontWeight', 'bold');
    end
    
    % Add labels
    legend('Greedy', 'GA', 'Optimal', 'Location', 'best');
    xlabel('Instances');
    ylabel('Total Utility');
    title('Comparison of Algorithms for GAP File 12');
    set(gca, 'XTick', 1:numGaInstances, 'XTickLabel', instanceNames, 'XTickLabelRotation', 45);
    grid on;
    
    % Set y-axis limits to leave room for labels
    ylim([0, max(max(barData)) * 1.1]);
    
    % Print summary table
    fprintf('Instance\tGreedy\t\tGA\t\tOptimal\t\tGreedy/Opt\tGA/Opt\n');
    fprintf('-------------------------------------------------------------------\n');
    
    for i = 1:numGaInstances
        fprintf('%s\t%d\t\t%.2f\t\t%d\t\t%.2f%%\t\t%.2f%%\n', ...
            instanceNames{i}, greedyUtil(i), gaUtil(i), optimalUtil(i), ...
            greedyRatios(i), gaRatios(i));
    end
    
    fprintf('-------------------------------------------------------------------\n');
    fprintf('Average:\t\t\t\t\t\t\t%.2f%%\t\t%.2f%%\n', mean(greedyRatios), mean(gaRatios));
    
    % Save summary to CSV
    summaryTable = table(instanceNames, greedyUtil, gaUtil, optimalUtil, greedyRatios, gaRatios, ...
                    'VariableNames', {'Instance', 'Greedy', 'GA', 'Optimal', 'GreedyRatio', 'GARatio'});
    writetable(summaryTable, 'algorithm_comparison.csv');
    
    % Save the figure
    saveas(gcf, 'algorithm_comparison.png');
    fprintf('Comparison figure saved as algorithm_comparison.png\n');
end