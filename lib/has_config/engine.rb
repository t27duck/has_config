module HasConfig
  class Engine
    def self.settings
      @settings ||= {}
    end

    def self.load(path: 'config/settings.rb')
      raise ConfigurationNotFound, "No such file '#{path}'" unless File.exist?(path)
      clear_settings
      ConfigReader.new.instance_eval(File.read(path))
    end

    def self.register_setting(setting)
      settings[setting.name] = setting
    end

    def self.clear_settings
      @settings = {}
    end
  end
end
