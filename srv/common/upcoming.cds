using { UpcomingReleasesHana as X } from '../hana/upcoming';
@cds.sql.dialect: 'hana'
entity UpcomingReleases as projection on X;

using { UpcomingReleasesSqlite as X } from '../sqlite/upcoming';
@cds.sql.dialect: 'sqlite'
entity UpcomingReleases as projection on X;
