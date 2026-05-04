class CreateStandingsViews < ActiveRecord::Migration[8.2]
  def change
    create_view :standings_views
  end
end
