require 'thinking_sphinx/search/merger'
module CanSphinx
  module ThinkingSphinx
    module Search
      module Merger
        def self.included(base)
          base.class_eval do 
            alias_method :merge_without_sphinx, :merge!
            alias_method :merge!, :merge_with_sphinx
          end
        end

        def merge_with_sphinx(query = nil, options = {})
          merge_without_sphinx(query, options)
          set_authorizations_options if @search.options[:authorize_with] && @search.options[:classes]
          @search
        end

        private

        def set_authorizations_options
          if !@search.options[:sphinx_select] and @search.options[:authorize_with] and @search.options[:sphinx_select] = @search.options[:authorize_with].sphinx_conditions(@search.options[:classes])
            puts @search.options[:sphinx_select]
            @search.options[:with] ||= {}
            @search.options[:with].merge!({:authorized => 1})
          end
        end

      end
    end
  end
end
::ThinkingSphinx::Search::Merger.send :include, ::CanSphinx::ThinkingSphinx::Search::Merger
