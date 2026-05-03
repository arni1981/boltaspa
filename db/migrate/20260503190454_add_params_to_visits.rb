class AddParamsToVisits < ActiveRecord::Migration[8.2]
  def change
    add_column :visits, :params, :jsonb
  end
end
