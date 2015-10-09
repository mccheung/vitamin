# coding: utf-8
require 'open-uri'
require 'securerandom'

class BlogWorker
  include Sidekiq::Worker
  sidekiq_options queue: :blog, retry: false

  def perform(uri)
    logger.debug ["Fetching article from: #{uri}"]

    article = Nokogiri::HTML(open(uri))
    post_user = article.css('#post-user').text
    post_date = article.css('#post-date').text

    valid_post_user = Figaro.env.valid_post_user
    unless post_user.eql?(valid_post_user)
      logger.error ["required #{valid_post_user}, but received #{post_user}"]
      return
    end

    (title, content) = fetch_article(article)
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
  def fetch_article(article)
    title = article.css('title').text
    content = article.css('#js_content').children
    process_images(content)
    return title, content
  end

  def process_images(content)
    images = content.css('img[data-src]')
    return content if images.empty?

    for image in images
      result = upload_image_to_qiniu(image['data-src'])
      image['src'] = "#{Figaro.env.qiniu_domain}/#{result['key']}"
    end

    images
      .remove_attr('data-src')
      .remove_attr('data-ratio')
      .remove_attr('data-w')
      .remove_attr('data-s')
      .remove_attr('data-type')
  end

  def upload_image_to_qiniu(image_uri, tries = 2)
    QiniuHelper.fetch(image_uri, Figaro.env.qiniu_bucket, SecureRandom.uuid)
  rescue
    retry unless (tries -= 1).zero?
  end
end
