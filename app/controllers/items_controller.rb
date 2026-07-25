class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: %i[ show edit update destroy ]

  # GET /items or /items.json
  def index
    @items = Item.all.includes(:user, :store).order(created_at: :desc)
    if params[:search].present?
      @items = @items.search(params[:search])
    end
    if params[:category].present?
      @items = @items.by_category(params[:category])
    end
    @categories = Item.categories
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
    @stores = current_user.store.present? ? [current_user.store] : []
  end

  # GET /items/1/edit
  def edit
    authorize_item_owner!
    @stores = current_user.store.present? ? [current_user.store] : []
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    @item.user = current_user

    # If user has a store, auto-assign it
    if current_user.store.present?
      @item.store = current_user.store
    end

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        @stores = current_user.store.present? ? [current_user.store] : []
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @item.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    authorize_item_owner!
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @item }
      else
        @stores = current_user.store.present? ? [current_user.store] : []
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @item.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    authorize_item_owner!
    @item.destroy!

    respond_to do |format|
      format.html { redirect_to items_path, notice: "Item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_item
      @item = Item.find(params.expect(:id))
    end

    def authorize_item_owner!
      unless @item.user == current_user
        redirect_to @item, alert: "You are not authorized to do that."
      end
    end

    def item_params
      params.expect(item: [ :name, :description, :price, :category, :store_id, images: [] ])
    end
end
