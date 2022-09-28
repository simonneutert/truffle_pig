class TrufflePig
  attr_reader :queue

  def initialize(workers: 6.0)
    @queue = Queue.new
    @result_queue = Queue.new
    @workers = workers.to_f
  end

  def add_job(&block)
    @queue << -> { block }
  end

  def perform(rescue_errors: nil, reject_errors: false, custom_logger: false)
    until @queue.empty?
      results_from_threads = work_queue(rescue_errors: rescue_errors, custom_logger: custom_logger)
      results_from_threads.each(&:join).map(&:value).each do |res|
        @result_queue << res
      end
    end
    collect_results(reject_errors: reject_errors)
  end

  private

  def collect_results(reject_errors: false)
    results = []
    results << @result_queue.pop until @result_queue.empty?
    results.reject! { |res| res[:error] } if reject_errors == true
    results
  end

  def work_queue(rescue_errors:, custom_logger:)
    running = 0
    current_threads = []
    until @queue.empty? || running == @workers
      current_threads << thread_out(rescue_errors: rescue_errors, custom_logger: custom_logger)
      running += 1
    end
    current_threads
  end

  def thread_out(rescue_errors:, custom_logger:)
    Thread.new do
      t = @queue.pop
      { value: t.call.call }
    rescue StandardError => e
      custom_logger.call(e) if custom_logger
      { value: rescue_errors,
        error: e,
        source: t.call.source.freeze }
    end
  end
end
