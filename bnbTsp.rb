class BNBTSP
    def initialize(adj_matrix)
      @adj_matrix = adj_matrix
      @num_nodes = adj_matrix.length
    end
  
    def solve
      path_awal = [0]
      cost_awal = 0
      calculate_path(path_awal, cost_awal, Set.new([0]))
    end
  
    private
  
    def calculate_path(path, cost, visited_nodes)
      
        # udh di node trakhir di current rute
        # add return edge to 0, balik ke node awal 
        # misal: 0-1-2-3 -> 0-1-2-3-0
        if path.length == @num_nodes
            cost += @adj_matrix[path[-1]][0]
            path.push(0)
        return { path: path, cost: cost }
      end
  
      best_path = nil
      best_cost = Float::INFINITY    # klo di py kyk maxSize gt
  
      (0...@num_nodes).each do |next_node|
        next unless visited_nodes.add?(next_node)
  
        # lower bound
        lower_bound = calculate_lower_bound(path, cost, visited_nodes, next_node)
        next if lower_bound >= best_cost
  
        # maskin next_node ke path, recursive
        new_cost = cost + @adj_matrix[path[-1]][next_node]
        new_path = path.dup
        new_path.push(next_node)
  
        solution = calculate_path(new_path, new_cost, visited_nodes)
  
        if solution[:cost] < best_cost
          best_path = solution[:path]
          best_cost = solution[:cost]
        end
  
        # backtrack
        visited_nodes.delete(next_node)
      end
  
      { path: best_path, cost: best_cost }
    end
  
    def calculate_lower_bound(path, cost, visited_nodes, next_node)
      #  cost buat visit semua node yg blm divisit dari next_node
      unvisited_nodes = Set.new((0...@num_nodes).to_a) - visited_nodes
      unvisited_nodes.delete(next_node)
  
      if unvisited_nodes.empty?
        # All nodes udh divisit, add return edge to 0
        return cost + @adj_matrix[next_node][0]
      end
  
      lower_bound = cost
  
      # calculate lower bound dari min weight edge dari tiap unvisited node
      unvisited_nodes.each do |node|
        min_edge_weight = Float::INFINITY
  
        @adj_matrix[node].each_with_index do |weight, i|
          next if visited_nodes.include?(i)
  
          min_edge_weight = [min_edge_weight, weight].min
        end
  
        lower_bound += min_edge_weight
      end
  
      # calculate lower bound dari two min weight edge dari tiap unvisited node
      next_min_edges = @adj_matrix[next_node].sort[0..1]
      lower_bound += next_min_edges.sum
  
      lower_bound
    end
  end
  
  # Main program
  print 'Masukkan ukuran matrix (n x n): '
  n = gets.chomp.to_i
  
  # Minta input matrix dari user
  adj_matrix = Array.new(n) { Array.new(n) }
  (0...n).each do |i|
    (0...n).each do |j|
      print "Masukkan nilai elemen (#{i},#{j}): "
      adj_matrix[i][j] = gets.chomp.to_i
    end
  end
  
  solver = BNBTSP.new(adj_matrix)
  solution = solver.solve
  
  puts "Rute terpendek: #{solution[:path].join(' -> ')}"
  puts "Bobot minimum: #{solution[:cost]}"
  
  