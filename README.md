# HostGist

### Host Gists easily

What I miss from Gists is HTML rendering like Github Pages, but it's easy to do it! Only few lines of ruby code and tadaaan... HostGist is born!


### Usage:

http://hostgist.makevoid.com/GIST_ID/FILE_NAME.html

easy as that!


Example:

http://hostgist.makevoid.com/3999915/gchart_offline.html


Note: results are cached for speed, so you may want to clear the cache with:

http://hostgist.makevoid.com/cache/GIST_ID/clear

Enjoy!


### Dev notes:

To use Goliath server, you need to uncomment it in the Gemfile, and you can run it with:

  ruby hostgist.rb