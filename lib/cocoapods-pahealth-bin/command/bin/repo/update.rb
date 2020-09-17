require 'parallel'

module Pod
  class Command
    class Bin < Command
      class Repo < Bin
        class Update < Repo
          self.summary = '更新私有源'

          self.arguments = [
              CLAide::Argument.new('NAME', false)
          ]

          def self.options
            [
                ['--trunk-repo-update', '更新官方源']
            ].concat(super)
          end

          def initialize(argv)
            @trunk = argv.flag?('trunk-repo-update',false )
            super
          end

          def run
            show_output = !config.silent?
            Parallel.each(valid_sources(!@trunk), in_threads: 4) do |source|
              source.update(show_output)
            end
          end
        end
      end
    end
  end
end

