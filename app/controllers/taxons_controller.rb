class TaxonsController < ApplicationController

  def page_kind
    "species"
  end

  # GET /taxons
  # GET /taxons.json
  def index
    @all_taxons_seen = Taxon.species_seen.not_excluded

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @all_taxons_seen }
    end
  end

  def typeahead
    results = {}
    taxons = Taxon.find_by_sql(["select * from taxons where category='Species' AND common_name like ?", "%#{params[:query]}%"])
    common_names = taxons.collect { |taxon| taxon.common_name }
    results['options'] = common_names.sort
    render json: results
  end

  # GET /taxons/1
  # GET /taxons/1.json
  def show
    @taxon = Taxon.find(params[:id])
    @page_title = @taxon.common_name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: [@taxon], :include => [ :locations, :photos => { :include => [ :taxon, :trip, :location ], :methods => [ :image_filename ] } ] }
    end
  end

  def bird_of_the_week
    @taxon = Taxon.bird_of_the_week();
    @page_title = @taxon.common_name

    respond_to do |format|
      format.html { render :action => "show" }
      format.xml  { render :xml => @taxon }
      format.json { render :json => [@taxon], :include => { :photos => { :include => [ :taxon, :trip, :location ], :methods => [ :image_filename ] } } }
    end
  end

  def life_list
    @page_title = "Birding Life List"
    all_species_seen = Taxon.species_seen.not_excluded
    @life_sightings = all_species_seen.collect {|x| x.sightings.earliest}
  end

  def photo_life_list
    @page_title = "Photo Life List"
    @all_taxons_photographed = Taxon.photographed.not_excluded
  end                        

  def show_by_latin_name
    puts "find %s" % params[:latin_name]
    @taxon = Taxon.find_by_latin_name(params[:latin_name].sub('_', ' '))
    @page_title = @taxon.common_name

    respond_to do |format|
      format.html { render :action => 'show' }
      format.xml  { render :xml => @taxon }
      format.json { render json: [@taxon], :include => [ :locations, :photos => { :include => [ :taxon, :trip, :location ], :methods => [ :image_filename ] } ] }
    end
  end

  def locations
    @taxon = Taxon.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @taxon.locations }
      format.json  { render :json => @taxon.locations }
    end
  end

  # GET /taxons/new
  # GET /taxons/new.json
  def new
    @taxon = Taxon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taxon }
    end
  end

  # GET /taxons/1/edit
  def edit
    @taxon = Taxon.find(params[:id])
  end

  # POST /taxons
  # POST /taxons.json
  def create
    @taxon = Taxon.new(params[:taxon])

    respond_to do |format|
      if @taxon.save
        format.html { redirect_to @taxon, notice: 'Taxon was successfully created.' }
        format.json { render json: @taxon, status: :created, location: @taxon }
      else
        format.html { render action: "new" }
        format.json { render json: @taxon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /taxons/1
  # PUT /taxons/1.json
  def update
    @taxon = Taxon.find(params[:id])

    respond_to do |format|
      if @taxon.update_attributes(params[:taxon])
        format.html { redirect_to @taxon, notice: 'Taxon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @taxon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taxons/1
  # DELETE /taxons/1.json
  def destroy
    @taxon = Taxon.find(params[:id])
    @taxon.destroy

    respond_to do |format|
      format.html { redirect_to taxons_url }
      format.json { head :no_content }
    end
  end
end
