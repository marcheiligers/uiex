class RadioGroup < Menu
  def observe(event)
    super(event)

    case event.name
    when :pressed
      deselect_children(except: event.target)
      event.target.set(true)
      notify_observers(Event.new(:selected, event.target))
      putz "#{event.target} selected"
    end
  end

  def deselect_children(except: nil)
    @children.each { |child| child.set(false) unless child == except }
  end

end
