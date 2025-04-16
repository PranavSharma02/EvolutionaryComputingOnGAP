function runGapBatch()
    totalInputFiles = 12;
    allCaseOutputs = cell(totalInputFiles, 1);

    % Output CSV file for final results
    resultFile = 'gap_max_results.csv';
    resultFID = fopen(resultFile, 'w');
    if resultFID == -1
        error('Could not open %s for writing.', resultFile);
    end
    fprintf(resultFID, 'FileID,InstanceID,TotalUtility\n');

    for currentFile = 1:totalInputFiles
        dataPath = sprintf('/MATLAB Drive/gap dataset files/gap%d.txt', currentFile);
        inputFID = fopen(dataPath, 'r');
        if inputFID == -1
            error('Unable to open input file: %s', dataPath);
        end

        numberOfCases = fscanf(inputFID, '%d', 1);
        currentFileResults = cell(numberOfCases, 1);

        for caseNum = 1:numberOfCases
            % Read server-user configuration
            counts = fscanf(inputFID, '%d', 2);
            numServers = counts(1);
            numUsers = counts(2);

            % Load utility (cost) values
            utilityData = zeros(numServers, numUsers);
            for row = 1:numServers
                utilityData(row, :) = fscanf(inputFID, '%d', [1, numUsers]);
            end

            % Load resource usage matrix
            resourceNeeds = zeros(numServers, numUsers);
            for row = 1:numServers
                resourceNeeds(row, :) = fscanf(inputFID, '%d', [1, numUsers]);
            end

            % Load server capacity values
            serverCaps = fscanf(inputFID, '%d', [numServers, 1]);

            % Solve GAP instance
            assignmentMatrix = solveGAP(numServers, numUsers, utilityData, resourceNeeds, serverCaps);

            % Compute overall utility
            instanceUtility = sum(sum(utilityData .* assignmentMatrix));

            % Create instance identifier
            instanceID = sprintf('c%d-%d', numServers*100 + numUsers, caseNum);
            currentFileResults{caseNum} = sprintf('%s\t%d', instanceID, round(instanceUtility));

            % Save result row
            fprintf(resultFID, '%d,%s,%d\n', currentFile, instanceID, round(instanceUtility));
        end

        fclose(inputFID);
        allCaseOutputs{currentFile} = currentFileResults;
    end

    fclose(resultFID);
    fprintf('All results written to %s\n', resultFile);

    % Pretty-print results in console
    filesPerRow = 4;
    for startIdx = 1:filesPerRow:totalInputFiles
        endIdx = min(startIdx + filesPerRow - 1, totalInputFiles);
       
        % Header row
        for f = startIdx:endIdx
            fprintf('gap%d\t\t', f);
        end
        fprintf('\n');

        % Determine max cases in current group
        maxPerGroup = max(cellfun(@length, allCaseOutputs(startIdx:endIdx)));

        % Display case results
        for rowIdx = 1:maxPerGroup
            for f = startIdx:endIdx
                if rowIdx <= length(allCaseOutputs{f})
                    fprintf('%s\t', allCaseOutputs{f}{rowIdx});
                else
                    fprintf('\t\t');
                end
            end
            fprintf('\n');
        end
        fprintf('\n');
    end

    % === Plotting Section ===
    data = readtable(resultFile);
    uniqueFiles = unique(data.FileID);
    figure;
    hold on;
    grid on;
    colors = lines(length(uniqueFiles));  % Distinct colors for each file

    for i = 1:length(uniqueFiles)
        fileID = uniqueFiles(i);
        fileData = data(data.FileID == fileID, :);

        % Extract instance numbers from InstanceID
        instanceNums = zeros(height(fileData), 1);
        for j = 1:height(fileData)
            parts = split(fileData.InstanceID{j}, '-');
            instanceNums(j) = str2double(parts{2});
        end

        % Plot
        plot(instanceNums, fileData.TotalUtility, '-o', ...
            'Color', colors(i, :), ...
            'DisplayName', sprintf('gap%d', fileID), ...
            'LineWidth', 1.5, ...
            'MarkerSize', 5);
    end

    xlabel('Instance Number');
    ylabel('Total Utility');
    title('Total Utility per GAP Instance');
    legend('Location', 'bestoutside');
end


function xMatrix = solveGAP(serverCount, userCount, utilMatrix, resMatrix, capacities)
    % Prepare optimization problem
    objective = -reshape(utilMatrix, [], 1); % Maximize utility
   
    % Each user must be assigned to one server
    assignConstraint = zeros(userCount, serverCount * userCount);
    for user = 1:userCount
        for server = 1:serverCount
            assignConstraint(user, (user-1)*serverCount + server) = 1;
        end
    end
    assignTarget = ones(userCount, 1);

    % Server resource limits
    capacityConstraint = zeros(serverCount, serverCount * userCount);
    for server = 1:serverCount
        for user = 1:userCount
            capacityConstraint(server, (user-1)*serverCount + server) = resMatrix(server, user);
        end
    end

    % Optimization setup
    lowerBounds = zeros(serverCount * userCount, 1);
    upperBounds = ones(serverCount * userCount, 1);
    intVars = 1:(serverCount * userCount);

    % Solve with intlinprog
    solverOptions = optimoptions('intlinprog', 'Display', 'off');
    sol = intlinprog(objective, intVars, capacityConstraint, capacities, assignConstraint, assignTarget, lowerBounds, upperBounds, solverOptions);

    % Reshape solution into matrix form
    xMatrix = reshape(sol, [serverCount, userCount]);
end
