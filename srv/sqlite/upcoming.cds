using com.kartun.movie_studio as M from '../../db/schema';

@cds.sql.dialect: 'sqlite'
view UpcomingReleasesSqlite
  as select from M.MovieProject {
    ID,
    title,
    releaseDate,
    status.code as status
  };
