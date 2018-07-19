class ImportsController < ApplicationController
  before_action :logged_in_user, only: [:new,:upload,:edit,:save]

  def new
  end

  def upload
  end

  def edit
  end

  def save
  end
end
