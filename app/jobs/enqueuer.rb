require 'unique_id'

module VCAP::CloudController
  module Jobs
    class Enqueuer
      attr_reader :version

      def initialize(job, opts={})
        @job = job
        @opts = opts
        @version = get_version
      end

      def enqueue
        request_id = ::VCAP::Request.current_id
        delayed_job = Delayed::Job.new
        delayed_job.version = @version
        pp delayed_job.version
        Delayed::Job.enqueue(ExceptionCatchingJob.new(RequestJob.new(TimeoutJob.new(@job), request_id)), @opts)
      end
    end
  end
end
