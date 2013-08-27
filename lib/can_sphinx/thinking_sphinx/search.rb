require 'thinking_sphinx/search'
module CanSphinx
  module ThinkingSphinx
    module Search
      def self.included(base)
        base.class_eval do 
          alias_method :initialize_without_sphinx, :initialize
          alias_method :initialize, :initialize_with_sphinx
        end 
      end        

      def initialize_with_sphinx(query = nil, options = {})
        query, options   = nil, query if query.is_a?(Hash)
        @query, @options = query, options
        @masks           = @options.delete(:masks) || ::ThinkingSphinx::Search::DEFAULT_MASKS
        @middleware      = @options.delete(:middleware)

        set_authorizations_options if options[:authorize_with]
        populate if options[:populate]
      end
      private
        def set_authorizations_options
          if !options[:sphinx_select] and options[:authorize_with] and @options[:sphinx_select] = options[:authorize_with].sphinx_conditions(!classes.empty?? classes : ::ThinkingSphinx.context.indexed_models.map(&:constantize))
            @options[:with] ||= {}
            @options[:with].merge!({:authorized => 1})
          end
        end
    end
  end
end
::ThinkingSphinx::Search.send :include, ::CanSphinx::ThinkingSphinx::Search
