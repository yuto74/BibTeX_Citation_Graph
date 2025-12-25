# frozen_string_literal: true

require_relative "bib_graph/parser"
require_relative "bib_graph/graph_processor"
require_relative "bib_graph/cli"

module BibGraph
  class Error < StandardError; end
  class CycleDetectedError < Error; end
end
