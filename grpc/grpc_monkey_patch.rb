module GRPC
  class Pool
    def initialize(size, keep_alive: DEFAULT_KEEP_ALIVE)
      fail 'pool size must be positive' unless size > 0
      @jobs = Queue.new
      @size = size
      @stopped = false
      @stop_mutex = Mutex.new # needs to be held when accessing @stopped
      @stop_cond = ConditionVariable.new
      @workers = []
      @keep_alive = keep_alive
    end

    def schedule(*args, &blk)
      return if blk.nil?
      @stop_mutex.synchronize do
        if @stopped
          GRPC.logger.warn('did not schedule job, already stopped')
          return
        end
        GRPC.logger.info('schedule another job')
        @jobs << [blk, args]
      end
    end

    def start
      @stop_mutex.synchronize do
        fail 'already stopped' if @stopped
      end
      until @workers.size == @size.to_i
        next_thread = Thread.new do
          catch(:exit) do  # allows { throw :exit } to kill a thread
            loop_execute_jobs
          end
          remove_current_thread
        end
        @workers << next_thread
      end
    end

    def stop
      GRPC.logger.info('stopping, will wait for all the workers to exit')
      @stop_mutex.synchronize do  # wait @keep_alive seconds for workers to stop
        @stopped = true
        @workers.size.times { @jobs << [proc { throw :exit }, []] }
        @stop_cond.wait(@stop_mutex, @keep_alive) if @workers.size > 0
      end
      forcibly_stop_workers
      GRPC.logger.info('stopped, all workers are shutdown')
    end

    protected

    def loop_execute_jobs
      loop do
        begin
          blk, args = @jobs.pop
          blk.call(*args)
        rescue StandardError, GRPC::Core::CallError => e
          GRPC.logger.warn('Error in worker thread')
          GRPC.logger.warn(e)
        end
      end
    end
  end

  class RpcServer
    def available?(an_rpc)
      jobs_count, max = @pool.jobs_waiting, @max_waiting_requests
      GRPC.logger.info("waiting: #{jobs_count}, max: #{max}")
      return an_rpc if @pool.jobs_waiting <= @max_waiting_requests
      GRPC.logger.warn("NOT AVAILABLE: too many jobs_waiting: #{an_rpc}")
      noop = proc { |x| x }

      # Create a new active call that knows that metadata hasn't been
      # sent yet
      c = ActiveCall.new(an_rpc.call, noop, noop, an_rpc.deadline,
                         metadata_received: true, started: false)
      c.send_status(GRPC::Core::StatusCodes::RESOURCE_EXHAUSTED,
                    'No free threads in thread pool')
      nil
    end
  end
end
