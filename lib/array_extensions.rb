# Grant Goodale's array extensions
# Usage: [1,2,3,4,5,6] / 2 #=> [[1,2],[3,4],[5,6]]
class Array
 def /(len)
       a = []
       each_with_index do |x,i|
         a << [] if i % len == 0
         a.last << x
       end
   a
 end
end
