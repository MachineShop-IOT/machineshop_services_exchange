class CreateDashboards < ActiveRecord::Migration
  def self.up
    create_table :dashboards do |t|
      t.string :widget_column1, :default => "user_profile,system_status,api_usage"
      t.string :widget_column2, :default => "last_device_report,device_overview,system_usage,user_management"
      t.timestamps
    end
  end

  def self.down
    drop_table :dashboards
  end
end
