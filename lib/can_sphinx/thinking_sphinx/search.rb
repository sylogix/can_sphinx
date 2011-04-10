# encoding: UTF-8
module ThinkingSphinx
  class Search
    def initialize(*args)
      ThinkingSphinx.context.define_indexes
      
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
          @options[:with].merge({:authorized => 1})
        end
      end
  end
end
