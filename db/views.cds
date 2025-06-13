namespace com.kartun.movie_studio.views;

using {com.kartun.movie_studio.db.schema};
using { CrewAssignment, MovieProject };

entity MovieDirectorView as select from  CrewAssignment {
  movie_ID,
  person_ID,
  person.name as directorName
} where roleDescription = 'Director';