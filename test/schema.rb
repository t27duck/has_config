ActiveRecord::Schema.define do
  self.verbose = false

  create_table :custom_column_models, force: true do |t|
    t.text :prefs
  end

  create_table :hash_models, force: true do |t|
    t.text :configuration
  end

  create_table :json_models, force: true do |t|
    t.json :configuration
  end

  create_table :with_defaults, force: true do |t|
    t.text :configuration
  end

  create_table :with_validations, force: true do |t|
    t.text :configuration
  end

  create_table :chain_one, force: true do |t|
    t.integer :chain_two_id
    t.json :configuration, default: {}
  end

  create_table :chain_two, force: true do |t|
    t.integer :chain_three_id
    t.json :configuration, default: {}
  end

  create_table :chain_three, force: true do |t|
    t.json :configuration, default: {}
  end
end
