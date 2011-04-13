class Shurl < ActiveRecord::Base
  # Strategies for generating a short URL:
  #
  # require 'base58'
  # Base58.encode(rand(38068692544)).rjust(6, "1")  # generate 6 character string
  # Base58.encode(rand(38068692544))                # generate <=6 character string
  # (1..6).map {('a'..'z').to_a[rand(26)]}.join     # generate 6 character string, lowercase letters
  
  # chars = %w{ b c d f g h j k m n p q r s t v w x y z }
  # (1..6).map {chars[rand(chars.count)]}.join      # generate 6 chararcter string, lowercase no dodgy letters
  
  #psuedocode
  #uniqueness on long and short
  #on create:
  #  if long exists, return record
  #  generate short
  #    if short exists, generate short, stop trying at 100th time
  #  return record
  
end