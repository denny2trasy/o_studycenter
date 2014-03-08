# encoding: utf-8
class PptFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value && value.content_type =~ /(powerpoint|presentation|flash)$/i
      object.errors[attribute] << (options[:message] || "格式不正确") 
    end
  end
end