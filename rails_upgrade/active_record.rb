module ActiveRecord
  module ConnectionAdapters
    class AbstractAdapter
      def add_index(table_name, column_name, options = {})
        if options.key?(:name)
          options[:name] = options[:name].to_s
        end
        super
      end
    end
  end
end
