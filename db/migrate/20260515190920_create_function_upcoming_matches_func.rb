class CreateFunctionUpcomingMatchesFunc < ActiveRecord::Migration[8.2]
  def change
    create_function :upcoming_matches_func
  end
end
