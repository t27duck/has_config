ActiveRecord::Schema.define do
  self.verbose = false

  create_table :basic_models, force: true do |t|
    t.text :configuration
  end

  create_table :parent_models, force: true do |t|
    t.string :type
    t.text :configuration
  end

  create_table :custom_column_models, force: true do |t|
    t.text :prefs
  end

  create_table :json_column_models, force: true do |t|
    t.json :configuration
  end

  create_table :jsonb_column_models, force: true do |t|
    # JSONB support was added in Rails 4.2
    if ActiveRecord.version >= Gem::Version.new('4.2.0')
      t.jsonb :configuration
    else
      t.json :configuration
    end
  end

  create_table :clients, force: true do |t|
    t.json :configuration
  end

  create_table :groups, force: true do |t|
    t.integer :client_id
    t.json :configuration
  end

  create_table :users, force: true do |t|
    t.integer :group_id
    t.json :configuration
  end
end
