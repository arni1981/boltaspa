class ReminderMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reminder_mailer.send_reminder.subject
  #
  def send_reminder(user)
    mail to: user.email_address
  end
end
