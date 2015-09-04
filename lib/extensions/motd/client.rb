require 'bunny'
require 'thread'

$connection = Bunny.new(automatically_recover: true)
$connection.start
$channel = $connection.create_channel

module Motd
  class Client
    attr_accessor :reply_queue
    attr_accessor :response, :call_id
    attr_accessor :lock, :condition

    def default_exchange
      $channel.default_exchange
    end

    def initialize
      @server_queue = 'motd.rpc'
      self.reply_queue = $channel.queue('', exclusive: true)

      self.lock = Mutex.new
      self.condition = ConditionVariable.new
      @that = self

      self.reply_queue.subscribe(timeout: 5) do |delivery_info, properties, payload|
        if properties[:correlation_id] == @that.call_id
          @that.response = JSON.parse payload
          @that.lock.synchronize { @that.condition.signal }
        end
      end
    end

    def motd
      begin
        return nil unless $connection.queue_exists?('motd.rpc')
        self.call_id = self.generate_uuid

        default_exchange.publish('{}',
                                 routing_key: @server_queue,
                                 correlation_id: call_id,
                                 reply_to: self.reply_queue.name)

        self.lock.synchronize { condition.wait(lock) }
        response['message']
      rescue
        nil
      end
    end

    protected

    def generate_uuid
      "#{rand}#{rand}#{rand}"
    end
  end
end