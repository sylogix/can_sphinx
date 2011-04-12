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
        end
      end

      def can_with_sphinx(action = nil, subject = nil, conditions = nil, sphinx_conditions = nil, &block)
        rules << ::CanCan::Rule.new(true, action, subject, conditions, sphinx_conditions, block)
      end

      def cannot_with_sphinx(action = nil, subject = nil, conditions = nil, sphinx_conditions = nil, &block)
        rules << ::CanCan::Rule.new(false, action, subject, conditions, sphinx_conditions, block)
      end

      def sphinx_conditions(classes)

        action = :index
        model_conditions = classes.map {|model| sphinx_condition_for(action, model)}     
        if model_conditions.include?(:all)
          false
        else
          "*, IF(#{model_conditions.compact.join(' OR ')},1,0) AS authorized"        
        end
      end

      private
        def sphinx_condition_for(action, model)
          model_conditions = relevant_rules(action, model).map do |rule|
            if rule.subjects.include?(:all) and rule.base_behavior
              :all
            elsif rule.sphinx_conditions
              (!rule.base_behavior ? 'NOT ':'') +'('+rule.sphinx_conditions+')'
             end
          end
          model_conditions.compact!
          if model_conditions.include?(:all)
            :all
          else
            #"(class_crc = #{model.to_crc32} AND (#{model_conditions.empty? ? '0': model_conditions.join(' OR ')}))"
            "IF(class_crc = #{model.to_crc32},(#{model_conditions.empty? ? '0': model_conditions.join(' OR ')}),0)"
          end
        end

    end
  end
end

::CanCan::Ability.send :include, ::CanSphinx::CanCan::Ability

