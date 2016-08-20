module HasConfig
  class Engine
    class ConfigurationFileReader
      def has_config(name, config: {})
        Engine.register_configuration Configuration.new(name, config)
      end
    end

    def self.known_configurations
      @known_configurations ||= {}
    end

    def self.load(path: 'config/has_config.rb')
      raise ConfigurationFileNotFound, "No such file '#{path}'" unless File.exist?(path)
      clear_configurations
      ConfigurationFileReader.new.instance_eval(File.read(path))
    end

    def self.register_configuration(configuration)
      known_configurations[configuration.name.to_sym] = configuration
    end

    def self.clear_configurations
      @known_configurations = {}
    end
  end
end
