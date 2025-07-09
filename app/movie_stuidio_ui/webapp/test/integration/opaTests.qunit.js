sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/moviestuidioui/test/integration/FirstJourney',
		'ns/moviestuidioui/test/integration/pages/MoviesList',
		'ns/moviestuidioui/test/integration/pages/MoviesObjectPage'
    ],
    function(JourneyRunner, opaJourney, MoviesList, MoviesObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/moviestuidioui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheMoviesList: MoviesList,
					onTheMoviesObjectPage: MoviesObjectPage
                }
            },
            opaJourney.run
        );
    }
);