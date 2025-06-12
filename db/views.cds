namespace com.kartun.movie_studio.views;

using {CrewAssignment, MovieProject} from './schema';

entity MovieDirectorView as select from  CrewAssignment {
  movie_ID,
  person_ID,
  person.name as directorName
} where roleDescription = 'Director';