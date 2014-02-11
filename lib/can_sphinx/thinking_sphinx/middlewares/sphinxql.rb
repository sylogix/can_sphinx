require 'thinking_sphinx/middlewares/sphinxql'
module CanSphinx
  module ThinkingSphinx
    module Middlewares
      module SphinxQL
        module Inner
        def self.included(base)
          base.class_eval do
            alias_method :extended_query_without_sphinx, :extended_query
            alias_method :extended_query, :extended_query_with_sphinx
          end
        end
        private

        def extended_query_with_sphinx
          if @extended_query.nil?
            extended_query_without_sphinx
            @extended_query = options[:authorize_with].sphinx_match_conditions(options[:classes], @extended_query)
          end
          @extended_query
        end

        end
      end
    end
  end
end
::ThinkingSphinx::Middlewares::SphinxQL::Inner.send :include, ::CanSphinx::ThinkingSphinx::Middlewares::SphinxQL::Inner
