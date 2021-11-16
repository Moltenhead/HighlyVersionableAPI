RSpec.configure do |config|
  print "in"
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  %i[each all].each do |sym|
    config.before(sym) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
    config.beofre(sym, :js => true) { DatabaseCleaner.strategy = :truncation }
    config.after(sym) { DatabaseCleaner.clean }
  end
end