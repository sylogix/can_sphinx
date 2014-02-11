require 'cancan/rule'
module CanSphinx
  module CanCan
    module Rule
      def self.included(base)
        base.class_eval do
          attr_reader :sphinx_conditions
          alias_method :initialize_without_sphinx, :initialize
          alias_method :initialize, :initialize_with_sphinx
        end
      end

      def initialize_with_sphinx(base_behavior, action, subject, conditions, sphinx_conditions, block)
        raise ::CanCan::Error, "You are not able to supply a block with a hash of conditions in #{action} #{subject} ability. Use either one." if conditions.kind_of?(Hash) && !block.nil?
        @match_all = action.nil? && subject.nil?
        @base_behavior = base_behavior
        @actions = [action].flatten
        @subjects = [subject].flatten
        @conditions = conditions || {}
        @sphinx_conditions = sphinx_conditions.is_a?(String) ? {with: sphinx_conditions} : sphinx_conditions
        @block = block
      end
    end
  end
end
::CanCan::Rule.send :include, ::CanSphinx::CanCan::Rule
