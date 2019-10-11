# frozen_string_literal: true

def wait_for_ajax time_to_wait = 0.1
  print ':'
  counter = 0
  while page.evaluate_script("typeof($) === 'undefined'")
    counter += 1
    print ':'
    $stdout.flush
    sleep time_to_wait
    raise 'Jquery not initialized after 10 seconds.' if counter >= 100
  end

  counter = 0
  while page.evaluate_script('$.active > 0')
    counter += 1
    print ':'
    $stdout.flush
    sleep time_to_wait
    next unless counter >= 100

    msg = 'AJAX request took longer than 10 seconds.'
    if page.driver.respond_to?(:console_messages)
      msg << '  console messages at time of failure: ' + page.driver.console_messages.inspect
    end
    raise msg
  end
end
