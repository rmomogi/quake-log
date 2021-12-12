# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    code { FFaker::Random.rand(0..100) }
    name { FFaker::Name.name }
    kills { 0 }
  end
end
