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
            @sources = argv.option('sources')
            @dependence = argv.option('repo')
            #默认test
            @dependence ||= 'test'
            CBin.config.set_configuration_dependence(@dependence)
            super

            @additional_args = argv.remainder!
          end

          def run
            argvs = [
                repo,
                "--sources=#{sources_option(@sources)}",
                *@additional_args
            ]

            argvs << spec_file if spec_file

            push = Pod::Command::Repo::Push.new(CLAide::ARGV.new(argvs))
            push.validate!
            push.run
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
