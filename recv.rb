# 

num       = (ENV['NUM'] or raise "ENV[NUM] not found").to_i
queue_url = ENV['QUEUE_URL']

require 'aws-sdk-sqs'

sqs = Aws::SQS::Client.new(region: ENV['AWS_DEFAULT_REGION'])

receive_message_result = sqs.receive_message({
                                               queue_url: queue_url,
                                               message_attribute_names: ["All"], # Receive all custom attributes.
                                               max_number_of_messages: num, # Receive at most one message.
                                               wait_time_seconds: 0 # Do not wait to check for the message.
                                             })

receive_message_result.messages.each_with_index do |message, i|
  #   resp.messages #=> Array
  #   resp.messages[0].message_id #=> String
  #   resp.messages[0].receipt_handle #=> String
  #   resp.messages[0].md5_of_body #=> String
  #   resp.messages[0].body #=> String
  #   resp.messages[0].attributes #=> Hash
  #   resp.messages[0].attributes["MessageSystemAttributeName"] #=> String
  #   resp.messages[0].md5_of_message_attributes #=> String
  #   resp.messages[0].message_attributes #=> Hash

  puts "  Message #{i+1}"
  puts "  ------------"

  puts "  message_id: %s" % message.message_id
  puts "  body: %s" % message.body
  # puts "  receipt_handle: %s" % message.receipt_handle
  puts "  (executing delete_message...)"
  res = sqs.delete_message({
                             queue_url: queue_url,
                             receipt_handle: message.receipt_handle
                           })
  puts
end
