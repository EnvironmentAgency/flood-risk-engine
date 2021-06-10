# rubocop:disable all

RSpec.configure do |_config|
  # USAGE :
  #
  #   let(:valid_update_attributes) {
  #     {
  #         first_name: 'updated_first_name',
  #         last_name: 'updated_last_name'
  #     }
  #   }
  #
  #   let(:expected_update_attributes) {
  #       valid_update_attributes.merge(age: 25, need_admin_validation: true)
  #   }

  #   Then run create/edit/update tests on record using valid_update_attributes
  #
  #    assert_record_values record, expected_update_attributes
  #
  def assert_records_values(records, values)
    message = <<-EOS
Expected <#{values.count}> number of records, got <#{records.count}>

Records:
#{records.to_a}"
EOS
    expect(records.length).to eq(values.count), message

    records.each_with_index do |record, index|
      assert_record_values record, values[index], index: index
    end
  end

  def assert_record_values(record, values, index: nil)
    values.each do |field, expected|
      # TODO : work out how to process nested attributes
      next if field.is_a?(Symbol) && expected.is_a?(Hash)

      record_value = [field].flatten.inject(record) do |object, method|
        object.send(method) if object.respond_to?(method)
      end

      if (record_value.is_a?(BigDecimal) && expected.is_a?(String)) ||
         (record_value.is_a?(Date) && expected.is_a?(String))

        record_value = record_value.to_s

      elsif expected.is_a?(Integer) && record_value.is_a?(String)
        # could be an enum index => being converted to its string form
        # .. so check if it responds to enum methods
        next if record.class.respond_to?(field.pluralize) && record.respond_to?("#{record_value}?")
      end

      msg = "#{"(index #{index}) " if index}<#{field}> value expected <#{expected.inspect}>. Got <#{record_value}>"

      expect_string_or_regexp record_value, expected, msg

    end
  end

  def expect_string_or_regexp(value, expected, message = nil)

    if expected.is_a?(String) || expected.nil?
      expect(value).to eq(expected), message
    else
      expect(value).to match(expected), message
    end
  end
end

# rubocop:enable all
