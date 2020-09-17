require 'cocoapods'
require 'cocoapods-pahealth-bin/config/config'

module Pod
  class Source
    class Manager
      # 源码 source
      def code_source
        source_with_name_or_url(CBin.config.code_repo_url)
      end

      # 二进制 source
      def binary_source
        source_with_name_or_url(CBin.config.binary_repo_url)
      end

      def trunk_source
        source_with_name_or_url('https://github.com/CocoaPods/Specs.git')
      end
    end
  end
end
