require 'cocoapods-pahealth-bin/config/config'
require 'cocoapods-pahealth-bin/native/podfile'

module Pod
  class Command
    class Bin < Command
      class Repo < Bin
        class Push < Repo
          self.summary = '发布组件.'
          self.description = <<-DESC
            发布组件
          DESC

          self.arguments = [
              CLAide::Argument.new('NAME.podspec', false)
          ]

          def self.options
            [
                ['--trunk-dependencies', 'push 到官方源'],
            ].concat(Pod::Command::Repo::Push.options).concat(super).uniq
          end

          def initialize(argv)
            @podspec = argv.shift_argument
            @trunk_dependencies = argv.flag?('trunk-dependencies')
            @sources = argv.option('sources') || []
            super

            @additional_args = argv.remainder!
          end

          def run
            Podfile.execute_with_bin_plugin do
              Podfile.execute_with_allow_prerelease(@allow_prerelease) do
                Podfile.execute_with_use_binaries(!@code_dependencies) do
                  argvs = [
                      repo,
                      "--sources=#{sources_option(!@trunk_dependencies, @sources)}",
                      *@additional_args
                  ]

                  argvs << spec_file if spec_file

                  push = Pod::Command::Repo::Push.new(CLAide::ARGV.new(argvs))
                  push.validate!
                  push.run
                end
              end
            end
          ensure
            clear_binary_spec_file_if_needed unless @reserve_created_spec
          end

          private

          def spec_file
            @spec_file ||= begin
                             if @podspec
                               find_spec_file(@podspec)
                             else
                               if code_spec_files.empty?
                                 raise Informative, '当前目录下没有找到可用源码 podspec.'
                               end

                               spec_file = code_spec_files.first
                               spec_file
                             end
                           end
          end

          def repo
            code_source.name
          end
        end
      end
    end
  end
end
