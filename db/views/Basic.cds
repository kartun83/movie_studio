namespace com.kartun.movie_studio;

using {com.kartun.movie_studio.MovieProject} from '../core/movie';
using {com.kartun.movie_studio.Person} from '../core/person';

entity MinimalMovieInfo as projection on MovieProject {
  ID,
  title,
  status,
  releaseDate
}

entity DirectorWithFullName as projection on Person {
  ID,
  firstName,
  lastName
}