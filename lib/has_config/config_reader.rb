module HasConfig
  class ConfigReader
    def config(name, type, options={})
      setting = ConfigSetting.new(name, type, options)
      Engine.register_setting setting
    end
  end
end
