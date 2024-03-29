require_relative './predicate'

class ValidUfeatured < ::Predicate
  def initialize(has_featured)
    @has_featured = has_featured
  end

  def validate(hentry)
    @has_featured.validate(hentry)

    raise InvalidMetadataError, 'Featured image does not start with https://www.jvt.me/img/ or https://media.jvt.me/' unless /^(https:\/\/www.jvt.me\/img\/|https:\/\/media.jvt.me\/)/.match?(hentry.featured)
  end
end
