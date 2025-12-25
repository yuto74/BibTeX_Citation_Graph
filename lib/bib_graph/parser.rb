# frozen_string_literal: true

require "bibtex"

module BibGraph
  class Parser
    def initialize(directory_path)
      @directory_path = directory_path
    end

    def parse
      data = {}
      bib_files = Dir.glob(File.join(@directory_path, "*.bib"))
      
      bib_files.each do |file|
        bib = BibTeX.open(file)
        bib.each do |entry|
          next unless entry.respond_to?(:key)
          
          cite_id = entry.key.to_s
          references = []
          if entry.respond_to?(:"x-cites") && entry[:"x-cites"]
            references = entry[:"x-cites"].to_s.split(",").map(&:strip)
          end
          data[cite_id] = references
        end
      end
      data
    end
  end
end
