module Jekyll
  class MtimeTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @item = text.strip
    end

    def render(context)
      return '' unless ['page', 'post'].member?(@item)

      item = context.scopes.first[@item]
      file = File.join(item.site.source, item.name)

      File.mtime(file).xmlschema if File.exists?(file)
    end
  end
end

Liquid::Template.register_tag('mtime', Jekyll::MtimeTag)
