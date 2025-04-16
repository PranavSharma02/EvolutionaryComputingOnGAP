function compareAllFourAlgorithms()
    % File paths
    greedyFile = 'gap_greedy_results.csv';
    optimalFile = 'gap_max_results.csv';
    binaryGaFile = 'gap12_binary_avg_results.csv';
    realGaFile = 'gap_rcga_results.csv';
    
    % Read all files
    greedyData = readtable(greedyFile);
    optimalData = readtable(optimalFile);
    binaryGaData = readtable(binaryGaFile);
    realGaData = readtable(realGaFile);
    
    % Filter for file index 12
    greedyFiltered = greedyData(greedyData.FileID == 12, :);
    optimalFiltered = optimalData(optimalData.FileID == 12, :);
    realGaFiltered = realGaData(realGaData.FileIndex == 12, :);
    
    % Number of instances to compare (use the smallest dataset size)
    numInstances = min([height(binaryGaData), height(realGaFiltered)]);
    
    % Extract data for comparison
    greedyUtil = greedyFiltered.TotalUtility(1:numInstances);
    optimalUtil = optimalFiltered.TotalUtility(1:numInstances);
    binaryGaUtil = binaryGaData.AverageProfit(1:numInstances);
    realGaUtil = realGaFiltered.Cost(1:numInstances);
    instanceNames = realGaFiltered.InstanceName(1:numInstances);
    
    % Calculate performance ratios
    greedyRatios = (greedyUtil ./ optimalUtil) * 100;
    binaryGaRatios = (binaryGaUtil ./ optimalUtil) * 100;
    realGaRatios = (realGaUtil ./ optimalUtil) * 100;
    
    % Create grouped bar chart
    figure('Name', 'Algorithm Comparison', 'Position', [100, 100, 1000, 600]);
    
    % Plot utilities
    barData = [greedyUtil, binaryGaUtil, realGaUtil, optimalUtil];
    b = bar(barData);
    
    % Set colors
    b(1).FaceColor = [0.2 0.6 0.2]; % Green for Greedy
    b(2).FaceColor = [0.8 0.4 0]; % Orange for Binary GA
    b(3).FaceColor = [0.9 0.1 0.1]; % Red for Real GA
    b(4).FaceColor = [0 0.4 0.8]; % Blue for Optimal
    
    % Add data labels on top of each bar
    for i = 1:length(b)
        xData = b(i).XEndPoints;
        yData = b(i).YData;
        
        % Format labels based on the algorithm type
        if i == 2 % Binary GA has decimals
            labels = string(round(yData));
        else
            labels = string(yData);
        end
        
        text(xData, yData, labels, 'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom', 'FontWeight', 'bold');
    end
    
    % Add labels
    legend('Greedy', 'Binary GA', 'Real-Coded GA', 'Optimal', 'Location', 'best');
    xlabel('Instances');
    ylabel('Total Utility');
    title('Comparison of Four Algorithms for GAP File 12');
    set(gca, 'XTick', 1:numInstances, 'XTickLabel', instanceNames, 'XTickLabelRotation', 45);
    grid on;
    
    % Set y-axis limits to leave room for labels
    ylim([0, max(max(barData)) * 1.1]);
    
    % Print summary table
    fprintf('\n====== Algorithm Comparison Summary ======\n');
    fprintf('Instance\tGreedy\t\tBinary GA\tReal GA\t\tOptimal\t\tGreedy/Opt\tBin GA/Opt\tReal GA/Opt\n');
    fprintf('-------------------------------------------------------------------------------------------------------\n');
    
    for i = 1:numInstances
        fprintf('%s\t%d\t\t%.2f\t\t%d\t\t%d\t\t%.2f%%\t\t%.2f%%\t\t%.2f%%\n', ...
            instanceNames{i}, greedyUtil(i), binaryGaUtil(i), realGaUtil(i), optimalUtil(i), ...
            greedyRatios(i), binaryGaRatios(i), realGaRatios(i));
    end
    
    fprintf('-------------------------------------------------------------------------------------------------------\n');
    fprintf('Average:\t\t\t\t\t\t\t\t\t%.2f%%\t\t%.2f%%\t\t%.2f%%\n', ...
        mean(greedyRatios), mean(binaryGaRatios), mean(realGaRatios));
    
    % Save summary to CSV
    summaryTable = table(instanceNames, greedyUtil, binaryGaUtil, realGaUtil, optimalUtil, ...
                      greedyRatios, binaryGaRatios, realGaRatios, ...
                      'VariableNames', {'Instance', 'Greedy', 'BinaryGA', 'RealGA', 'Optimal', ...
                                        'GreedyRatio', 'BinaryGARatio', 'RealGARatio'});
    writetable(summaryTable, 'four_algorithm_comparison.csv');
    
    % Save the figure
    saveas(gcf, 'algorithm_comparison.png');
    
    fprintf('\nResults saved to four_algorithm_comparison.csv\n');
    fprintf('Chart saved as algorithm_comparison.png\n');
end