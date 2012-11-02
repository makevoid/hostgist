require 'bundler'
Bundler.require :default
require 'open-uri'

GISTS_HOST = "https://raw.github.com/gist"


BaseClass =  defined?(Goliath) ? Goliath::API : Sinatra::Base

class HostGist < BaseClass

  CACHE = {}

  def download(gist_id, file)
    key = "#{gist_id}/#{file}"
    file = CACHE[key]
    unless file
      file = open("#{GISTS_HOST}/#{key}").read
      CACHE[key] = file
    end
    file
  end

  def cache_clear
    CACHE.delete_if { true }
    "Cache cleared!"
  end

  if defined?(Goliath)

    def response(env)
      path = env['PATH_INFO']
      content = if path == "/cache/clear"
        cache_clear
      else
        _, gist_id, file = path.split("/")
        download gist_id, file
      end

      [200, {}, content]
    end

  else # Sinatra

    get "/cache/clear" do
      cache_clear
    end

    get "/*/*" do |gist_id, file|
      download gist_id, file
    end

  end

end