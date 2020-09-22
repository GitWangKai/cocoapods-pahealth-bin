require 'cocoapods-pahealth-bin/native/sources_manager.rb'

module CBin
  module SourcesHelper
    def sources_manager
      Pod::Config.instance.sources_manager
    end

    def code_source
      sources_manager.code_source
    end

    def valid_sources
      sources = [code_source]
      sources
    end

    def sources_option(additional_sources)
      (valid_sources.map(&:url) + Array(additional_sources)).join(',')
    end
  end
end
