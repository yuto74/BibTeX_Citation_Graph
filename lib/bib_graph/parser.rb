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
          data[cite_id] = {
            references: extract_references(entry),
            author: entry.respond_to?(:author) ? entry.author.to_s : "Unknown",
            year: entry.respond_to?(:year) ? entry.year.to_s : "n.d.",
            title: entry.respond_to?(:title) ? entry.title.to_s : "No Title"
          }
        end
      end
      data
    end

    private

    def extract_references(entry)
      return [] unless entry.respond_to?(:"x-cites") && entry[:"x-cites"]
      entry[:"x-cites"].to_s.split(",").map(&:strip)
    end
  end
end