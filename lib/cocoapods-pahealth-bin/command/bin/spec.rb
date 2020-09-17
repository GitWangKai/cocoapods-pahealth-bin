# require 'cocoapods-pahealth-bin/command/bin/spec/create'
require 'cocoapods-pahealth-bin/command/bin/spec/lint'

module Pod
  class Command
    class Bin < Command
      class Spec < Bin
        self.abstract_command = true
        self.summary = '管理 spec.'
      end
    end
  end
end

