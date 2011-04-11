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
      def initialize_with_sphinx(*args)
        ::ThinkingSphinx.context.define_indexes
        
        @array    = []
        @options  = args.extract_options!
        @args     = args

        set_authorizations_options if options[:authorize_with]
        
        add_default_scope unless options[:ignore_default]
        
        populate if @options[:populate]
      end
      private
        def set_authorizations_options
          if !@options[:sphinx_select] and @options[:sphinx_select] = options[:authorize_with].sphinx_conditions(:index, classes)
            @options[:with] ||= {}
            @options[:with].merge!({:authorized => 1})
          end
        end
    end
  end
end
::ThinkingSphinx::Search.send :include, ::CanSphinx::ThinkingSphinx::Search
