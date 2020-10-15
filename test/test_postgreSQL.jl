using Pkg

using Test, TestSetExtensions, SafeTestsets
using SearchLight

@testset "Core features PostgreSQL" begin

  @safetestset "PostgresSQL configuration" begin
    using SearchLight
    using SearchLightPostgreSQL

    conn_info_postgres = SearchLight.Configuration.load("postgres_connection.yml")

    @test conn_info_postgres["adapter"] == "PostgreSQL"
    @test conn_info_postgres["host"] == "127.0.0.1"
    @test conn_info_postgres["password"] == "postgres"
    @test conn_info_postgres["config"]["log_level"] == ":debug"
    @test conn_info_postgres["config"]["log_queries"] == true
    @test conn_info_postgres["port"] == 5432
    @test conn_info_postgres["username"] == "postgres"
    @test conn_info_postgres["database"] == "searchlight_tests"

  end;

  @safetestset "PostgresSQL connection" begin
    using SearchLight
    using SearchLightPostgreSQL
    using LibPQ

    conn_info_postgres = SearchLight.Configuration.load("postgres_connection.yml")
    conn_postgres = SearchLight.connect(conn_info_postgres)


    conInfoVect = LibPQ.conninfo(conn_postgres)

    # LibPQ don't provide the informations about the connection in an easy way
    # because of that, the following test will be done according the tests in MySQL
    infoItems = ["host","port","user","dbname"]
    keysInfo = Dict{String, String}()
    
    for i in infoItems
        index = findfirst(x -> x.keyword == i , conInfoVect)
        keysInfo[i] = conInfoVect[index].val
    end

    @test keysInfo["host"] == "127.0.0.1"
    @test keysInfo["port"] == "5432"
    @test keysInfo["dbname"] == "searchlight_tests"
    @test keysInfo["user"] == "postgres"

    ######## teardwon #######
    if conn_postgres !== nothing
      SearchLight.disconnect(conn_postgres)
      println("Database connection was disconnected")
    end

  end;

  @safetestset "PostgresSQL query" begin
    using SearchLight
    using SearchLightPostgreSQL
    using SearchLight.Configuration
    using SearchLight.Migrations

    conn_info = Configuration.load("postgres_connection.yml")
    conn = SearchLight.connect(conn_info)

    @test isempty(SearchLight.query("select table_schema, table_name from information_schema.tables",conn)) == true
    @test SearchLight.Migration.create_migrations_table() == true
    @test Array(SearchLight.query("select table_name from information_schema.tables",conn))[1] == SearchLight.SEARCHLIGHT_MIGRATIONS_TABLE_NAME


    ############# teardown ###############
    if conn !== nothing
      ############ drop migrations_table ######################
      queryString = string("select table_name from information_schema.tables where table_name = '", SearchLight.SEARCHLIGHT_MIGRATIONS_TABLE_NAME , "'" )
      resQuery = SearchLight.query(queryString)
      if size(resQuery,1) >  0 
        queryString = string("drop table ", SearchLight.SEARCHLIGHT_MIGRATIONS_TABLE_NAME)
        resQuery = SearchLight.query(queryString)
      end
      SearchLight.disconnect(conn)
      println("Database connection was disconnected")
    end

  end;

end


