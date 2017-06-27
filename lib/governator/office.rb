# frozen_string_literal: true

class Governator
  Office = Struct.new(:address, :city, :state, :zip, :phone, :fax, :office_type) do
    def to_s
      [address, city, state, zip, phone, fax].compact.join("\n")
    end
  end
end
