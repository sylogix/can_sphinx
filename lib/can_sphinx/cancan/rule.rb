require 'cancan/rule'
module CanSphinx
  module CanCan
    module Rule
      def self.included(base)
        base.class_eval do 
          attr_reader :sphinx_conditions  
          alias_method :initialize_without_sphinx, :initialize
          alias_method :initialize, :initialize_with_sphinx
          alias_method :relevant_without_sphinx?, :relevant?
          alias_method :relevant?, :relevant_with_sphinx?
        end 
      end    
      
      def initialize_with_sphinx(base_behavior, action, subject, conditions, sphinx_conditions, block)
        raise Error, "You are not able to supply a block with a hash of conditions in #{action} #{subject} ability. Use either one." if conditions.kind_of?(Hash) && !block.nil?
        @match_all = action.nil? && subject.nil?
        @base_behavior = base_behavior
        @actions = [action].flatten
        @subjects = [subject].flatten
        @conditions = conditions || {}
        @sphinx_conditions = sphinx_conditions
        @block = block
      end
    
      def relevant_with_sphinx?(action, subject = nil)
        subject = subject.values.first if subject && subject.class == Hash
        @match_all || subject ? (matches_action?(action) && matches_subject?(subject)) : matches_action?(action)
      end
    end
  end
end
::CanCan::Rule.send :include, ::CanSphinx::CanCan::Rule
