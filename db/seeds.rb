User.destroy_all
League.destroy_all

email = Faker::Internet.email
pass = 'abcd1234'

user = User.create!(
  name: Faker::FunnyName.three_word_name,
  email_address: email,
  password: pass,
  password_confirmation: pass
)

league = League.create!(
  owner: user,
  name: 'Boltaspá Main League'
)

leag_comp = league.league_competitions.create!(
  competition: Competition.find_by_code('PL'),
  season: Competition.find_by_code('PL').seasons.find_by_year(2025)
)

10.times do |n|
  user = User.create!(
    name: Faker::FunnyName.three_word_name,
    email_address: Faker::Internet.email,
    password: pass,
    password_confirmation: pass
  )

  league.members << user
end

puts "Log in with #{email} and '#{pass}'"
