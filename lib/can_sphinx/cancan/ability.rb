require 'cancan/ability'
module CanSphinx
  module CanCan
    module Ability
      def self.included(base)
        base.class_eval do 
          alias_method :can_without_sphinx, :can
          alias_method :can, :can_with_sphinx
          alias_method :cannot_without_sphinx, :cannot
          alias_method :cannot, :cannot_with_sphinx
          alias_method :relevant_rules_without_sphinx, :relevant_rules
          alias_method :relevant_rules, :relevant_rules_with_sphinx
        end 
      end    
    
      def can_with_sphinx(action = nil, subject = nil, conditions = nil, sphinx_conditions = nil, &block)
        rules << ::CanCan::Rule.new(true, action, subject, conditions, sphinx_conditions, block)
      end

      def cannot_with_sphinx(action = nil, subject = nil, conditions = nil, sphinx_conditions = nil, &block)
        rules << ::CanCan::Rule.new(false, action, subject, conditions, sphinx_conditions, block)
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
      def relevant_rules_with_sphinx(action, subject = nil)
        rules.reverse.select do |rule|
          rule.expanded_actions = expand_actions(rule.actions)
          rule.relevant? action, subject
        end
      end
    end
  end
end

::CanCan::Ability.send :include, ::CanSphinx::CanCan::Ability

