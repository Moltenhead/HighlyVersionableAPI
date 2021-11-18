RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  %i[each all].each do |sym|
    config.before(sym, :js => true) { DatabaseCleaner.strategy = :truncation }
    config.before(sym) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
    config.after(sym) { DatabaseCleaner.clean }
  end
end
