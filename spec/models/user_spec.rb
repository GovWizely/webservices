require 'spec_helper'

describe User do
  describe 'validations' do
    it do
      is_expected.to validate_presence_of(:email)
      is_expected.to validate_presence_of(:password)
      is_expected.to validate_presence_of(:password_confirmation)
      is_expected.to validate_presence_of(:full_name)
      is_expected.to validate_presence_of(:company)
    end

    context 'on email' do
      context 'when user persisted' do
        subject { create_user }
        it { is_expected.to be_valid }
      end

      context 'when already exists on a different user record' do
        let(:email) { 'john@example.com' }
        before { create_user(email: email) }
        subject { build_user(email: email) }

        it 'is not valid' do
          expect(subject).not_to be_valid
          expect(subject.errors.count).to eq(1)
          expect(subject.errors.messages).to eq(email: ['has already been taken'])
        end
      end

      context 'when similar to existing' do
        let(:email) { 'sue@example.com' }
        before { create_user(email: email) }
        subject { build_user(email: 'sue@sue.com') }
        it { is_expected.to be_valid }
      end
    end

    context 'on password' do

      context 'when user not persisted' do
        context 'and given password is blank' do
          subject { create_user(password: nil, password_confirmation: nil) }
          it { is_expected.not_to be_valid }
        end

      end

      context 'when same' do
        subject { build_user(password: 'a', password_confirmation: 'a') }
        it { is_expected.to be_valid }
      end

      context 'when different' do
        subject { build_user(password: 'a', password_confirmation: 'b') }
        it 'is not valid' do
          expect(subject).not_to be_valid
          expect(subject.errors.count).to eq(1)
          expect(subject.errors.messages)
            .to eq(password: ["Password and Password Confirmation don't match"])
        end
      end
    end

  end

  describe '#save' do
    context 'when user is invalid' do
      subject { build_user(company: nil).save }
      it { is_expected.to eq(false) }
    end
  end

  describe '#assign_attributes' do
    subject { build_user }
    it 'works' do
      subject.assign_attributes(full_name: 'Rob', company: "Rob's Corp")
      expect(subject).to be_valid
      expect(subject.full_name).to eq('Rob')
      expect(subject.company).to eq("Rob's Corp")
    end
  end

  describe '#update_attributes' do
    let(:subject) { create_user }
    it 'behaves as expected' do
      subject.update_attributes(full_name: 'John Doe')
      expect(subject.full_name).to eq('John Doe')
      expect(subject).to be_valid
    end

    it 'updates encrypted_password when password given' do
      expect do
        subject.update_attributes(password: 'lalu', password_confirmation: 'lalu')
      end.to change { subject.encrypted_password }
    end
  end

  describe '#email_changed?' do
    subject { build_user }
    it 'behaves as expected' do
      expect(subject.email_changed?).to eq(false)
      subject.save
      expect(subject.email_changed?).to eq(false)
      subject.email = "foo#{subject.email}"
      expect(subject.email_changed?).to eq(true)
      subject.skip_confirmation_notification!
      subject.save
      expect(subject.email_changed?).to eq(false)
    end
  end
end