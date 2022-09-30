class Movie < ActiveRecord::Base

    def self.all_ratings
        @distinct_movies = Movie.select(:rating).distinct
        @all_ratings = @distinct_movies.pluck(:rating)
        return @all_ratings
    end

    def self.with_ratings(ratings_list)
        # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all movies with those ratings
        if ratings_list
            @movies = Movie.where(rating: ratings_list.keys)
        # if ratings_list is nil, retrieve ALL movies
        else 
            @movies = Movie.all
        end
        return @movies
    end

end
