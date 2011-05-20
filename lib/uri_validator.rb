class UriValidator < ActiveModel::EachValidator
  require 'uri'

  def validate_each(record, attribute, value)
    valid_scheme = options[:valid_scheme]
    begin
      record.errors[attribute] << "must be a valid URI" unless URI.parse(value).scheme.member_of? options[:valid_scheme]
    rescue
      record.errors[attribute] << "must be a valid URI"
    end
  end
end