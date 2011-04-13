module Jekyll

  class Archives
    def self.from_site(site)
      archives = {}

      posts = if site.is_a?(Hash)
        site['posts']
      else
        site.posts
      end

      posts.each do |post|
        date = {
          :year  => post.date.year,
          :month => post.date.month.to_s.rjust(2, '0')
        }

        archives[date] ||= []
        archives[date] << post
      end

      archives
    end
  end

  class Archiver < Generator
    safe true

    def generate(site)
      archives = Archives.from_site(site)

      archives.each do |archive, posts|
        site.pages << ArchivePage.new(
          site,
          site.source,
          "/#{archive[:year]}/#{archive[:month]}",
          "index.html",
          {
            'layout'  => 'list',
            'posts'   => posts.sort.reverse,
            'archive' => archive,
            'title'   => "Posts from #{archive[:month]}/#{archive[:year]}"
          }
        )
      end
    end

  end

  class ArchivePage < Page
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
    def archive_link(archive, count=nil)
      y, m = archive[:year], archive[:month]
      %Q{<a href="/#{y}/#{m}">#{m}-#{y}</a>}
    end

    def archive_list(site)
      archives = Archives.from_site(site)

      el =  %Q{<ul class="archive_list">}

      archives.each do |archive, posts|
        el << %Q{<li>#{archive_link(archive, posts.size)}</li>\n}
      end

      el << %Q{</ul>}
    end
  end

end
