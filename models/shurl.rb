class Shurl < ActiveRecord::Base
  # Strategies for generating a short URI:
  #
  # require 'base58'
  # Base58.encode(rand(38068692544)).rjust(6, "1")  # generate 6 character string
  # Base58.encode(rand(38068692544))                # generate <=6 character string
  # (1..6).map {('a'..'z').to_a[rand(26)]}.join     # generate 6 character string, lowercase letters
  #
  # chars = %w{ b c d f g h j k m n p q r s t v w x y z }
  # (1..6).map {chars[rand(chars.count)]}.join      # generate 6 chararcter string, lowercase no dodgy letters

 
  validates :long, 
    :presence => true, 
    :uniqueness => true, 
    :uri => { :valid_scheme => ['http', 'https'] }
  validates :short, 
    :presence => true, 
    :uniqueness => true
  
  before_validation :set_short, :if => :short_blank?
  
  def self.create(params)
    Shurl.find_by_long(params[:long]) || super(params)
  end
  
  def self.create!(params)
    Shurl.find_by_long(params[:long]) || super(params)
  end
  
  def self.visit(short)
    shurl = Shurl.find_by_short(short)
    unless shurl.nil?
      shurl.request_count += 1
      shurl.last_request_at = Time.now
      shurl.save
    end
    shurl
  end
  
  protected
  
  def short_blank?
    self.short.blank?
  end
  
  def set_short  # raises RuntimeError
    short = generate_short
    i = 0
    while Shurl.exists?(:short => short)
      log "Collision with #{short}"
      short = generate_short
      i += 1
      raise 'could not generate a unique short URI' if i >= 100
    end
    self.short = short
  end
  
  def generate_short
    chars = %w{ b c d f g h j k m n p q r s t v w x y z }
    (1..6).map {chars[rand(chars.count)]}.join
  end
end