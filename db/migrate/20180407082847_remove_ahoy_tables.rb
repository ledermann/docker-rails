class RemoveAhoyTables < ActiveRecord::Migration[5.2]
  def up
    drop_table :ahoy_events
    drop_table :visits
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
