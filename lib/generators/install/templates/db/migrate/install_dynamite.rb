class InstallDynamite < ActiveRecord::Migration
  def change

    create_table "form_schemas" do |t|
      t.integer  "form_id"
      t.text     "data"
      t.timestamps
    end

    create_table "form_submissions" do |t|
      t.integer  "form_schema_id"
      t.timestamps
    end

    create_table "form_vars" do |t|
      t.integer  "form_submission_id"
      t.string   "key"
      t.text     "value"
      t.timestamps
    end

    create_table "forms" do |t|
      t.string   "name"
      t.timestamps
    end
    
  end
end
