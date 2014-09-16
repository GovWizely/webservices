require 'pp'
require 'parslet'
require 'parslet/accelerator'

class FbopenParser < Parslet::Parser
  root :doc

  rule(:doc) do
    record.repeat(0).as(:records)
  end

  rule(:record) do
    (open_tag >> datum.repeat.as(:attrs) >> close_tag)
  end

  rule(:open_tag) do
    str('<') >> valid_tag.as(:ntype) >> str('>') >> space?
  end
  rule(:close_tag) do
    str('</') >> valid_tag >> str('>') >> space?
  end
  rule(:valid_tag) do
    match(%q([0-9a-zA-Z \"'=-])).repeat(1)
  end

  rule(:datum) do
    link  |
    email |
    datum_name >> datum_value.as(:value)
  end

  rule(:link) do
    str('<') >> str('LINK').as(:name) >> str('>') >> newline >>
      str('<URL>') >> datum_value.as(:value) >>
        str('<DESC>') >> datum_value.as(:desc)
  end

  rule(:email) do
    str('<') >> str('EMAIL').as(:name) >> str('>') >> newline >>
      str('<EMAIL>') >> datum_value.as(:value) >>
        str('<DESC>') >> datum_value.as(:desc)
  end

  rule(:datum_name) do
    str('<') >> valid_attr.as(:name) >> str('>')
  end

  rule(:datum_value) do
    (
      (str('<').absent? >> any).repeat(1) | str('</EMAIL>') | str('<BR>') | str('</A>') | str('<P>') | new_tag.absent? >> any
    ).repeat
  end

  rule(:valid_attr) do
    match('[a-zA-Z]').repeat
  end

  rule(:new_tag) do
    str('<') >> str('/').maybe >> match('[A-Z]').repeat(1) >> str('>')
  end

  rule(:space)  { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:newline)  { match('[\r\n]').repeat(1) }
  rule(:newline?) { newline.maybe }

  def transform(tree)
    RecTransform.new.apply(tree)
  end

  def optimized
    acc = Parslet::Accelerator
    optimized = acc.apply(self,
                          acc.rule((acc.str(:x).absent? >> acc.any).repeat(1)) { GobbleUp.new(x, 1) },
    )
  end

  def convert(input)
    if input.respond_to?(:readline)
      dofh(input)
    else
      transform optimized.parse(input)
    end
  end

  def dofh(fh)
    o = optimized

    all_recs = []
    buffer = ''
    while !fh.eof? && line = fh.readline
      buffer += line
      next if !fh.eof? and not line =~ /^<\/[A-Z]/
      buffer.lstrip!

      begin
        rec_tree = o.parse(buffer)
        record = transform rec_tree
        record.each { |r| all_recs << r }
        buffer.clear
      rescue => e
        Rails.logger.error(e)
      end
    end
    all_recs
  end
end
