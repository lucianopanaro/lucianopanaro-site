module Jekyll

  class Tagger < Generator
    safe true

    def generate(site)
      site.tags.each do |tag, posts|
        site.pages << TagPage.new(
          site,
          site.source,
          '/tags',
          "#{tag}.html",
          {
            'layout' => 'list',
            'posts'  => posts.sort.reverse,
            'tag'    => tag,
            'title'  => "Posts with tag #{tag}"
          }
        )
      end
    end
  end

  class TagPage < Page
    def initialize(site, base, dir, name, data = {})
      self.content = data.delete('content') || ''
      self.data    = data

      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing
    end
  end

  module Filters
    def tag_link(tag)
      %Q{<a href="/tags/#{tag}.html">#{tag}</a>}
    end

    def tags_list(tags)
      tags.map { |t| tag_link(t) }.join(', ')
    end

    def tag_cloud(site)
      el =  %Q{<ul class="tag_cloud">}

      site["tags"].each do |tag, posts|
        size = 1.0 + (0.05 * posts.size)
        el << %Q{<li style="font-size:#{size}em">#{tag_link(tag)}</li>\n}
      end

      el << %Q{</ul>}
    end
  end

end
