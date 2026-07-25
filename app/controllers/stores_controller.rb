class StoresController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_store, only: %i[ show edit update destroy ]

  # GET /stores or /stores.json
  def index
    @stores = Store.all.order(created_at: :desc)
    if params[:search].present?
      @stores = @stores.search(params[:search])
    end
  end

  # GET /stores/1 or /stores/1.json
  def show
    @items = @store.items.includes(:user).order(created_at: :desc)
    @can_connect = user_signed_in? && @store.user != current_user
  end

  # GET /stores/new
  def new
    if current_user.store.present?
      redirect_to current_user.store, notice: "You already have a store."
      return
    end
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
    authorize_store_owner!
  end

  # POST /stores or /stores.json
  def create
    if current_user.store.present?
      redirect_to current_user.store, notice: "You already have a store."
      return
    end

    @store = Store.new(store_params)
    @store.user = current_user

    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: "Store was successfully created." }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @store.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    authorize_store_owner!
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: "Store was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @store.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /stores/1 or /stores/1.json
  def destroy
    authorize_store_owner!
    @store.destroy!

    respond_to do |format|
      format.html { redirect_to stores_path, notice: "Store was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # POST /stores/1/connect
  def connect
    @store = Store.find(params[:id])
    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Please sign in first."
      return
    end

    if @store.user == current_user
      redirect_to @store, alert: "You cannot connect with your own store."
      return
    end

    conversation = Conversation.between(current_user, @store.user).first
    unless conversation
      conversation = Conversation.create!(
        sender: current_user,
        recipient: @store.user,
        store: @store
      )
    end

    redirect_to conversation, notice: "Connected! Send a message to the seller."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params.expect(:id))
    end

    def authorize_store_owner!
      unless @store.user == current_user
        redirect_to @store, alert: "You are not authorized to do that."
      end
    end

    # Only allow a list of trusted parameters through.
    def store_params
      params.expect(store: [ :name, :description, :logo ])
    end
end
