namespace com.kartun.movie_studio;

using {com.kartun.movie_studio.MovieProject} from '../core/movie';

entity MinimalMovieInfo as projection on MovieProject {
  ID,
  title,
  status,
  releaseDate
}