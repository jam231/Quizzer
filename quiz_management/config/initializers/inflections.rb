# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
 ActiveSupport::Inflector.inflections do |inflect|
   inflect.irregular 'pytanie', 'pytanie'
   inflect.irregular 'odpowiedz', 'odpowiedz'
   inflect.irregular 'odpowiedzwzorcowa', 'odpowiedzwzorcowa'
   inflect.irregular 'odpowiedz_wzorcowa', 'odpowiedz_wzorcowa'
   inflect.irregular 'OdpowiedzWzorcowa', 'OdpowiedzWzorcowa'
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
 end
#
# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.acronym 'RESTful'
# end
