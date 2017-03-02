require 'elasticsearch/persistence/model'
require 'securerandom'

class User
  include Elasticsearch::Persistence::Model

  # -- STUFF THAT DIRECTLY SUPPORTS ES + DEVISE -------------------------------
  #
  # Ideally, all code in this section should be included into this class by
  # lib/devise/orm/elasticsearch.rb. If for example we wanted to break support
  # for ES::P::M with Devise out into a gem for generic use, we'd have to do
  # this.
  #
  # But just to support the features and scope we need in webservices, having
  # this code here in the User class works.

  extend ActiveModel::Callbacks

  self::OrmAdapter = ::OrmAdapter::Elasticsearch

  # These are for the after hooks that send confirmation emails etc.
  define_model_callbacks :create, :update, :validation

  # Devise uses this to set values onto the instance during registration
  # editing, in the case that the given password was invalid.
  def assign_attributes(hash)
    hash.each { |k, v| send("#{k}=", v) }
  end

  # This may be a workaround to a bug in ES::P::M. If we pass undeclared
  # attributes, they get saved to the ES doc. Left untouched, we were saving
  # clear text passwords. (The logic of a Devise-managed model is to have
  # password and password_confirmed attrs on the model, but only save
  # encrypted_password. ES::P::M#update_attributes circumvents the model attr
  # structure and just updates the underlying ES doc with whatever hash it is
  # given! Seems like undesired behavior to me.)
  #
  # Before we call the super, we sort out any password attrs that have been
  # given.
  def update_attributes(attributes = {}, options = {})
    %i(password password_confirmation).select do |attr|
      attributes[attr].present?
    end.each do |attr|
      send("#{attr}=", attributes[attr])
      attributes.delete(attr)
    end
    attributes[:encrypted_password] = encrypted_password

    return false unless valid?

    super(attributes, options)
  end

  def update_attribute(name, value)
    update_attributes(name => value)
  end

  def valid?
    run_callbacks :validation do
      super
    end
  end

  # We define a save method so that we can fire off update or create callbacks.
  # This causes Devise to send out related emails etc.
  def save(options = {})
    callbacks = persisted? ? :update : :create

    run_callbacks callbacks do
      # Devise can throw a :validate key at us, which ES doesn't like.
      options.delete(:validate)

      result = super(options)

      # Prevent Devise after_* callbacks from sending out confirmation emails
      # when save failed. I'm not happy with the hackiness of this, but I can't
      # find a better way.
      @skip_confirmation_notification = true unless result

      result
    end
  end

  # To make sure new/edited users can be seen in ES right away.
  after_save { self.class.gateway.refresh_index! }

  # Devise needs this. With ActiveRecord or Mongoid, generic "Dirty"
  # functionality would be included in the class, which provides this (and some
  # other supporting methods). I attempted adding ActiveModel::Dirty, but
  # ran into some tricky errors that I didn't have time to get to the bottom
  # of. With infinite time we'd ideally have ActiveModel::Dirty do this.
  #
  # Note that this hits the DB in order to find the return value.
  def email_changed?
    persisted? ? (email_was != email) : false
  end

  def email_was
    persisted? ? self.class.to_adapter.get(id).email : nil
  end

  # -- END OF STUFF THAT DIRECTLY SUPPORTS ES + DEVISE ------------------------

  # TODO: can I reuse code from Indexable?
  index_name [ES::INDEX_PREFIX, name.indexize].join(':')

  devise :registerable, :database_authenticatable, :recoverable, :confirmable, :lockable

  attribute :email, String, mapping: { type: 'keyword' }
  attribute :encrypted_password, String
  attribute :api_key, String, mapping: { type: 'keyword' },
                              default: proc { generate_api_key }
  attribute :full_name, String
  attribute :company, String

  attribute :reset_password_token, String
  attribute :reset_password_sent_at, DateTime

  attribute :unconfirmed_email, String
  attribute :confirmation_token, String
  attribute :confirmed_at, DateTime
  attribute :confirmation_sent_at, DateTime
  attribute :locked_at, DateTime

  attribute :failed_attempts, Integer, default: 0, mapping: { type: 'integer' }
  attribute :unlock_token, String

  attribute :admin, Boolean, default: false
  attribute :approved_buckets, Object, default: []

  validates_presence_of :email
  validates_presence_of :password, if: proc { !persisted? }
  validates_presence_of :password_confirmation, if: proc { !persisted? }

  validate :passwords_must_match_and_be_strong
  validate :email_must_be_unique

  def self.generate_api_key
    SecureRandom.urlsafe_base64(24)[0..23]
  end

  private

  def passwords_must_match_and_be_strong
    if password != password_confirmation
      errors.add(:password, "Password and Password Confirmation don't match")
    elsif password && (password.length < 8 || password !~ /\d/)
      errors.add(:password, 'must contain a digit and be at least 8 characters long')
    end
  end

  def email_must_be_unique
    return unless email
    match = self.class.search(query: { constant_score: { filter: { term: { email: email } } } }).first
    errors.add(:email, 'has already been taken') if match && match.id != id
  end
end
