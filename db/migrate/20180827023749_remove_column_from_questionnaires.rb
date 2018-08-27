class RemoveColumnFromQuestionnaires < ActiveRecord::Migration[5.1]
  def change
    remove_column :questionnaires, :question21, :integer
    remove_column :questionnaires, :question22, :integer
    remove_column :questionnaires, :question23, :integer
    remove_column :questionnaires, :question24, :integer
    remove_column :questionnaires, :question25, :integer
  end
end
