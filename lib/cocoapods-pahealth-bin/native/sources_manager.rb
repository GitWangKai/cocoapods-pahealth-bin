require 'cocoapods'
require 'cocoapods-pahealth-bin/config/config'

module Pod
  class Source
    class Manager
      # 私有源
      def code_source
        source_with_name_or_url(CBin.config.code_repo_url)
      end

      # 公有源 source
      def trunk_source
        source_with_name_or_url('https://github.com/CocoaPods/Specs.git')
      end

    end
  end
end
