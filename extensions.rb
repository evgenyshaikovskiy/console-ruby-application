# extension method to define whether string is number or not
# works for decimal, binary and hex and other non 10 base integers
class String
  def i?
    /\A[-+]?\d+\z/ === self
  end
end
