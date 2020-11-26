# https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/sqs-example-use-queue.html

queue_url = ENV['QUEUE_URL']

require 'aws-sdk-sqs'

sqs = Aws::SQS::Client.new(region: ENV['AWS_DEFAULT_REGION'])

queue_urls = [queue_url]

######################################################################
### info

puts "--- queue info ------------------------------------------------------------"

queue_urls.each do |url|
  # Get ARN, messages available, and messages in flight for queue
  req = sqs.get_queue_attributes(
    {
      queue_url: url, attribute_names: 
        [
          'QueueArn', 
          'ApproximateNumberOfMessages', 
          'ApproximateNumberOfMessagesNotVisible'
        ]
    }
  )

  puts 'URL:                  ' + url
  puts 'ARN:                  ' + req.attributes['QueueArn']
  puts 'Messages available:   ' + req.attributes['ApproximateNumberOfMessages']
  puts 'Messages not visible: ' + req.attributes['ApproximateNumberOfMessagesNotVisible']
  puts
end

######################################################################
### messages

puts "--- messages ------------------------------------------------------------"

receive_message_result = sqs.receive_message({
                                               queue_url: queue_url,
                                               message_attribute_names: ["All"], # Receive all custom attributes.
                                               max_number_of_messages: 10, # Receive at most one message.
                                               visibility_timeout: 0,
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

  puts "%02d: %s" % [i+1, message.body]
end

puts
