class Movie < ActiveRecord::Base
    #attr_accessor :title, :rating, :description, :release_date
    def Movie.all_ratings
        Movie.uniq.pluck(:rating);
    end
end
