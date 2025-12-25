# frozen_string_literal: true

module BibGraph
  class GraphProcessor
    def initialize(data)
      @data = data
      validate_dag!
    end

    def build_tree_hash(root_id, max_depth: nil, current_depth: 0)
      node_info = @data[root_id]
      label = format_label(root_id, node_info)

      return label if max_depth && current_depth >= max_depth
      
      children = node_info ? node_info[:references] : []
      return label if children.empty?

      { label => children.map { |child| build_tree_hash(child, max_depth: max_depth, current_depth: current_depth + 1) } }
    end

    def filter_data(author: nil, year: nil, query: nil)
      @data.select do |_, info|
        (author.nil? || info[:author].include?(author)) &&
        (year.nil? || info[:year] == year) &&
        (query.nil? || info[:title].include?(query))
      end
    end

    def all_nodes
      @data.keys
    end

    def edges
      @data.transform_values { |v| v[:references] }
    end

    private

    def format_label(id, info)
      return id unless info
      "#{id} (#{info[:year]}) [#{info[:author]}] \"#{info[:title]}\""
    end

    def validate_dag!
      visited = {}
      rec_stack = {}
      @data.each_key do |node|
        if cycle_exists?(node, visited, rec_stack)
          raise CycleDetectedError, "Cycle detected in citation graph"
        end
      end
    end

    def cycle_exists?(node, visited, rec_stack)
      return false if visited[node]
      visited[node] = true
      rec_stack[node] = true
      (@data[node] ? @data[node][:references] : []).each do |neighbor|
        return true if rec_stack[neighbor]
        return true if cycle_exists?(neighbor, visited, rec_stack)
      end
      rec_stack[node] = false
      false
    end
  end
end