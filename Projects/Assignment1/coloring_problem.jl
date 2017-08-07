

function graph_crown()
  return [
    0 1 0 0 0 1 0 1;
    1 0 1 0 1 0 0 0;
    0 1 0 1 0 0 0 1;
    0 0 1 0 1 0 1 0;
    0 1 0 1 0 1 0 0;
    1 0 0 0 1 0 1 0;
    0 0 0 1 0 1 0 1;
    1 0 1 0 0 0 1 0
  ]
end

function graph_peterson()
  return [
    0 1 0 0 1 1 0 0 0 0;
    1 0 1 0 0 0 1 0 0 0;
    0 1 0 1 0 0 0 1 0 0;
    0 0 1 0 1 0 0 0 1 0;
    1 0 0 1 0 0 0 0 0 1;
    1 0 0 0 0 0 0 1 1 0;
    0 1 0 0 0 0 0 0 1 1;
    0 0 1 0 0 1 0 0 0 1;
    0 0 0 1 0 1 1 0 0 0;
    0 0 0 0 1 0 1 1 0 0
  ]
end

function graph_wheel()
  return [
    0 1 0 0 0 0 0 0 0 0 1 1;
    1 0 1 0 0 0 0 0 0 0 0 1;
    0 1 0 1 0 0 0 0 0 0 0 1;
    0 0 1 0 1 0 0 0 0 0 0 1;
    0 0 0 1 0 1 0 0 0 0 0 1;
    0 0 0 0 1 0 1 0 0 0 0 1;
    0 0 0 0 0 1 0 1 0 0 0 1;
    0 0 0 0 0 0 1 0 1 0 0 1;
    0 0 0 0 0 0 0 1 0 1 0 1;
    0 0 0 0 0 0 0 0 1 0 1 1;
    1 0 0 0 0 0 0 0 0 1 0 1;
    1 1 1 1 1 1 1 1 1 1 1 0
  ]
end

function fitness(graph, genotype)
  for i in 1:length(genotype)
    for j in 1:size(graph,2)
      # @printf "%d -> %d\n" i graph[i, j]
      if graph[i, j] == 1 && genotype[i] == genotype[j]
        return length(genotype)+1
      end
    end
  end
  different_colors = Set(genotype)
  return length(different_colors)
end

function generate(graph)
  n_vertices = size(graph, 1)
  genotypes = fill(0, n_vertices)
  for i in 1:n_vertices
    vertice_color = rand(1:n_vertices)
    genotypes[i] = vertice_color
  end
  return genotypes
end

function mutate(genotype)
  genotype_length = length(genotype)
  mutated_genotype = copy(genotype)
  index = rand(1:genotype_length)
  mutation = rand(1:genotype_length)
  mutated_genotype[index] = mutation
  return mutated_genotype
end

function ev11(p, g, graph) # p = population size, g = number of generations, graph = graph of which to solve the coloring problem on
  pop = fill([0], p) # Create array of size p which then becomes the population
  for i in 1:p # Fill array with generated solutions
    pop[i] = generate(graph)
  end
  for j in 1:g # Do changes to the population for g generations
    x = rand(1:p) # Select a random member of the population, ind_1
    x_ = mutate(pop[x]) # Perform a modification to the random member x which will be called x_
    y = rand(1:p) # Select a random member of the population, y
    if fitness(graph, x_) < fitness(graph, pop[y]) # Fitness should be as small as possible in this case
      pop[y] = x_
    end
  end
  return pop # Return the population after modifying it over g generations
end

function do_and_print(graph, which)
  answer = ev11(50, 1000, graph)
  best = answer[1]
  best_fit = fitness(graph, answer[1])
  @printf("Results for graph %s\n", which)
  for i in 1:length(answer)
    @printf("%d: %s, fitness %d\n", i, answer[i], fitness(graph, answer[i]))
    if (best_fit > fitness(graph, answer[i]))
      best = answer[i]
      best_fit = fitness(graph, answer[i])
    end
  end
  @printf("Best: %s, fitness %d\n", best, best_fit)
  @printf("End of results for graph %s\n\n", which)
end

do_and_print(graph_crown(), "CROWN")
# do_and_print(graph_peterson(), "PETERSON")
# do_and_print(graph_wheel(), "WHEEL")