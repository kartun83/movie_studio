sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'com/kartun/moviestudio/moviestudiohrui/test/integration/FirstJourney',
		'com/kartun/moviestudio/moviestudiohrui/test/integration/pages/PersonList',
		'com/kartun/moviestudio/moviestudiohrui/test/integration/pages/PersonObjectPage'
    ],
    function(JourneyRunner, opaJourney, PersonList, PersonObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('com/kartun/moviestudio/moviestudiohrui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onThePersonList: PersonList,
					onThePersonObjectPage: PersonObjectPage
                }
            },
            opaJourney.run
        );
    }
);