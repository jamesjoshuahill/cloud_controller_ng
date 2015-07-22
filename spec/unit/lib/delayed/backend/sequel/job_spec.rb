require 'spec_helper'

describe Delayed::Backend::Sequel::Job do
  it 'has a cf_api_error column that can store large blobs of json' do
    expect(Delayed::Backend::Sequel::Job.columns).to include(:cf_api_error)

    columns = Sequel::Model.db.schema(:delayed_jobs)
    cf_api_error_properties = columns.detect do |name, _|
      name == :cf_api_error
    end.last

    expect(cf_api_error_properties[:db_type]).to eq('text')
  end

  it 'contains a column to store current cloud controller git checkout sha' do
    expect(Delayed::Backend::Sequel::Job.columns).to include(:git_sha)

    columns = Sequel::Model.db.schema(:delayed_jobs)
    git_sha = columns.detect do |name, _|
      name=:git_sha
    end.last

    expect(git_sha[:db_type].to eq('varchar'))
  # attempts
  # handler

  end
end
