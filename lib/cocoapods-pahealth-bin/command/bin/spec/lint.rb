require 'cocoapods-pahealth-bin/config/config'
require 'cocoapods-pahealth-bin/native/podfile'

module Pod
  class Command
    class Bin < Command
      class Spec < Bin
        class Lint < Spec
          self.summary = 'lint spec.'
          self.description = <<-DESC
            spec lint 组件
          DESC

          self.arguments = [
              CLAide::Argument.new(%w[NAME.podspec DIRECTORY http://PATH/NAME.podspec], false, true)
          ]

          def self.options
            [
                ['--release', '在 release 环境下进行 lint']
            ].concat(Pod::Command::Spec::Lint.options).concat(super).uniq
          end

          def initialize(argv)
            @podspec = argv.shift_argument
            @release = argv.flag?('release',false )
            @sources = argv.option('sources')
            @allow_prerelease = argv.flag?('allow-prerelease')
            super

            @additional_args = argv.remainder!
          end

          def run
            Podfile.execute_with_bin_plugin do
              Podfile.execute_with_allow_prerelease(@allow_prerelease) do
                argvs = [
                    "--sources=#{sources_option(@release, @sources)+','+Pod::TrunkSource::TRUNK_REPO_URL}",
                    *@additional_args
                ]
                argvs << spec_file if spec_file
                lint = Pod::Command::Spec::Lint.new(CLAide::ARGV.new(argvs))
                lint.validate!
                lint.run
              end
            end
          end

          private

          def spec_file
            @spec_file ||= begin
                             if @podspec
                               find_spec_file(@podspec) || @podspec
                             else
                               if code_spec_files.empty?
                                 raise Informative, '当前目录下没有找到可用源码 podspec.'
                               end

                               spec_file = code_spec_files.first
                               spec_file
                             end
                           end
          end
        end
      end
    end
  end
end

