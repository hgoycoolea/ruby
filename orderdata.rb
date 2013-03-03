require 'base64'
require 'stringio'
require 'zlib'

myStr = StringIO.new()
gz = Zlib::GzipWriter.new(myStr)
gz.write '<p><b>Order Data</b></p><p>A brief description of the product</p>'
gz.close

# in ruby 2.1 you can simply do
# orderData = Base64.encode64s(myStr.string())
orderData = Base64.encode64(myStr.string()).gsub("\n","")

puts orderData
