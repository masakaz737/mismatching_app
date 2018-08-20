class CreateQuestionnaires < ActiveRecord::Migration[5.1]
  def change
    create_table :questionnaires do |t|
      t.references :user, foreign_key: true
      t.integer :sex
      t.date :birthday
      t.integer :birthplace
      t.integer :education
      t.integer :job
      t.integer :question1
      t.integer :question2
      t.integer :question3
      t.integer :question4
      t.integer :question5
      t.integer :question6
      t.integer :question7
      t.integer :question8
      t.integer :question9
      t.integer :question10
      t.integer :question11
      t.integer :question12
      t.integer :question13
      t.integer :question14
      t.integer :question15
      t.integer :question16
      t.integer :question17
      t.integer :question18
      t.integer :question19
      t.integer :question20
      t.integer :question21
      t.integer :question22
      t.integer :question23
      t.integer :question24
      t.integer :question25

      t.timestamps
    end
  end
end
