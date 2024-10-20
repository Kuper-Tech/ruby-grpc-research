# frozen_string_literal: true

require 'gruf'
require_relative '../shared/pb/hello_services_pb'

Gruf.configure do |c|
  c.server_binding_url = '0.0.0.0:9091'
  c.event_listener_proc = lambda do |event|
    case event
    when :thread_pool_exhausted
      Gruf.logger.error('gRPC thread pool exhausted!')
    else
      # noop
    end
  end
  c.rpc_server_options = {
    pool_size: 32, # 32 threads
    pool_keep_alive: 1, # 1s
    poll_period: 1 # 1s
  }
end

Gruf.logger = Logger.new($stdout, level: Logger::Severity::INFO)
Gruf.grpc_logger = Logger.new($stdout, level: Logger::Severity::INFO)
Gruf.controllers_path = "#{__dir__}/controllers"

cli = Gruf::Cli::Executor.new
cli.run
