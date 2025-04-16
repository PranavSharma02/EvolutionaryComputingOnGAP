% Genetic Algorithm with Tournament Selection + Single-Point Crossover
clc;
clear;

% Problem settings
nVar = 4;
varMin = -10;
varMax = 10;
nBits = 16;
nChrom = nVar * nBits;

% GA parameters
popSize = 50;
maxGen = 100;
pc = 0.7;
pm = 0.02;
tournamentSize = 3;
nImmigrants = 2;

% Initialization
pop = randi([0 1], popSize, nChrom);
bestFitnessHistory = zeros(maxGen, 1);

for gen = 1:maxGen
    % Evaluate fitness
    fitness = zeros(popSize, 1);
    for i = 1:popSize
        x = decodeIndividual(pop(i,:), nVar, nBits, varMin, varMax);
        fitness(i) = sphereFunction(x);
    end

    % Store elite
    [bestFitnessHistory(gen), eliteIdx] = min(fitness);
    elite = pop(eliteIdx, :);

    % Create new population
    newPop = zeros(size(pop));
    for i = 1:2:popSize
        p1 = tournamentSelect(pop, fitness, tournamentSize);
        p2 = tournamentSelect(pop, fitness, tournamentSize);

        if rand < pc
            [c1, c2] = singlePointCrossover(p1, p2);
        else
            c1 = p1;
            c2 = p2;
        end

        c1 = mutate(c1, pm);
        c2 = mutate(c2, pm);

        newPop(i,:) = c1;
        if i+1 <= popSize
            newPop(i+1,:) = c2;
        end
    end

    % Inject immigrants
    for k = 1:nImmigrants
        newPop(end-k+1,:) = randi([0 1], 1, nChrom);
    end

    % Evaluate new population
    newFitness = zeros(popSize, 1);
    for i = 1:popSize
        x = decodeIndividual(newPop(i,:), nVar, nBits, varMin, varMax);
        newFitness(i) = sphereFunction(x);
    end

    % Replace worst with elite
    [~, worstIdx] = max(newFitness);
    newPop(worstIdx, :) = elite;

    % Update population
    pop = newPop;
end

% Final result
finalFitness = zeros(popSize, 1);
for i = 1:popSize
    x = decodeIndividual(pop(i,:), nVar, nBits, varMin, varMax);
    finalFitness(i) = sphereFunction(x);
end

[bestFit, bestIdx] = min(finalFitness);
bestSol = decodeIndividual(pop(bestIdx,:), nVar, nBits, varMin, varMax);

fprintf('Best Solution Found:\n');
disp(bestSol);
fprintf('Minimum Value: %.6f\n', bestFit);

% Plot convergence
figure;
plot(1:maxGen, bestFitnessHistory, 'LineWidth', 2);
xlabel('Generation');
ylabel('Best Fitness Value');
title('Convergence (Tournament Selection + Single-Point Crossover)');
grid on;

% -----------------------
% Helper Functions
% -----------------------

function x = decodeIndividual(bits, nVar, nBits, varMin, varMax)
    x = zeros(1, nVar);
    for i = 1:nVar
        binStr = bits((i-1)*nBits+1:i*nBits);
        intVal = bin2dec(num2str(binStr));
        x(i) = varMin + (varMax - varMin) * intVal / (2^nBits - 1);
    end
end

function f = sphereFunction(x)
    f = sum(x.^2);
end

function ind = tournamentSelect(pop, fitness, k)
    indices = randperm(size(pop,1), k);
    [~, best] = min(fitness(indices));
    ind = pop(indices(best), :);
end

function [c1, c2] = singlePointCrossover(p1, p2)
    point = randi([1, length(p1)-1]);
    c1 = [p1(1:point), p2(point+1:end)];
    c2 = [p2(1:point), p1(point+1:end)];
end

function mutant = mutate(ind, pm)
    mutationMask = rand(size(ind)) < pm;
    mutant = xor(ind, mutationMask);
end
