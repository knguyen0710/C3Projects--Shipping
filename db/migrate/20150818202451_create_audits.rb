class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|

      t.timestamps null: false
    end
  end
end
