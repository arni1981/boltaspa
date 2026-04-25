class AddSendReminderEmailToUsers < ActiveRecord::Migration[8.2]
  def change
    add_column :users, :send_reminder_email, :boolean, default: true
  end
end
