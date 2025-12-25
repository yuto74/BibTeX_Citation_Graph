# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "bib_graph"
  spec.version       = "0.1.0"
  spec.authors       = ["Author"]
  spec.summary       = "BibTeX citation relationship visualizer"
  spec.files         = Dir["exe/*", "lib/**/*.rb", "README.md"]
  spec.bindir        = "exe"
  spec.executables   = ["bib_graph"]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "bibtex-ruby", "~> 6.0"
  spec.add_dependency "tty-tree", "~> 0.4.0"
  spec.add_dependency "ruby-graphviz", "~> 1.2"

  spec.add_development_dependency "rspec", "~> 3.12"
end
