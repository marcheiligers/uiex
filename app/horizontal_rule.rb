class HorizontalRule < Window
  def initialize(**args)
    args[:h] ||= 2
    args[:color] ||= Color::DARK_GREY

    super(args)
  end
end
