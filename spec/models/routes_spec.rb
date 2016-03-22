require 'rails_helper'

RSpec.describe Route, type: :model do
  before(:all) do
    @currency_rate = 0.89
    @route = FactoryGirl.build(:route)
    @data = [{
                'name' => 'Fly to Miami, train',
                'duration' => 1252,
                'indicativePrice' => {
                  'price' => 678
                }
             },
             {
               'name' => 'Train',
               'duration' => 242,
               'indicativePrice' => {
                 'price' => 52
               }
             },
             {
               'name' => 'Bus',
               'duration' => 2511,
               'indicativePrice' => {
                 'price' => 111
               }
             },
             {
               'name' => 'Fly to Miami, bus',
               'duration' => 1111,
               'indicativePrice' => {
                 'price' => 5125
               }
             }
            ]
  end

  it 'calculates train price avg correctly' do
    calc = @route.extract_info(@data, 'train')
    expect(calc[:avg_price]).to eq(52 * @currency_rate)
  end

  it 'calculates bus price avg correctly' do
    calc = @route.extract_info(@data, 'bus')
    expect(calc[:avg_price]).to eq(111 * @currency_rate)
  end

  it 'calculates flight price avg correctly' do
    calc = @route.extract_info(@data, 'fly')
    expected = ((5125 + 678).to_f / 2) * @currency_rate
    expect(calc[:avg_price]).to eq(expected)
  end
end
