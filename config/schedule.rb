# frozen_string_literal: true

every 1.day do
  runner 'DailyDigestJob.perform_now'
end

every 30.minutes do
  rake 'ts:index'
end
