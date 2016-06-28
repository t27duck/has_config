module HasConfig
  class Engine
    def self.settings
      @settings ||= {}
    end

    def self.load(filepath='config/settings.rb')
      raise ConfigurationNotFound, "No such file '#{filepath}'" unless File.exist?(filepath)
      clear_settings
      ConfigReader.new.instance_eval(File.read(filepath))
    end

    def self.register_setting(setting)
      settings[setting.name] = setting
    end

    def self.clear_settings
      @settings = {}
    end
  end
end
