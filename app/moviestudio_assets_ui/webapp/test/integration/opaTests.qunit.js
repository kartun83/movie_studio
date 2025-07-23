sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'com/kartun/moviestudio/moviestudioassetsui/test/integration/FirstJourney',
		'com/kartun/moviestudio/moviestudioassetsui/test/integration/pages/AssetsList',
		'com/kartun/moviestudio/moviestudioassetsui/test/integration/pages/AssetsObjectPage'
    ],
    function(JourneyRunner, opaJourney, AssetsList, AssetsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('com/kartun/moviestudio/moviestudioassetsui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheAssetsList: AssetsList,
					onTheAssetsObjectPage: AssetsObjectPage
                }
            },
            opaJourney.run
        );
    }
);