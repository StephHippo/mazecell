class Fixnum
  #calculates the max value of Fixnum on a machine
  #Max size found from .size * byte value
  #Subtract a bit for marking an integer
  #Subtract a bit for the sign
  #Subtract 1 for border of Fixnum and Bignum.

  def self.max_value
    (2**(0.size * 8 - 2) - 1)
  end
end