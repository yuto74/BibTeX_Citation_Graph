# frozen_string_literal: true

require "thor"
require "tty-tree"
require "graphviz"

module BibGraph
  class CLI < Thor
    class_option :dir, default: ".", desc: "Directory containing .bib files"

    desc "tree CITEID", "Display citation hierarchy with metadata and depth limit"
    option :depth, type: :numeric, desc: "Limit the depth of the tree"
    def tree(citeid)
      data = Parser.new(options[:dir]).parse
      processor = GraphProcessor.new(data)
      
      tree_data = processor.build_tree_hash(citeid, max_depth: options[:depth])
      puts TTY::Tree.new(tree_data).render
    rescue BibGraph::Error => e
      warn e.message
      exit 1
    end

    desc "export FILENAME", "Export filtered graph to image"
    option :format, default: "png", desc: "Output format (png or pdf)"
    option :author, desc: "Filter by author name"
    option :year, desc: "Filter by year"
    option :query, desc: "Filter by title keyword"
    def export(filename)
      all_data = Parser.new(options[:dir]).parse
      processor = GraphProcessor.new(all_data)
      
      filtered_ids = processor.filter_data(
        author: options[:author], 
        year: options[:year], 
        query: options[:query]
      ).keys

      g = GraphViz.new(:G, type: :digraph)
      nodes = {}

      processor.all_nodes.each do |id|
        next unless filtered_ids.include?(id)
        nodes[id] = g.add_nodes(id)
      end

      processor.edges.each do |from, to_list|
        next unless nodes[from]
        to_list.each do |to|
          next unless nodes[to]
          g.add_edges(nodes[from], nodes[to])
        end
      end

      g.output(options[:format].to_sym => filename)
      puts "Graph exported to #{filename} (Nodes: #{nodes.size})"
    rescue BibGraph::Error => e
      warn e.message
      exit 1
    end
  end
end