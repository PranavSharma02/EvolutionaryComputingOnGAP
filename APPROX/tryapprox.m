function solve_gap_approx_greedy()
    % Initialize storage for results
    solution_values = [];
    problem_identifiers = {};
    
    % Process each dataset file
    for file_number = 1:12
        % Construct path and open file
        input_path = sprintf('./gap dataset files/gap%d.txt', file_number);
        file_handle = fopen(input_path, 'r');
        
        % Check file accessibility
        if file_handle < 0
            error('File access error: %s', input_path);
        end
        
        % Read number of test cases in this file
        test_case_count = fscanf(file_handle, '%d', 1);
        fprintf('\n--- Now analyzing: %s ---\n', input_path(1:end-4));
        
        % Process each test case
        for test_index = 1:test_case_count
            % Read problem dimensions
            num_agents = fscanf(file_handle, '%d', 1);
            num_tasks = fscanf(file_handle, '%d', 1);
            
            % Read cost/utility matrix
            benefit_matrix = fscanf(file_handle, '%d', [num_tasks, num_agents])';
            
            % Read resource requirement matrix
            requirement_matrix = fscanf(file_handle, '%d', [num_tasks, num_agents])';
            
            % Read capacity constraints
            capacity_vector = fscanf(file_handle, '%d', [num_agents, 1]);
            
            % Solve using our heuristic approach
            solution = custom_gap_heuristic(num_agents, num_tasks, benefit_matrix, requirement_matrix, capacity_vector);
            
            % Calculate objective value
            objective_value = sum(sum(benefit_matrix .* solution));
            
            % Create identifier for this instance
            instance_id = sprintf('gap%d-%d', file_number, test_index);
            
            % Output progress
            fprintf('Problem: %s | Solution value: %d\n', instance_id, objective_value);
            
            % Store results
            solution_values(end + 1) = objective_value;
            problem_identifiers{end + 1} = instance_id;
        end
        
        % Close input file
        fclose(file_handle);
    end
    
    % Prepare data for CSV export
    csv_file = 'gap_greedy_results.csv';
    file_column = [];
    instance_column = {};
    value_column = [];
    
    % Format data for output
    for i = 1:length(problem_identifiers)
        parsed_id = split(problem_identifiers{i}, '-');
        file_num = str2double(extractAfter(parsed_id{1}, 'gap'));
        file_column(end + 1) = file_num;
        instance_column{end + 1} = sprintf('c%s', parsed_id{2});
        value_column(end + 1) = solution_values(i);
    end
    
    % Create and write output table
    output_table = table(file_column', instance_column', value_column', ...
        'VariableNames', {'FileID', 'InstanceID', 'TotalUtility'});
    writetable(output_table, csv_file);
    fprintf('Output written to %s\n', csv_file);
    
    % Create visualization
    figure;
    plot(solution_values, '-o', 'LineWidth', 1.5);
    title('Heuristic Solutions for Generalized Assignment Problems');
    xlabel('Instance Number');
    ylabel('Objective Value');
    legend('Greedy Approach', 'Location', 'best');
    xticks(1:length(problem_identifiers));
    xticklabels(problem_identifiers);
    xtickangle(45);
    grid on;
end

function allocation = custom_gap_heuristic(num_agents, num_tasks, benefit, requirement, capacities)
    % Initialize allocation matrix
    allocation = zeros(num_agents, num_tasks);
    remaining_capacity = capacities;
    
    % Assign each task sequentially
    for t = 1:num_tasks
        best_value = inf;
        best_agent = -1;
        
        % Find best agent for current task
        for a = 1:num_agents
            if requirement(a, t) <= remaining_capacity(a) && benefit(a, t) < best_value
                best_value = benefit(a, t);
                best_agent = a;
            end
        end
        
        % Assign task if feasible assignment found
        if best_agent > 0
            allocation(best_agent, t) = 1;
            remaining_capacity(best_agent) = remaining_capacity(best_agent) - requirement(best_agent, t);
        end
    end
end