function processDataFiles()
    totalFiles = 12;
    aggregatedResults = cell(totalFiles, 1);

    % Open output CSV file
    outputFile = 'gap_max_results.csv';
    fid = fopen(outputFile, 'w');
    if fid == -1
        error('Failed to open file %s for writing.', outputFile);
    end
    
    % Write CSV header
    fprintf(fid, 'FileIndex,InstanceName,Utility\n');
    
    % Iterate through gap1 to gap12
    for fileIndex = 1:totalFiles
        fileName = sprintf('/MATLAB Drive/gap dataset files/gap%d.txt', fileIndex);
        fileId = fopen(fileName, 'r');

        if fileId == -1
            error('Error opening file %s.', fileName);
        end

        % Read the number of test cases
        totalCases = fscanf(fileId, '%d', 1);
        caseResults = cell(totalCases, 1);

        for caseIndex = 1:totalCases
            % Read input parameters
            dimensions = fscanf(fileId, '%d', 2);
            serverCount = dimensions(1);
            userCount = dimensions(2);

            % Read utility matrix (cost matrix)
            costMatrix = zeros(serverCount, userCount);
            for i = 1:serverCount
                costMatrix(i, :) = fscanf(fileId, '%d', [1, userCount]);
            end

            % Read resource requirement matrix
            resourceMatrix = zeros(serverCount, userCount);
            for i = 1:serverCount
                resourceMatrix(i, :) = fscanf(fileId, '%d', [1, userCount]);
            end

            % Read server capacities
            capacityVector = fscanf(fileId, '%d', [serverCount, 1]);

            % Solve the problem
            xMatrix = solveGapMax(serverCount, userCount, costMatrix, resourceMatrix, capacityVector);

            % Calculate total utility
            totalUtility = sum(sum(costMatrix .* xMatrix));

            % Format instance name
            instanceName = sprintf('c%d-%d', serverCount*100 + userCount, caseIndex);
            caseResults{caseIndex} = sprintf('%s\t%d', instanceName, round(totalUtility));

            % Write result to CSV file
            fprintf(fid, '%d,%s,%d\n', fileIndex, instanceName, round(totalUtility));
        end

        % Close file
        fclose(fileId);
        aggregatedResults{fileIndex} = caseResults;
    end

    % Close output CSV
    fclose(fid);
    fprintf('Results saved to %s\n', outputFile);

    % Display results side by side
    columnsPerRow = 4;
    for rowStart = 1:columnsPerRow:totalFiles
        rowEnd = min(rowStart + columnsPerRow - 1, totalFiles);

        % Print headers
        for fileIndex = rowStart:rowEnd
            fprintf('gap%d\t\t', fileIndex);
        end
        fprintf('\n');

        % Determine max number of cases in this row
        maxCases = max(cellfun(@length, aggregatedResults(rowStart:rowEnd)));

        % Print data row-wise
        for caseIndex = 1:maxCases
            for fileIndex = rowStart:rowEnd
                if fileIndex <= length(aggregatedResults) && caseIndex <= length(aggregatedResults{fileIndex})
                    fprintf('%s\t', aggregatedResults{fileIndex}{caseIndex});
                else
                    fprintf('\t\t');
                end
            end
            fprintf('\n');
        end
        fprintf('\n');
    end
end

function xMatrix = solveGapMax(m, n, c, r, b)
    % m = number of servers
    % n = number of users
    % c = utility matrix (m x n)
    % r = resource requirement matrix (m x n)
    % b = capacity vector (m x 1)

    % Flatten c matrix for objective function
    f = -reshape(c, [], 1); % Negative for maximization

    % Constraint 1: Each user assigned to exactly one server
    AeqUsers = zeros(n, m*n);
    for j = 1:n
        for i = 1:m
            AeqUsers(j, (j-1)*m + i) = 1;
        end
    end
    beqUsers = ones(n, 1);

    % Constraint 2: Server capacity constraints
    AineqServers = zeros(m, m*n);
    for i = 1:m
        for j = 1:n
            AineqServers(i, (j-1)*m + i) = r(i, j);
        end
    end
    bineqServers = b;

    % Define variable bounds
    lb = zeros(m*n, 1);
    ub = ones(m*n, 1);
    intcon = 1:(m*n);

    % Solve using intlinprog
    options = optimoptions('intlinprog', 'Display', 'off');
    x = intlinprog(f, intcon, AineqServers, bineqServers, AeqUsers, beqUsers, lb, ub, options);

    % Reshape into m × n matrix
    xMatrix = reshape(x, [m, n]);
end