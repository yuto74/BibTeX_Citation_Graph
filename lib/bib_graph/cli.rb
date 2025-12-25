# frozen_string_literal: true

require "thor"
require "tty-tree"
require "graphviz"

module BibGraph
  class CLI < Thor
    desc "tree CITEID", "Display citation hierarchy for a specific entry"
    option :dir, default: ".", desc: "Directory containing .bib files"
    def tree(citeid)
      data = Parser.new(options[:dir]).parse
      processor = GraphProcessor.new(data)
      
      tree_data = processor.build_tree_hash(citeid)
      puts TTY::Tree.new(tree_data).render
    rescue BibGraph::Error => e
      warn e.message
      exit 1
    end

    desc "export FILENAME", "Export full graph to PNG/PDF"
    option :dir, default: ".", desc: "Directory containing .bib files"
    option :format, default: "png", desc: "Output format (png or pdf)"
    def export(filename)
      data = Parser.new(options[:dir]).parse
      processor = GraphProcessor.new(data)
      
      g = GraphViz.new(:G, type: :digraph)
      nodes = {}

      processor.all_nodes.each { |id| nodes[id] = g.add_nodes(id) }
      processor.edges.each do |from, to_list|
        to_list.each do |to|
          nodes[to] ||= g.add_nodes(to)
          g.add_edges(nodes[from], nodes[to])
        end
      end

      g.output(options[:format].to_sym => filename)
      puts "Graph exported to #{filename}"
    rescue BibGraph::Error => e
      warn e.message
      exit 1
    end
  end
end
