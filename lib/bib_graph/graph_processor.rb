# frozen_string_literal: true

module BibGraph
  class GraphProcessor
    def initialize(adjacency_list)
      @graph = adjacency_list
      validate_dag!
    end

    def build_tree_hash(root_id, visited = [])
      return root_id if visited.include?(root_id)
      
      children = @graph[root_id] || []
      return root_id if children.empty?

      { root_id => children.map { |child| build_tree_hash(child, visited + [root_id]) } }
    end

    def all_nodes
      @graph.keys
    end

    def edges
      @graph
    end

    private

    def validate_dag!
      visited = {}
      rec_stack = {}

      @graph.each_key do |node|
        if cycle_exists?(node, visited, rec_stack)
          raise CycleDetectedError, "Cycle detected in citation graph"
        end
      end
    end

    def cycle_exists?(node, visited, rec_stack)
      return false if visited[node]
      
      visited[node] = true
      rec_stack[node] = true

      (@graph[node] || []).each do |neighbor|
        return true if rec_stack[neighbor]
        return true if cycle_exists?(neighbor, visited, rec_stack)
      end

      rec_stack[node] = false
      false
    end
  end
end
