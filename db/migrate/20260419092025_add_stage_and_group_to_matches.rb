class AddStageAndGroupToMatches < ActiveRecord::Migration[8.2]
  def change
    add_column :matches, :stage, :string
    add_column :matches, :group, :string
  end
end
