config :favorite_color, :string
config :enable_email, :boolean
config :rate_limit, :integer

config :listed_rate_limit, :integer, validations: { inclusion: { in: [1, 2, 3] } }
config :required_favorite_color, :string, validations: { presence: true }
config :favorite_color_default, :string, default: 'red'
