# coding: utf-8
require 'open-uri'
require 'securerandom'

class BlogWorker
  include Sidekiq::Worker
  sidekiq_options queue: :blog, retry: false

  def perform(uri)
    logger.debug ["Fetching article from: #{uri}"]

    article = Nokogiri::HTML(open(uri))
    article.encoding = 'utf-8'

    post_user = article.css('#post-user').text
    author = article.css('.rich_media_meta.rich_media_meta_text')[1].text

    valid_post_user = "2014秋天马宝宝"
    unless post_user.eql?(valid_post_user)
      logger.error ["required #{valid_post_user}, but received #{post_user}"]
      return
    end

    title = article.css('title').text
    post_date = article.css('#post-date').text
    content = article.css('#js_content').children
    process_images(content, post_date)
    process_qq_videos(content)

    file_name = "#{post_date}-article.html"
    File.open("#{Figaro.env.blog_posts_dir}/#{file_name}", "w") { |file|
      file.write("---\n")
      file.write("layout: post\n")
      file.write("title: '#{title}'\n")
      file.write("author: '#{author}'\n")
      file.write("---\n")
      file.write(content)
    }
  end

  def process_images(content, date)
    images = content.css('img[data-src]')
    return content if images.empty?

    images.each_with_index { |image, index|
      qiniu_file_key = "articles/#{date}/img/#{index}"
      result = upload_image_to_qiniu(image['data-src'], qiniu_file_key)
      image['src'] = "#{Figaro.env.qiniu_domain}/#{result['key']}"
    }

    images
      .remove_attr('data-src')
      .remove_attr('data-ratio')
      .remove_attr('data-w')
      .remove_attr('data-s')
      .remove_attr('data-type')
  end

  def upload_image_to_qiniu(image_uri, qiniu_file_key, tries=2)
    QiniuHelper.fetch(image_uri, Figaro.env.qiniu_bucket, qiniu_file_key)
  rescue
    retry unless (tries -= 1).zero?
  end

  def process_qq_videos(content)
    videos = content.css('iframe[data-src]')
    return content if videos.empty?

    for video in videos
      video['src'] = video['data-src']
    end
  end
end
