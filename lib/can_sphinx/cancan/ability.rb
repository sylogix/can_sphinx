module CanCan
  module Ability

    def can(action = nil, subject = nil, conditions = nil, sphinx_conditions = nil, &block)
      rules << Rule.new(true, action, subject, conditions, sphinx_conditions, block)
    end

    def cannot(action = nil, subject = nil, conditions = nil, sphinx_conditions = nil, &block)
      rules << Rule.new(false, action, subject, conditions, sphinx_conditions, block)
    end  
    
    def sphinx_conditions(action, classes)
      sphinx_conditions = []
      if classes.empty?
        relevant_rules(action,nil).each do |rule|
          sphinx_conditions << rule.sphinx_conditions if rule.sphinx_conditions
        end
      else
        classes.each do |subject|
          relevant_rules(action, subject).each do |rule|
            sphinx_conditions << rule.sphinx_conditions if rule.sphinx_conditions
          end        
        end      
      end
      "*, IF((#{sphinx_conditions.join(') OR (')}),1,0) AS authorized" unless sphinx_conditions.empty?
    end
    private
    def relevant_rules(action, subject = nil)
      rules.reverse.select do |rule|
        rule.expanded_actions = expand_actions(rule.actions)
        rule.relevant? action, subject
      end
    end    
  end
end
