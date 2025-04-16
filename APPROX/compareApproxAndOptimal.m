function compareGreedyAndOptimal()
    % File paths
    greedyFile = 'gap_greedy_results.csv';
    optimalFile = 'gap_max_results.csv';
    
    % Read both files
    greedyData = readtable(greedyFile);
    optimalData = readtable(optimalFile);
    
    % Filter for file index 12 using the correct column names
    greedyFiltered = greedyData(greedyData.FileID == 12, :);
    optimalFiltered = optimalData(optimalData.FileID == 12, :);
    
    % Get instance names and utility values using the correct column names
    greedyInstanceNames = greedyFiltered.InstanceID;
    optimalInstanceNames = optimalFiltered.InstanceID;
    
    greedyUtil = greedyFiltered.TotalUtility;
    optimalUtil = optimalFiltered.TotalUtility;
    
    % Make sure the instances are aligned (sort by instance name)
    [sortedOptNames, optIdx] = sort(greedyInstanceNames);
    sortedOptUtil = optimalUtil(optIdx);
    
    [sortedGreedyNames, greedyIdx] = sort(optimalInstanceNames);
    sortedGreedyUtil = greedyUtil(greedyIdx);
    
    % Verify we're comparing the same instances
    if ~isequal(sortedOptNames, sortedGreedyNames)
        warning('Instance names do not match exactly between files');
        disp('Optimal instances:');
        disp(sortedOptNames);
        disp('Greedy instances:');
        disp(sortedGreedyNames);
    end
    
    % Plot comparison
    figure('Name', 'Greedy vs Optimal - c1060 Instances (File 12)', 'NumberTitle', 'off');
    
    % Create grouped bar chart
    barData = [sortedGreedyUtil, sortedOptUtil];
    b = bar(barData);
    
    % Add data labels
    for i = 1:length(b)
        xtips = b(i).XEndPoints;
        ytips = b(i).YEndPoints;
        labels = string(b(i).YData);
        text(xtips, ytips, labels, 'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom')
    end
    
    legend('Greedy (Approx)', 'Optimal');
    xlabel('Problem Instances');
    ylabel('Total Utility');
    title('Greedy vs Optimal Utility - c1060 Instances (File 12)');
    set(gca, 'XTick', 1:length(sortedOptNames), 'XTickLabel', sortedOptNames, 'XTickLabelRotation', 45);
    grid on;
    ylim([0, max(max(barData)) * 1.1]);
    
    % Calculate and display performance metrics
    fprintf('Performance metrics for c1060 instances (File 12):\n');
    fprintf('Instance\tGreedy\tOptimal\tRatio (%%)\n');
    
    ratios = [];
    for i = 1:length(sortedGreedyUtil)
        ratio = (sortedGreedyUtil(i) / sortedOptUtil(i)) * 100;
        ratios(i) = ratio;
        fprintf('%s\t%d\t%d\t%.2f%%\n', sortedOptNames{i}, sortedGreedyUtil(i), sortedOptUtil(i), ratio);
    end
    
    avgRatio = mean(ratios);
    fprintf('Average performance ratio: %.2f%%\n', avgRatio);
    
    % Optional: Save the figure
    saveas(gcf, 'comparison_c1060_file12.png');
end