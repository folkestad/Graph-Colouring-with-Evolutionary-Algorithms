# DO NOT MODIFY THIS CODE

function make_g1()
  g = fill(0, 63, 63)
  for i in 1:21
    for j in 22:63
      g[i, j] = 1
      g[j, i] = 1
    end
  end
  return g
end

function make_g2()
  g = fill(0, 63, 63)
  g[1,62] = 1
  g[62,1] = 1
  for i in 1:62
    g[i,63] = 1
    g[63,i] = 1
    if i - 1 > 0
      g[i, i-1] = 1
      g[i - 1, i] = 1
    end
  end
  return g
end

function make_g3()
  g = fill(0, 63, 63)
  for i in 1:31
    g[i, 2 * i] = 1
    g[2 * i, i] = 1
    g[i, 2 * i + 1] = 1
    g[2 * i + 1, i] = 1
  end
  return g
end

g1 = make_g1()
g2 = make_g2()
g3 = make_g3()

function fit(g, x)
  if length(x) == 1
    return 1
  end
  for i in 1:length(x) - 1
    for j in i:length(x)
      if g[x[i], x[j]] == 1 || g[x[j], x[i]] == 1
        return 0
      end
    end
  end
  return length(x)
end

function gen()
  return [rand(1:63)]
end

function mut(x, s)
  rate = Int(round(5 * s))
  new = fill(0, rate)
  filled = 0
  while filled < rate
    r = rand(1:63)
    if r in new || r in x
      continue
    end
    new[filled + 1] = r
    filled += 1
  end
  return cat(1, x, new)
end

# END OF UNMODIFIABLE SECTION 

# You can add more functions, but you can only change the ev method
# Do NOT modify p or g!

function ev(graph)
  p = 10 # DO NOT CHANGE!
  g = 100 # DO NOT CHANGE!
  pop = fill([0], p) 
  for i in 1:p 
    pop[i] = gen()
  end
  for j in 1:g 
    x = rand(1:p)
    x_prime = mut(pop[x], 1.0)
    y = rand(1:p)
    if fit(graph, x_prime) > fit(graph, pop[y])
      pop[y] = x_prime
    end
  end
  return pop
end

# DO NOT MODIFY!

function do_and_print(graph, which)
  answer = ev(graph)
  best = answer[1]
  best_fit = fit(graph, answer[1])
  @printf("Results for graph %d\n", which)
  for i in 1:length(answer)
    @printf("%d: %s, fitness %d\n", i, answer[i], fit(graph, answer[i]))
    if (best_fit < fit(graph, answer[i]))
      best = answer[i]
      best_fit = fit(graph, answer[i])
    end
  end
  @printf("Best: %s, fitness %d\n", best, best_fit)
  @printf("End of results for graph %d\n\n", which)
end

do_and_print(g1, 1)
do_and_print(g2, 2)
do_and_print(g3, 3)

# END OF UNMODIFIABLE SECTION
