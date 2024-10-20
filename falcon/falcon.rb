# frozen_string_literal: true

load :rack

service 'falcon' do
  include Falcon::Environment::Rack

  count(4)

  endpoint Async::HTTP::Endpoint.parse('http://0.0.0.0:9091').with(protocol: Async::HTTP::Protocol::HTTP2)
end
