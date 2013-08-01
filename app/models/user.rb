class User < ActiveRecord::Base

  acts_as_voter

  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids, :profile_attributes
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :trackable, :validatable, :timeoutable, :timeout_in => 120.minutes

  has_one :profile, :dependent => :destroy
  has_many :role_users, :dependent => :destroy
  has_many :roles, :through => :role_users
  has_many :questions
  has_many :solutions

  accepts_nested_attributes_for :profile

  validates_presence_of :password_confirmation, :on => :create

  def full_name
    profile.full_name
  end

  def age
    (Date.today - profile.birth).to_i / 365
  end

  def is_admin?
    return true if self.has_role?(:admin)
    return false
  end

  def is_active_admin?
    return true if self.is_admin? or self.has_role?(:moderator)
    return false
  end

  def has_role?(role)
    i = roles.index(role)             if role.is_a?(Role)
    i = roles_as_symbols.index(role)  if role.is_a?(::Symbol)
    i = roles_as_strings.index(role)  if role.is_a?(::String)
    return true if i
    return false
  end

  # The current_user roles as an array of symbols
  def roles_as_symbols
    roles.pluck(:symbol).map(&:to_sym)
  end

  def roles_as_strings
    roles.pluck(:name)
  end

end
