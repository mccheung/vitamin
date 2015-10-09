# coding: utf-8
require 'open-uri'

class BlogWorker
  include Sidekiq::Worker
  sidekiq_options queue: :blog, retry: true

  def perform(uri)
    logger.debug ["Fetching article from: #{uri}"]

    (title, content, post_date) = fetch_article(uri)
    file_name = "#{post_date}-article.html"
    File.open("#{Figaro.env.blog_posts_dir}/#{file_name}", "w") { |file|
      file.write("---\n")
      file.write("layout: post\n")
      file.write("title: #{title}\n")
      file.write("---\n")
      file.write(content)
    }
  end

  private
  def fetch_article(uri)
    article = Nokogiri::HTML(open(uri))
    post_user = article.css('#post-user').text
    raise "invalid post-user" unless post_user.eql?('2014秋天马宝宝')

    post_date = article.css('#post-date').text
    title = article.css('title').text
    content = article.css('#js_content').children
    process_images(content)
    return title, content, post_date
  end

  def process_images(content)
    images = content.css('img[data-src]')
    return content if images.empty?

    for image in images
      image['src'] = image['data-src']
    end

    images
      .remove_attr('data-src')
      .remove_attr('data-ratio')
      .remove_attr('data-w')
      .remove_attr('data-s')
      .remove_attr('data-type')
  end
end
