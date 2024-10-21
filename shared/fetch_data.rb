# frozen_string_literal: true

class FetchData
  def self.call
    1_000_000.times.reduce(0) do |i, total|
      total + i
    end
  end
end
