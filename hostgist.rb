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

  def cache_clear(gist_id)
    CACHE.delete_if { |key| key =~ /^#{gist_id}\// }
    "Cache cleared!"
  end

  if defined?(Goliath)

    def response(env)
      path = env['PATH_INFO']
      content = if path =~ /\/cache\//
        _, _, gist_id = path.split("/")
        cache_clear gist_id
      else
        _, gist_id, file = path.split("/")
        download gist_id, file
      end

      [200, {}, content]
    end

  else # Sinatra

    get "/cache/*/clear" do |gist_id|
      cache_clear gist_id
    end

    get "/*/*" do |gist_id, file|
      download gist_id, file
    end

    if ENV["RACK_ENV"] == "development"
      get "/cache" do
        CACHE.keys.inspect
      end
    end

  end

end