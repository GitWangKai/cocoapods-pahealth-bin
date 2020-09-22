require 'cocoapods-pahealth-bin/command/bin/repo/update'
require 'cocoapods-pahealth-bin/native/podfile'
require 'cocoapods'

module Pod
  class Command
    class Bin < Command
      class Update < Bin
        self.summary = 'pod update私有源'
        self.arguments = [
            CLAide::Argument.new('NAME.podspec', false)
        ]

        def self.options
          [
          ].concat(Pod::Command::Spec::Lint.options).concat(super).uniq
        end

        def initialize(argv)
          super
        end

        def run
          #1.clone Private repo
          clone_private_repo
          #2.执行 pod update --no-repo-update
          pod_update_no_repo_update
        end

        def clone_private_repo
          argvs = []
          private = Pod::Command::Bin::Repo::Update.new(CLAide::ARGV.new(argvs))
          private.validate!
          private.run
        end

        def pod_update_no_repo_update
          argvs = [
              "--no-repo-update"
          ]
          update = Pod::Command::Update.new(CLAide::ARGV.new(argvs))
          update.validate!
          update.run
        end

      end
    end
  end
end

