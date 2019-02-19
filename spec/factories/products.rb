FactoryGirl.define do
  factory :product do
    name               Faker::Pokemon.name
    status             1
    shipping_method    1
    region             Faker::Address.state
    shipping_timetable 1
    description        Faker::Lorem.sentence
    price              3000
    shipping_burden    1
    image              Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/googlelogo_color_272x92dp.png'))
    association :seller, factory: :user
  end
end
