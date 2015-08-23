module Wongi::Engine

  class BetaNode

    include CoreExt

    attr_writer :rete
    attr_reader :parent
    attr_accessor :children
    attr_predicate :debug

    def initialize parent = nil
      @parent = parent
      @children = []
      if parent
        parent.children << self
      end
    end

    def depth
      @depth ||= if parent.nil?
        0
      else
        parent.depth + 1
      end
    end

    def rete
      @rete ||= if parent
        parent.rete
      end
    end

    abstract :alpha_activate
    abstract :alpha_deactivate
    abstract :alpha_reactivate
    abstract :beta_activate
    abstract :beta_deactivate
    abstract :beta_reactivate

    def assignment_node variable, body
      node = AssignmentNode.new self, variable, body
      node.refresh
      node
    end

    def refresh
      parent.refresh_child self
    end

    def refresh_child node
      raise "#{self.class} must implement refresh_child"
    end

    def delete_token token
      # => noop
    end

    def tokens
      Enumerator.new do |y|
        @tokens.dup.each do |token|
          y << token unless token.deleted?
        end
        @tokens.reject! &:deleted?
      end
    end

    def empty?
      @tokens.empty?
    end

    def size
      @tokens.count { |t| not t.deleted? }
    end
    alias_method :length, :size

    private

    def dp message
      if debug?
        puts "#{indent}#{message}"
      end
    end

    def indent
      '  ' * depth
    end

  end

end
