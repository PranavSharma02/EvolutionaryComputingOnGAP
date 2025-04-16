clc;
clear;

% Problem parameters
nVar = 4;                      % Number of decision variables
varMin = -10;                  % Lower bound
varMax = 10;                   % Upper bound

% GA parameters
popSize = 50;
maxGen = 100;
pc = 0.8;                      % Crossover probability
pm = 0.2;                      % Mutation probability
tournamentSize = 3;
sigma = 0.1;                   % Std dev for Gaussian mutation
nImmigrants = 2;

% Initialize population (real values)
pop = rand(popSize, nVar) * (varMax - varMin) + varMin;
bestFitnessHistory = zeros(maxGen, 1);

for gen = 1:maxGen
    % Evaluate fitness
    fitness = arrayfun(@(i) sphereFunction(pop(i,:)), 1:popSize)';

    % Elitism
    [bestFitnessHistory(gen), eliteIdx] = min(fitness);
    elite = pop(eliteIdx, :);

    % New population generation
    newPop = zeros(size(pop));
    for i = 1:2:popSize
        p1 = tournamentSelectRC(pop, fitness, tournamentSize);
        p2 = tournamentSelectRC(pop, fitness, tournamentSize);

        if rand < pc
            [c1, c2] = blendCrossover(p1, p2);
        else
            c1 = p1;
            c2 = p2;
        end

        c1 = mutateRC(c1, pm, sigma, varMin, varMax);
        c2 = mutateRC(c2, pm, sigma, varMin, varMax);

        newPop(i,:) = c1;
        if i+1 <= popSize
            newPop(i+1,:) = c2;
        end
    end

    % Add immigrants (random individuals)
    for k = 1:nImmigrants
        newPop(end-k+1,:) = rand(1, nVar) * (varMax - varMin) + varMin;
    end

    % Evaluate new population
    newFitness = arrayfun(@(i) sphereFunction(newPop(i,:)), 1:popSize)';

    % Replace worst with elite
    [~, worstIdx] = max(newFitness);
    newPop(worstIdx,:) = elite;

    % Update population
    pop = newPop;
end

% Final result
finalFitness = arrayfun(@(i) sphereFunction(pop(i,:)), 1:popSize)';
[bestFit, bestIdx] = min(finalFitness);
bestSol = pop(bestIdx, :);

fprintf('Best Solution Found:\n');
disp(bestSol);
fprintf('Minimum Value: %.6f\n', bestFit);

% Plot convergence
figure;
plot(1:maxGen, bestFitnessHistory, 'LineWidth', 2);
xlabel('Generation');
ylabel('Best Fitness Value');
title('Real-Coded Genetic Algorithm Convergence');
grid on;

% --- Helper Functions ---

function f = sphereFunction(x)
    f = sum(x.^2);
end

function ind = tournamentSelectRC(pop, fitness, k)
    idx = randperm(size(pop,1), k);
    [~, best] = min(fitness(idx));
    ind = pop(idx(best), :);
end

function [c1, c2] = blendCrossover(p1, p2)
    alpha = rand;
    c1 = alpha * p1 + (1 - alpha) * p2;
    c2 = alpha * p2 + (1 - alpha) * p1;
end

function mutant = mutateRC(ind, pm, sigma, varMin, varMax)
    mutant = ind;
    for i = 1:length(ind)
        if rand < pm
            mutant(i) = ind(i) + sigma * randn;
        end
    end
    mutant = min(max(mutant, varMin), varMax); % Bound check
end
