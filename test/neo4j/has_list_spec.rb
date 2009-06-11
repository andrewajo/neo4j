$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../lib")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/..")

require 'neo4j'
require 'neo4j/spec_helper'


class ListNode
  include Neo4j::NodeMixin
  has_list :items
end

class XNode
  include Neo4j::NodeMixin
  property :name

  def to_s
    "node: #{name}"
  end
end

describe "ListNode (Neo4j::NodeMixin#has_list)" do

  # Called before each example.
  before(:each) do
    # Do nothing
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  it "should contain items after append one item to a list (#<<)" do
    list = ListNode.new
    list.relation?(:items).should be_false
    list.items << XNode.new
    list.relation?(:items).should be_true
  end

  it "should contain two items after appending two items (#<<)" do
    list = ListNode.new
    list.relation?(:items).should be_false
    a = XNode.new
    a.name = 'a'
    list.items << a
    b = XNode.new
    b.name = 'b'
    list.items << b

    # check what is connected to what, list -> b -> a
    list.relations.outgoing(:items).nodes.first.should == b
    b.relations.outgoing(:items).nodes.first.should == a
  end

  it "should be empty when its empty (#empty?)" do
    list = ListNode.new
    list.items.empty?.should be_true
    list.items << XNode.new
    list.items.empty?.should be_false
  end

  it "should implement each" do
    list = ListNode.new
    list.items.empty?.should be_true
    a = XNode.new
    a.name = 'a'
    list.items << a
    b = XNode.new
    b.name = 'b'
    list.items << b
    list.items.should include(a)
    list.items.should include(b)
    list.items.to_a.size.should == 2
  end

end