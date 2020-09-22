require 'yaml'
require 'cocoapods-pahealth-bin/native/podfile'
require 'cocoapods-pahealth-bin/native/podfile_env'
require 'cocoapods/generate'

module CBin
  class Config
    def config_file
      config_file_with_configuration_dependence(configuration_dependence)
    end

    def template_hash
      {
          'configuration_dependence' => { description: '依赖环境', default: 'uat', selection: %w[uat test] },
          'code_repo_url' => { description: '私有源 Git 地址', default: 'uat环境:https://github.com/GitWangKai/ReleasePrivateRepo.git test环境:https://github.com/GitWangKai/TestPrivateRepo.git' },
      }
    end

    def config_file_with_configuration_dependence(configuration_dependence)
      file = config_uat_dependence_file
      if configuration_dependence == "test"
        file = config_test_dependence_file
        puts "\n======  #{configuration_dependence} 环境 ========"
      elsif configuration_dependence == "uat"
        puts "\n======  #{configuration_dependence} 环境 ========"
      else
        raise "\n=====  #{configuration_dependence} 参数有误，请检查%w[uat test]===="
      end

      File.expand_path("#{Pod::Config.instance.home_dir}/#{file}")
    end

    def configuration_dependence
      #如果是dev 再去 podfile的配置文件中获取，确保是正确的， pod update时会用到
      if @configuration_dependence == "uat" || @configuration_dependence == nil
        if Pod::Config.instance.podfile
          configuration_dependence ||= Pod::Config.instance.podfile.configuration_dependence
        end
        configuration_dependence ||= "uat"
        @configuration_dependence = configuration_dependence
      end
      @configuration_dependence
    end

    def set_configuration_dependence(dependence)
      @configuration_dependence = dependence
    end

    def config_test_dependence_file
      "pahealth_test.yml"
    end

    def config_uat_dependence_file
      "pahealth_uat.yml"
    end

    def sync_config(config)
      File.open(config_file_with_configuration_dependence(config['configuration_dependence']), 'w+') do |f|
        f.write(config.to_yaml)
      end
    end

    def default_config
      @default_config ||= Hash[template_hash.map { |k, v| [k, v[:default]] }]
    end

    private

    def load_config
      if File.exist?(config_file)
        YAML.load_file(config_file)
      else
        default_config
      end
    end

    def config
      @config ||= begin
                    puts "====== cocoapods-pahealth-bin #{CocoapodsPahealthBin::VERSION} 版本 ======== \n"
                    @config = OpenStruct.new load_config
                    validate!
                    @config
                  end
    end

    def validate!
      template_hash.each do |k, v|
        selection = v[:selection]
        next if !selection || selection.empty?

        config_value = @config.send(k)
        next unless config_value
        unless selection.include?(config_value)
          raise Pod::Informative, "#{k} 字段的值必须限定在可选值 [ #{selection.join(' / ')} ] 内".red
        end
      end
    end

    def respond_to_missing?(method, include_private = false)
      config.respond_to?(method) || super
    end

    def method_missing(method, *args, &block)
      if config.respond_to?(method)
        config.send(method, *args)
      elsif template_hash.keys.include?(method.to_s)
        raise Pod::Informative, "#{method} 字段必须在配置文件 #{config_file} 中设置, 请执行 init 命令配置或手动修改配置文件".red
      else
        super
      end
    end
  end

  def self.config
    @config ||= Config.new
  end


end
