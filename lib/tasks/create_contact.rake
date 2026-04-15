namespace :create_contact do
  task run: :environment do
    User.distinct.pluck(:email).each do |email|
      CreateContactJob.perform_later(email)
    end
  end
end
