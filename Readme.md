# Truffle Pig

> I'm a little piggy, here's my snout!

## Metaphor

A (truffle-ruby) swine munching data, turning it into something useful to feed its many piglets.

## Example

```ruby
# frozen_string_literal: true

require 'pry'
require 'prettyprint'
require 'etc'

require_relative 'lib/truffle_pig'

cpu_processors = Etc.nprocessors
p cpu_processors #=> Number of (virtual) CPU Processors

piggy = TrufflePig.new(workers: cpu_processors)

piggy.add_job do
  1 / 0
end

(1..24).each do |i|
  piggy.add_job do
    sleep 1

    result = 0
    10_000.times do
      result = i**i
    end
    puts "job_id ##{i}, result: #{result}"
    { job_id: i, result: result }
  end
end

puts "#{piggy.queue.size} jobs added"

results = piggy.perform(reject_errors: true, custom_logger: ->(e) { pp e })
puts "\n\n\n\n"
puts 'The results are in:'
puts "\n\n\n\n"

pp results
```

Running this little example yields:

```ruby
# output of collected results

[{:value=>nil,
  :error=>#<ZeroDivisionError: divided by 0>,
  :source=>"piggy.add_job do\n" + "  1 / 0\n" + "end\n"},
 {:value=>{:job_id=>1, :result=>1}},
 {:value=>{:job_id=>2, :result=>4}},
 {:value=>{:job_id=>3, :result=>27}},
 {:value=>{:job_id=>4, :result=>256}},
 {:value=>{:job_id=>5, :result=>3125}},
 {:value=>{:job_id=>6, :result=>46656}},
 {:value=>{:job_id=>7, :result=>823543}},
 {:value=>{:job_id=>8, :result=>16777216}},
 {:value=>{:job_id=>9, :result=>387420489}},
 {:value=>{:job_id=>10, :result=>10000000000}},
 {:value=>{:job_id=>11, :result=>285311670611}},
 {:value=>{:job_id=>12, :result=>8916100448256}},
 {:value=>{:job_id=>13, :result=>302875106592253}},
 {:value=>{:job_id=>14, :result=>11112006825558016}},
 {:value=>{:job_id=>15, :result=>437893890380859375}},
 {:value=>{:job_id=>16, :result=>18446744073709551616}},
 {:value=>{:job_id=>17, :result=>827240261886336764177}},
 {:value=>{:job_id=>18, :result=>39346408075296537575424}},
 {:value=>{:job_id=>19, :result=>1978419655660313589123979}},
 {:value=>{:job_id=>20, :result=>104857600000000000000000000}},
 {:value=>{:job_id=>21, :result=>5842587018385982521381124421}},
 {:value=>{:job_id=>22, :result=>341427877364219557396646723584}},
 {:value=>{:job_id=>23, :result=>20880467999847912034355032910567}},
 {:value=>{:job_id=>24, :result=>1333735776850284124449081472843776}}]
```
