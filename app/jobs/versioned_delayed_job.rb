require 'unique_id'

module VCAP::CloudController
  module DelayedJob
  class VersionedDelayedJob
    attr_reader :version

    def initialize
      @version = get_version
      super
    end
  end
  end
end
