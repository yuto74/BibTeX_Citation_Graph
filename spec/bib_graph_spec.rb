# frozen_string_literal: true

RSpec.describe BibGraph::GraphProcessor do
  it "builds a tree hash from valid DAG data" do
    data = { "A" => ["B", "C"], "B" => ["D"], "C" => [], "D" => [] }
    processor = BibGraph::GraphProcessor.new(data)
    expect(processor.build_tree_hash("A")).to eq({ "A" => [{ "B" => ["D"] }, "C"] })
  end

  it "raises CycleDetectedError when a cycle exists" do
    data = { "A" => ["B"], "B" => ["C"], "C" => ["A"] }
    expect { BibGraph::GraphProcessor.new(data) }.to raise_error(BibGraph::CycleDetectedError)
  end
end