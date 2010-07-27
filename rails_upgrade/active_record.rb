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

  class Base
    def self.before_validation_on_create(name = nil, &block)
      if name
        before_validation name, :on => :create
      else
        before_validation({:on => :create}, &block)
      end
    end

    def self.validate_on_create(name = nil, &block)
      if name
        validate name, :on => :create
      else
        validate({:on => :create}, &block)
      end
    end
  end
end
