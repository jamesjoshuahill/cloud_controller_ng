require 'spec_helper'

module VCAP::CloudController
  module DelayedJob
    describe VersionedDelayedJob do
      it 'is added during initialization' do
        job = VersionedDelayedJob.new
        expect(job.version).not_to be_empty
      end

      it 'also adds git_sha on other types of delayed jobs' do
        jobs = Delayed::Job.all
        pp jobs
      end
    end
  end
end
