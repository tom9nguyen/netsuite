require 'spec_helper'

describe NetSuite::Records::RecordRef do
  let(:record_ref) { NetSuite::Records::RecordRef.new }

  describe 'internal_id' do
    context 'when passing in as plain attribute to initialize' do
      it 'correctly sets the internal_id' do
        record_ref = NetSuite::Records::RecordRef.new(:internal_id => '1')
        record_ref.internal_id.should eql('1')
      end
    end

    context 'when passing in as swirly attributes to initialize' do
      it 'correctly sets the internal_id' do
        record_ref = NetSuite::Records::RecordRef.new(:@internal_id => '2')
        record_ref.internal_id.should eql('2')
      end
    end

    context 'when not passed in as an attribute to initialize' do
      it 'does not set an internal_id' do
        record_ref = NetSuite::Records::RecordRef.new
        record_ref.internal_id.should be_nil
      end
    end

    it 'has no public internal_id setter' do
      record_ref.should_not respond_to(:internal_id=)
    end
  end

  describe 'attributes' do
    let(:record_ref) do
      NetSuite::Records::RecordRef.new(
        :name   => 'This is a record_ref',
        :banana => 'for monkeys'
      )
    end

    context 'readers' do
      it 'can take on arbitrary attributes into itself on initialization' do
        record_ref.name.should eql('This is a record_ref')
        record_ref.banana.should eql('for monkeys')
      end
    end
  end

  describe 'untouchables' do
    let(:record_ref) do
      NetSuite::Records::RecordRef.new(
        :"@xmlns:platform_core" => 'something'
      )
    end

    it 'ignores untouchable attributes' do
      record_ref.instance_variable_get('@attributes').keys.should_not include(:"@xmlns:platform_core")
    end
  end

  describe 'initialize from record' do
    it 'initializes a new ref with the proper attributes from the record' do
      record = NetSuite::Records::Classification.new(:is_inactive => false, :name => 'Retail', :internal_id => '9')
      record_ref = NetSuite::Records::RecordRef.new(record)
      record_ref.should be_kind_of(NetSuite::Records::RecordRef)
      record_ref.internal_id.should eql('9')
      record_ref.type.should eql('classification')
    end
  end

  describe '#to_record' do
    it 'can represent itself as a SOAP record' do
      record_ref = NetSuite::Records::RecordRef.new(:something => 'blah')
      record = {
        'platformCore:something' => 'blah'
      }
      record_ref.to_record.should eql(record)
    end
  end

  describe '#record_type' do
    it 'returns a string of the SOAP type' do
      record_ref.record_type.should eql('platformCore:RecordRef')
    end
  end

end
