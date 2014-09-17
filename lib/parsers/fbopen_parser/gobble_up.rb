class FbopenParser::GobbleUp < Parslet::Atoms::Base
  def initialize(absent, min_chars = 0)
    @absent = absent
    @min_chars = min_chars
  end

  def try(source, context, _consume_all)
    excluding_length = source.chars_until(@absent)

    if excluding_length >= @min_chars
      return succ(source.consume(excluding_length))
    else
      return context.err(self, source, "No such string in input: #{@absent.inspect}.")
    end
  end

  def to_s_inner(_prec)
    "until('#{@absent}')"
  end
end
