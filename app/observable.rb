Event = Struct.new(:name, :target)

module Observable
  def observers
    @observers ||= {}
  end

  def attach_observer(observer, callback = :observe)
    observers[observer] = callback
    self
  end

  def detach_observer(observer)
    observers.delete observer
    self
  end

  def notify_observers(event, private = false)
    observers.each { |observer, callback| observer.__send__(callback, event) }
    $publisher.publish(event) unless private
    self
  end
end

class Publisher
  include Observable

  def publish(event)
    puts "Event #{event.name} from #{event.target.inspect}"
    notify_observers(event, true)
  end
end

$publisher = Publisher.new
