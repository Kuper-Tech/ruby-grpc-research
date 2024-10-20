# frozen_string_literal: true

require 'grpc'
require 'logger'
require 'socket'
require_relative '../shared/pb/hello_services_pb'

PROCESSES_COUNT = 3
THREADS_COUNT = 5
WAIT_QUEUE_SIZE = 32
BIND_IP = '0.0.0.0'
BIND_PORT = 9091
BIND_ADDRESS = "#{BIND_IP}:#{BIND_PORT}"

STDOUT.sync = true

module RubyLogger
  LOGGER = Logger.new(STDOUT)
  def logger = LOGGER
end

module GRPC
  extend RubyLogger
end

class HelloImpl < ::Hello::Greeter::Service
  def say_hello(req, _rpc)
    puts "Processing request in process ##{Process.pid}..."
    ::Hello::HelloReply.new(message: "Hello, #{req.name}!")
  end
end

# Open reusable socket
socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM)
socket_addr = Socket.pack_sockaddr_in(BIND_PORT, BIND_IP)
socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEPORT, true)
raise 'Socket port is not reusable' unless socket.getsockopt(:SOCKET, :REUSEPORT).bool

socket.bind(socket_addr)

PROCESSES_COUNT.times do
  fork do
    server = GRPC::RpcServer.new(
      pool_size: THREADS_COUNT,
      max_waiting_requests: WAIT_QUEUE_SIZE,
      server_args: { 'grpc.so_reuseport' => 1 }
    )
    server.add_http2_port(BIND_ADDRESS, :this_port_is_insecure)
    server.handle(HelloImpl)
    puts "GRPC server is starting in sub-process ##{Process.pid}..."
    server.run_till_terminated
  end
end

begin
  puts "Waiting for all sub-processes from process ##{Process.pid}..."
  Process.waitall
ensure
  puts 'Closing socket...'
  socket.close
end
