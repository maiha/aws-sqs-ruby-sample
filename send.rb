# https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/sqs-example-send-messages.html

num       = (ENV['NUM'] or raise "ENV[NUM] not found").to_i
queue_url = ENV['QUEUE_URL']

require 'aws-sdk-sqs'

def build_entry(i)
  group_id     = "worker1"
  message_id   = "#{Time.now.to_i}-#{i}"
  message_body = "Hello! it's #{Time.now.localtime} now. [iterate: #{i}]"

  {
    id: message_id,
    message_body: message_body,
    message_group_id: group_id,
    message_deduplication_id: "#{group_id}-#{message_id}",
  }
end

sqs = Aws::SQS::Client.new(region: ENV['AWS_DEFAULT_REGION'])

entries = (1..num).map{|i| build_entry(i)}
sqs.send_message_batch(queue_url: queue_url, entries: entries)

puts "sent %d messages" % entries.size
puts "  %s" % [entries.map{|hash| hash[:id].to_s}.join(", ")]
