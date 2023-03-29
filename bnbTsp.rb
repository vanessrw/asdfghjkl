class TSP
    class Node
      attr_reader :city, :parent, :visited, :path, :cost, :level
      
      def initialize(adj_matrix, city, parent, visited, path = [0], cost = 0)
        @adj_matrix = adj_matrix
        @city = city
        @parent = parent
        @visited = visited
        @path = path
        @cost = cost
        @level = visited.size
      end
    end
    
    def initialize(adj_matrix)
      @adj_matrix = adj_matrix
      @n = adj_matrix.size - 1
      @best_path = nil
      @best_cost = Float::INFINITY
    end
    
    def solve
      @best_cost = Float::INFINITY
      @best_path = nil
      root = Node.new(@adj_matrix, 0, nil, [])
      queue = [root]
      
      until queue.empty?
        curr_node = queue.shift
        
        if curr_node.cost >= @best_cost
          next
        end
        
        if curr_node.level == @n
          curr_cost = curr_node.cost + @adj_matrix[curr_node.city][0]
          if curr_cost < @best_cost
            @best_cost = curr_cost
            @best_path = curr_node.path + [0]
          end
          next
        end
        
        (0...@n).each do |i|
          if curr_node.visited.include?(i)
            next
          end
          
          new_cost = curr_node.cost + @adj_matrix[curr_node.city][i]
          new_visited = curr_node.visited.dup
          new_visited.push(i)
          new_path = curr_node.path.dup
          new_path.push(i)
          new_node = Node.new(@adj_matrix, i, curr_node, new_visited, new_path, new_cost)
          queue.push(new_node)
        end
      end
      
      return @best_path, @best_cost
    end
  end
  
  # user input
  print "Masukkan ukuran matrix (n x n): "
  n = gets.chomp.to_i
  
  adj_matrix = []
  (0...n).each do |i|
    row = []
    (0...n).each do |j|
      print "masukkan elemen [#{i},#{j}]: "
      distance = gets.chomp.to_i
      row.push(distance)
    end
    adj_matrix.push(row)
  end
  
  # main
  tsp = TSP.new(adj_matrix)
  path, cost = tsp.solve
  puts "Rute: #{path.join(' -> ')}"
  puts "(dengan bobot minimum: #{cost})"
  