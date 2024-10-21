require 'rack'
require 'gruf'
require '/shared/pb/hello_services_pb'
require_relative 'metrics'

run do |env|
  grpc_host = env['REQUEST_PATH'].to_s.split('/').last

  client = ::Gruf::Client.new(
    service: ::Hello::Greeter,
    options: { hostname: "#{grpc_host}:9091" },
    client_options: {
      interceptors: [GrufClientMetrics.new(grpc_host)],
      timeout: 5
    }
  )
  response = client.call(:SayHello, name: 'Dmitry')
  [200, {}, [response.message.inspect]]
end
