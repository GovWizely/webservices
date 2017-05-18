require 'spec_helper'

describe S3BrowserConstraint do
  before do
    class RequestDummy
    end

    @user = create_user
  end

  describe '#matches?' do
    before do
      allow_any_instance_of(RequestDummy).to receive(:fullpath).and_return('/s3_browser/buckets/not_a_real_bucket')
      allow_any_instance_of(RequestDummy).to receive_message_chain(:env, :[], :user).and_return(@user)
    end

    context 'when a bucket is authorized for a user' do
      it 'returns true' do
        @user.update_attributes(approved_buckets: ['not_a_real_bucket'])
        expect(described_class.new.matches?(RequestDummy.new)).to eq(true)
      end
    end

    context 'when a bucket is not authorized for a user' do
      it 'returns false' do
        @user.update_attributes(approved_buckets: [])
        expect(described_class.new.matches?(RequestDummy.new)).to eq(false)
      end
    end

    context 'when path includes upload or delete' do
      it 'returns true' do
        @user.update_attributes(approved_buckets: ['not_a_real_bucket'])
        allow_any_instance_of(RequestDummy).to receive(:fullpath).and_return('/s3_browser/buckets/upload/not_a_real_bucket')
        expect(described_class.new.matches?(RequestDummy.new)).to eq(true)
        allow_any_instance_of(RequestDummy).to receive(:fullpath).and_return('/s3_browser/buckets/delete/not_a_real_bucket')
        expect(described_class.new.matches?(RequestDummy.new)).to eq(true)
      end
    end
  end
end
