source 'https://rubygems.org'

gemspec

# rubocop:disable all
# This is the jankiest jank in all of janktown. I want a better way to
# manage dependencies for middleware development.
eval(File.read('lib/loginator/middleware/Gemfile.middleware'), binding)
# rubocop:enable all
