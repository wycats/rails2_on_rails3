module Rails
  class Application
    class Configuration
      def load_paths
        autoload_paths
      end

      def gem(name, options = {})
        super name, options[:version] || ">= 0"
        require options[:lib] || name
      rescue Gem::LoadError
        puts "Tried, but failed, to load #{name}"
      end
    end
  end
end
