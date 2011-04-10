module CanCan
  class Rule # :nodoc:
    attr_reader :sphinx_conditions  
    def initialize(base_behavior, action, subject, conditions, sphinx_conditions, block)
      raise Error, "You are not able to supply a block with a hash of conditions in #{action} #{subject} ability. Use either one." if conditions.kind_of?(Hash) && !block.nil?
      @match_all = action.nil? && subject.nil?
      @base_behavior = base_behavior
      @actions = [action].flatten
      @subjects = [subject].flatten
      @conditions = conditions || {}
      @sphinx_conditions = sphinx_conditions
      @block = block
    end
  
    def relevant?(action, subject = nil)
      subject = subject.values.first if subject && subject.class == Hash
      @match_all || subject ? (matches_action?(action) && matches_subject?(subject)) : matches_action?(action)
    end
  end
end
