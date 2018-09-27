require 'spec_helper'

describe 'Deprecated endpoints' do
  describe 'market_research_library' do
    it 'routes to deprecation message' do
      expect(:get => "/v1/market_research_library/search.json?api_key=devkey").to route_to(controller: "deprecated",
                                                                                           action: 'mrl',
                                                                                           version_number: '1',
                                                                                           api_key: 'devkey')
    end
  end
end
