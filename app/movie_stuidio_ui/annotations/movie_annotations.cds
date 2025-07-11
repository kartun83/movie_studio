namespace com.kartun.movie_studio;
using MovieService from '../../../srv/implementation/movie/movie-service';

annotate MovieService.Movies with{
  
    title @title: 'Movie Title' @(
        Common: {
            Text: title,
            Label: 'Title'
        }
    );
    budget @title: 'Budget' @(
        Common: {
            // Text: 'Budget',
            Label: '{i18n>budget}'
        }
    );
    releaseDate @title: 'Release Date' @(
        Common: {
            // Text: 'Release Date',
            Label: '{i18n>releaseDate}'
        }
    );
    status @title: 'Status' @(
        Common: {
            // Text: status,
            Label: 'Status'
        }
    );
    ID @(
        UI.Hidden,
        Common: {
            Text: 'description'
        }
    );

    
}

annotate MovieService.Movies with @(
    UI:{
        HeaderInfo:{
            TypeName: 'Movie',
            TypeNamePlural: 'Movies',
            Title:{
                $Type: 'UI.DataField',
                Value: title,
                Label: '{i18n>Movies}'
            }
        },
        LineItem: [
            {
                $Type: 'UI.DataField',
                Value: title,
                Label: '{i18n>Title}'
            },
            {
                $Type: 'UI.DataField',
                Value: budget,
                Label: '{i18n>Budget}'
            },
            {
                $Type: 'UI.DataField',
                Value: releaseDate,
                Label: '{i18n>releaseDate}'
            },
            {
                $Type: 'UI.DataField',
                Value: status,
                Label: '{i18n>Status}'
            },
            {
                $Type: 'UI.DataField',
                Value: director.firstName,
                Label: '{i18n>directorFirstName}'
            },            
            {
                $Type: 'UI.DataField',
                Value: director.lastName,
                Label: '{i18n>directorLastName}'
            }
            // {
            //     $Type: 'UI.DataField',
            //     Value : {$edmJson: {
            //         $Apply : [{$Path: 'director.lastName'} , ' ', {$Path: 'director.firstName'}],
            //         $Function : 'odata.concat',
            //     }},
            //     Label: '{i18n>Director}'
            // }
        ],
        SelectionFields: [
            title,
            budget,
            releaseDate,
            status
        ],
        Facets: [
            {
                $Type: 'UI.ReferenceFacet',
                Label: '{i18n>mainMovieInfo}',
                Target: '@UI.FieldGroup#Main'
            }
        ]
    }
);

annotate MovieService.Movies with @(
    UI : {
        FieldGroup#Main: {
        Data: [
            {
                $Type: 'UI.DataField',
                Value: title,
                Label: '{i18n>Title}'
            },
            {
                $Type: 'UI.DataField',
                Value: budget,
                Label: '{i18n>Budget}'
            },
            {
                $Type: 'UI.DataField',
                Value: releaseDate,
                Label: '{i18n>releaseDate}'
            },
            {
                $Type: 'UI.DataField',
                Value: status,
                Label: '{i18n>Status}'
            },
            {
                $Type: 'UI.DataField',
                Value: director.firstName,
                Label: '{i18n>Director First Name}'
            },
            {
                $Type: 'UI.DataField',
                Value: director.lastName,
                Label: '{i18n>Director Last Name}'
            }
        ]
    }
    }
)
