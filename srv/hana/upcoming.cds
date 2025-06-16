using com.kartun.movie_studio as M from '../../db/schema';

@cds.sql.dialect: 'hana'
view UpcomingReleasesHana (earliest: Date, latest: Date)
  as select from M.MovieProject {
    ID,
    title,
    releaseDate,
    status.code as status
  }
  where releaseDate between :earliest and :latest;
