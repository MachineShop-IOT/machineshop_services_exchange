class AddIntialWidgetsToWidgetModel < ActiveRecord::Migration
  def change
    default_widgets = %w(user_profile system_status api_usage last_device_report device_overview rule_management system_usage user_management customer_management custom_api_management)

    default_widgets.each do |name|
      Widget.create(name: name)
    end
  end
end
