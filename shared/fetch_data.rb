# frozen_string_literal: true

class FetchData
  def self.call
    sleep(0.1)
    1_000_000.times.reduce(0) do |i, total|
      total + i
    end
  end
end
