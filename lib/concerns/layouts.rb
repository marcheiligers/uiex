class LayoutBase
  attr_accessor :padding, :spacing
  attr_reader :owner

  def initialize(**args)
    @owner = args.fetch(:owner, nil)
    @padding = args.fetch(:padding, 0)
    @spacing = args.fetch(:spacing, 0)
  end

  def owner=(val)
    raise ArgumentError, "Cannot change owner of #{inspect} to #{val.inspect} after it's been set" unless @owner.nil?
    @owner = val
  end
end

class HorizontalLayout < LayoutBase
  attr_accessor :default_w

  def initialize(**args)
    super(args)

    @default_w = args.fetch(:default_w, 80)
  end

  def add(child)
    child.h = owner.h - 2 * padding if child.h.to_i == 0
    child.w = default_w if child.w.to_i == 0
    child.y = (owner.h - child.h) / 2 if child.y.to_i == 0
    child.x = calc_x if child.x.to_i == 0

    owner.w = child.right if child.right > owner.w
  end

  def calc_x
    (owner.children.inject(0) { |total, child| total + child.w } + spacing * owner.children.length + padding)
  end
end

class VerticalLayout
  def initialize(**args)
    super(args)

    @default_h = args.fetch(:default_h, 40)
  end

  def add(child)
    child.w = owner.w - 2 * padding if child.w.to_i == 0
    child.h = default_h if child.h.to_i == 0
    child.x = (owner.w - child.w) / 2 if child.x.to_i == 0
    child.y = calc_y - child.h if child.y.to_i == 0
  end

  def calc_y
    owner.h - (owner.children.inject(0) { |total, child| total + child.h } + spacing * owner.children.length + padding)
  end
end
