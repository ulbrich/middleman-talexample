module TAL
  class Configuration
    CONFIG_PATH = 'source/vendor/antie/config'

    attr_reader :application_id, :device_brand, :device_model,
      :device_configuration
    
    def initialize(application_id, device_brand = 'default',
      device_model = 'webkit'
    )
      @application_id = application_id

      @device_brand = normalise_keynames(device_brand)
      @device_model = normalise_keynames(device_model)

      begin
        raw_config = File.read(device_configuration_file_path)
      rescue
        throw ArgumentError.new("Device configuration #{device_configuration_file_path} not found")
      end

      raw_config.gsub!(/%application%/, application_id)
      #raw_config.gsub!(/%href%/, ???)

      @device_configuration = JSON.parse(raw_config)
    end

    def device_body
      return ''
    end

    def self.device_configurations(application_id)
      return Dir.glob(File.join(CONFIG_PATH, 'devices', '*.json')).collect do |file|
        if (match = file.match(/.*\/([^-]*)-([^-]*)-default.json/))
          Configuration.new(application_id, match[1], match[2])
        else
          nil
        end
      end.compact
    end

    private

      def device_configuration_name
        return device_brand + '-' + device_model
      end

      def device_configuration_file_path
        return CONFIG_PATH + '/devices/' + device_configuration_name + '-default.json';
      end

      def normalise_keynames(name)
        return name.to_s.downcase.gsub(/ /, '_')
      end
  end
end
