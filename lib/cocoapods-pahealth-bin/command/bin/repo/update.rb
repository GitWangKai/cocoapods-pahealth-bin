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
            ].concat(super)
          end

          def initialize(argv)
            super
          end

          def run
            show_output = !config.silent?
            Parallel.each(valid_sources, in_threads: 4) do |source|
              source.update(show_output)
              # update_git_repo
            end
          end
        end
      end
    end
  end
end

