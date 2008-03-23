class AdminsController < ApplicationController
  before_filter :find_admin, :except => [:index, :new, :create]
  
  # GET /admins
  # GET /admins.xml
  def index
    @admins = Admin.find(:all, :order => "name")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admins }
    end
  end

  # GET /admins/1
  # GET /admins/1.xml
  def show
    @admin = Admin.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/1/edit
  def edit
    redirect_to(@admin) if @current_admin.id != @admin.id && !@current_admin.global
  end

  # POST /admins
  # POST /admins.xml
  def create
    @admin = Admin.new(params[:admin])
    @admin.global = false
    
    respond_to do |format|
      # TODO: in a situation where there is one local admin and one global admin and the global admin deletes him/herself, make the local admin global.
      
      if @admin.save
        if @admin.id == 1
          @admin.update_attributes(:global => true)
        else
          @admin.update_attributes(:global => true) if Admin.find(:all).size == 1
        end
        
        flash[:notice] = 'Admin was successfully created.'
        session[:admin] = @admin.id
        format.html { redirect_to(@admin) }
        format.xml  { render :xml => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admins/1
  # PUT /admins/1.xml
  def update
    redirect_to(@admin) if @current_admin.id != @admin.id && !@current_admin.global
    logger.debug "attempting to update admin (id of " + params[:id] + ")"
    respond_to do |format|
      if @admin.update_attributes(params[:id])
        flash[:notice] = 'Admin was successfully updated.'
        format.html { redirect_to(@admin) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.xml
  def destroy
    redirect_to(@admin) if @current_admin.id != @admin.id && !@current_admin.global
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to(admins_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    def find_admin
      @admin = Admin.find(params[:id])
    end
end
