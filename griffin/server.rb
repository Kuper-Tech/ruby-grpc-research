# frozen_string_literal: true

require 'grpc_kit'
require 'griffin'
require_relative '../shared/pb/hello_services_pb'
require_relative '../shared/fetch_data'

class GreeterServer < Hello::Greeter::Service
  include GrpcKit::Grpc::GenericService

  def say_hello(request, _call)
    FetchData.call
    Hello::HelloReply.new(message: "Hello, #{request.name}!")
  end
end

Griffin::Server.configure do |c|
  c.bind '0.0.0.0'
  c.port 9091

  # runs in single mode
  c.workers 4
  c.pool_size 20, 20
  c.connection_size 8, 8

  c.services GreeterServer.new
end

Griffin::Server.run
