# frozen_string_literal: true

class Governator
  # Data structure for a governor's parsed name
  Name = Struct.new(:full_name, :first_name, :middle_name, :nickname, :last_name, :suffix) do
    def to_s
      full_name
    end
  end
end
