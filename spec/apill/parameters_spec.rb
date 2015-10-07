require 'spec_helper'
require 'apill/parameters'

module    Apill
describe  Parameters do
  it 'can underscore the first parameter' do
    query_params = 'hello-there=bob-jones'

    expect(Parameters.process(query_params)).to eql 'hello_there=bob-jones'
  end

  it 'does not touch params with no dashes' do
    query_params = 'hello_there=bob-jones'

    expect(Parameters.process(query_params)).to eql 'hello_there=bob-jones'
  end

  it 'can underscore a middle parameter and a parameter at the end' do
    query_params = 'hello-there=bob-jones&nice-to-meet=you-bob&hows-the-weather=today-bob'

    expect(Parameters.process(query_params)).to eql 'hello_there=bob-jones&'     \
                                                    'nice_to_meet=you-bob&'      \
                                                    'hows_the_weather=today-bob'
  end

  it 'can handle weirdly formatted parameters' do
    query_params = 'hello-there=bob-jones&nice-to-meet=you-bob&='

    expect(Parameters.process(query_params)).to eql 'hello_there=bob-jones&'     \
                                                    'nice_to_meet=you-bob&='
  end

  it 'can handle parameters with no values' do
    query_params = 'hello-there&nice-to-meet=you-bob&='

    expect(Parameters.process(query_params)).to eql 'hello_there&' \
                                                    'nice_to_meet=you-bob&='
  end

  it 'can handle values with no parameter name' do
    query_params = 'hello-there=bob-jones&=you-bob&nice-to-meet=you-bob&='

    expect(Parameters.process(query_params)).to eql 'hello_there=bob-jones&' \
                                                    '=you-bob&'              \
                                                    'nice_to_meet=you-bob&='
  end
end
end
