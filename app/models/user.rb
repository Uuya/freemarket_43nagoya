class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable

  has_many :selling_products, -> { where('buyer_id is NULL') }, foreign_key: 'seller_id', class_name: 'Product'
  has_many :sold_products, -> { where('buyer_id is not NULL') }, foreign_key: 'seller_id', class_name: 'Product'
  has_many :bought_products, foreign_key: 'buyer_id', class_name: 'Product'

  with_options on: :registration_step_1,  presence: true do
    validates :nickname,  length: { maximum: 20 }
  end

  with_options on: :registration_step_2,  presence: true do
    validates :phone_number
  end

  with_options on: :registration_step_3,  presence: true do
    validates :family_name
    validates :first_name
    validates :domicile_pref
    validates :domicile_city
    validates :domicile_add
    validates :family_katakana, format: { with: /[\p{katakana} ー－&&[^ -~｡-ﾟ]]+/, allow_blank: true}
    validates :first_katakana, format: { with: /[\p{katakana} ー－&&[^ -~｡-ﾟ]]+/, allow_blank: true}
    validates :postal_code, format: {with: /\A[0-9]{3}-[0-9]{4}\z/ , allow_blank: true}
  end

  with_options on: :update,  presence: true do
    validates :family_name
    validates :first_name
    validates :domicile_pref
    validates :domicile_city
    validates :domicile_add
    validates :nickname,  length: { maximum: 20 }
    validates :family_katakana, format: { with: /[\p{katakana} ー－&&[^ -~｡-ﾟ]]+/ , allow_blank: true}
    validates :first_katakana, format: { with: /[\p{katakana} ー－&&[^ -~｡-ﾟ]]+/ , allow_blank: true}
    validates :postal_code, format: {with: /\A[0-9]{3}-[0-9]{4}\z/ , allow_blank: true}
  end

  def self.find_for_oauth(auth)
    snscredential = SnsCredential.where(uid: auth.uid, provider: auth.provider).first
    unless snscredential.present?
      snscredential = SnsCredential.create(
        uid:      auth.uid,
        provider: auth.provider,
        email:    auth.info.email,
        nickname:     auth.info.name,
        image:    auth.info.image,
        password: Devise.friendly_token[0, 20]
      )
    end
    snscredential
  end

  protected
  def password_required?
    if validation_context == :registration_step_1
      !persisted? || !password.nil? || !password_confirmation.nil?
    end
  end

  def email_required?
    if validation_context == :registration_step_1
      true
    end
  end

end
