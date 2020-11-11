module TestModels

using SearchLight

######## Model from Genie-Searchligth-example-app extracted ############
export Book

mutable struct Book <: AbstractModel
  ### INTERNALS
  _table_name::String
  _id::String
  _serializable::Vector{Symbol}

  ### FIELDS
  id::DbId
  title::String
  author::String
  cover::String

  ### VALIDATION
  # validator::ModelValidator

  ### CALLBACKS
  # before_save::Function
  # after_save::Function
  # on_save::Function
  # on_find::Function
  # after_find::Function

  ### SCOPES
  # scopes::Dict{Symbol,Vector{SearchLight.SQLWhereEntity}}

  ### constructor
  Book(;
    ### FIELDS
    id = DbId(),
    title = "",
    author = "",
    cover = "",

    ### VALIDATION
    # validator = ModelValidator([
    #   ValidationRule(:title, BooksValidator.not_empty)
    # ]),

    ### CALLBACKS
    # before_save = (m::Todo) -> begin
    #   @info "Before save"
    # end,
    # after_save = (m::Todo) -> begin
    #   @info "After save"
    # end,
    # on_save = (m::Todo, field::Symbol, value::Any) -> begin
    #   @info "On save"
    # end,
    # on_find = (m::Todo, field::Symbol, value::Any) -> begin
    #   @info "On find"
    # end,
    # after_find = (m::Todo) -> begin
    #   @info "After find"
    # end,

    ### SCOPES
    # scopes = Dict{Symbol,Vector{SearchLight.SQLWhereEntity}}()

  ) = new("books", "id", Symbol[],                                                ### INTERNALS
          id, title, author, cover                                                             ### FIELDS
          # validator,                                                                  ### VALIDATION
          # before_save, after_save, on_save, on_find, after_find                       ### CALLBACKS
          # scopes                                                                      ### SCOPES
          )
  end

    function seed()
    
        BillGatesBooks = [
        ("The Best We Could Do", "Thi Bui"),
        ("Evicted: Poverty and Profit in the American City", "Matthew Desmond"),
        ("Believe Me: A Memoir of Love, Death, and Jazz Chickens", "Eddie Izzard"),
        ("The Sympathizer!", "Viet Thanh Nguyen"),
        ("Energy and Civilization, A History", "Vaclav Smil")
        ]
    
    end

end
