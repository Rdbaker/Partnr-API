RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Print the 10 slowest examples at the end of the spec run
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies.
  config.order = :random

  Kernel.srand config.seed
end
