Sequel.migration do
  up do
    add_column :delayed_jobs, :version, String, null: true
  end

  down do
    drop_column :delayed_jobs, :version
  end
end
