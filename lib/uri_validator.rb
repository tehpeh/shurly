class UriValidator < ActiveModel::EachValidator
  require 'uri'
  
  def validate_each(record, attribute, value)
    valid_scheme = options[:valid_scheme]
    begin
      record.errors[attribute] << "must be a valid URI" unless valid_scheme.include? URI.parse(value).scheme
    rescue
      record.errors[attribute] << "must be a valid URI"
    end
  end
end