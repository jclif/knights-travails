require './tree_node'
require 'debugger';debugger

class KnightPathFinder
  attr_accessor :move_tree

  def initialize(init_pos)
    @init_pos = init_pos
    @move_tree = build_move_tree
  end

  def find_path(target_pos)
    node = TreeNode.bfs(@move_tree,target_pos)
    p reverse_traverse(node).map{|x|x.value}
  end

  def reverse_traverse(node)
    array = []
    current = node
    until current == nil
      array << current
      current = current.parent
    end

    array
  end

  def build_move_tree
    parent = TreeNode.new(@init_pos)
    possible_nodes = new_move_positions(@init_pos).map{|pos|TreeNode.new(pos,parent)}
    visited_nodes = []
    until possible_nodes == []
      new_nodes = []
      possible_nodes.each do |from_node|
        new_move_positions(from_node.value).each do |to_pos|
          if not visited_nodes.map{ |x| x.value }.include?(to_pos)
            child = TreeNode.new(to_pos,from_node)
            visited_nodes << child
            new_nodes << child
          end
        end
      end

      possible_nodes = new_nodes.dup
    end

    parent
  end

  def new_move_positions(pos)
    moves = []
    move_diff = [[1,2],[2,1],[-1,2],[2,-1],[1,-2],[-2,1],[-1,-2],[-2,-1]]

    move_diff.each do |diff|
      moves << [pos,diff].transpose.map { |x| x.reduce(:+) }
    end

    moves.delete_if { |move| not on_board?(move)}
  end

  def on_board?(pos)
    pos[0].between?(0,7) and pos[1].between?(0,7)
  end

end

if __FILE__ == $0
  kpf = KnightPathFinder.new([1,1])
  kpf.find_path([5,6])
end