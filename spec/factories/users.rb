FactoryGirl.define do
  factory :user do
    nickname              "test"
    sequence(:email) { Faker::Internet.email }
    password              "00000000"
    phone_number          "00000000000"
    family_name           "てすと"
    first_name            "てすと"
    family_katakana       "テスト"
    first_katakana        "テスト"
    postal_code           "000-0000"
    domicile_pref         "愛知県"
    domicile_city         "テスト市"
    domicile_add          "100丁目"
    building              "テストアパート101"
  end
end
