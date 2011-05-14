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

      if File.exists?(file)
        File.mtime(file).xmlschema
      else
        Time.now.xmlschema
      end
    end
  end
end

Liquid::Template.register_tag('mtime', Jekyll::MtimeTag)
