FactoryGirl.define do
  factory :project do
    name ' blsq-jane-matcher'
    region 'us'
    domain 'blsq-jane-matcher.herokuapp.com'
    autobus_token ''

    trait :postgresql do
      db_connector Project.db_connectors.keys.index('postgresql')
    end

    trait :clear_db do
      db_connector Project.db_connectors.keys.index('clear_db')
    end

    trait :jaws_db do
      db_connector Project.db_connectors.keys.index('jaws_db')
    end

    trait :with_autobus_token do
      autobus_token '12345'
    end

    factory :missing_autobus_token_project, traits: %i[clear_db]
    factory :pg_project, traits: %i[postgresql with_autobus_token]
  end
end
