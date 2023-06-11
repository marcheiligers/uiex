Event = Struct.new(:name, :target, :value) do
  def source
    target
  end

  def value
    target.value
  end

  def to_s
    "#{target} #{name}"
  end
end

module Observable
  def observers
    @observers ||= Hash.new { |h, k| h[k] = [] }
  end

  def attach_observer(observer, callback = :observe, &block)
    observers[observer] << (block || callback)
    self
  end

  def detach_observer(observer)
    observers.delete observer
    self
  end

  def notify_observers(event, private: false)
    observers.each do |observer, callbacks|
      callbacks.each do |callback|
        if callback.is_a?(Proc)
          callback.call(event, observer)
        else
          observer.__send__(callback, event)
        end
      end
    end
    $publisher.publish(event) unless private
    self
  end
end

class Publisher
  include Observable

  def publish(event)
    # putz "Event #{event.name} from #{event.target.inspect}" if $state.debug
    notify_observers(event, private: true)
  end
end

$publisher = Publisher.new
