require 'instapush'
$instapush = Instapush::Application.new Figaro.env.instapush_app_id, Figaro.env.instapush_secret
