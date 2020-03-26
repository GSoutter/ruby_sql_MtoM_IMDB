require_relative('../db/sql_runner.rb')


class Movie

    attr_accessor :title, :genre
    attr_reader :id


    def initialize(options)
      @title = options['title']
      @genre = options['genre']
      @id = options['id'].to_i if options['id']
    end

    def save()
      sql = "INSERT INTO movies
      (
      title,
      genre
      )
      VALUES(
      $1,
      $2
      )
      RETURNING id"
      values = [@title, @genre]
      @id = SqlRunner.run(sql, values)[0]['id'].to_i
    end

    def Movie.all()
        sql = "SELECT * FROM movies"
        movies = SqlRunner.run(sql, [])
        result = movies.map {|movie| Movie.new(movie)}
        return result
    end

    def Movie.delete_all()
      sql = "DELETE FROM movies"
      SqlRunner.run(sql, [])
    end

    def update()
      sql = "UPDATE movies SET (title, genre) = ($1, $2) WHERE id = $3"
      values = [@title, @genre, @id]
      SqlRunner.run(sql, values)
    end

    def stars()
      sql = "SELECT stars.* FROM stars
              INNER JOIN castings
              on stars.id = castings.id_stars
              WHERE castings.id_movies = $1"
      values = [@id]
      stars = SqlRunner.run(sql, values)
      return stars.map {|star| Star.new(star)}
    end



end
