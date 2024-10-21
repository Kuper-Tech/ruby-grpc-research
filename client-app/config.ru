require 'rack'
require 'gruf'
# require 'yabeda/gruf'
require 'yabeda/prometheus/mmap'
require '/shared/pb/hello_services_pb'
require_relative 'metrics'

Yabeda.configure!
Yabeda::Prometheus::Exporter.start_metrics_server!

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
