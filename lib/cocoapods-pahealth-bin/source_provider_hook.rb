require 'cocoapods-pahealth-bin/native/sources_manager'
require 'cocoapods-pahealth-bin/native/podfile'
require 'cocoapods'

Pod::HooksManager.register('cocoapods-pahealth-bin', :source_provider) do |context, _|
  sources_manager = Pod::Config.instance.sources_manager
  podfile = Pod::Config.instance.podfile

  if podfile
    # 添加源
    added_sources = [sources_manager.trunk_source]
    added_sources << sources_manager.code_source
    added_sources.reverse!

    added_sources.each { |source| context.add_source(source) }
  end
end
