namespace com.kartun.movie_studio;
//using MovieService as service from '../../srv/implementation/movie/movie-service';
using from './annotations/movie_annotations';
using from '@sap/cds/common';

annotate MovieService.Movies with @(
    UI.FieldGroup #Main : {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : title,
                Label : '{i18n>Title}',
            },
            {
                $Type : 'UI.DataField',
                Value : budget,
                Label : '{i18n>Budget}',
            },
            {
                $Type : 'UI.DataField',
                Value : releaseDate,
                //Label : '{i18n>ReleaseDate}',
            },
            {
                $Type : 'UI.DataField',
                Value : status,
                Label : '{i18n>Status}',
            },
            {
                $Type : 'UI.DataField',
                Value : director.firstName,
                Label : '{i18n>directorFirstName}',
            },
            {
                $Type : 'UI.DataField',
                Value : director.lastName,
                Label : '{i18n>directorLastName}',
            },
        ],
    },
    UI.HeaderInfo : {
        TypeName : '{i18n>Movie}',
        TypeNamePlural : '{i18n>Movies}',
        Title : {
            $Type : 'UI.DataField',
            Value : title,
            Label : '{i18n>Movies}',
        },
    },
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : title,
            Label : '{i18n>Title}',
        },
        {
            $Type : 'UI.DataField',
            Value : budget,
            Label : '{i18n>budget}',
        },
        {
            $Type : 'UI.DataField',
            Value : releaseDate,
            // Label : '{i18n>ReleaseDate}',
        },
        {
            $Type : 'UI.DataField',
            Value : status,
            Label : '{i18n>Status}',
        },
        {
            $Type : 'UI.DataField',
            Value : director.firstName,
            Label : '{i18n>directorFirstName}',
        },
        {
            $Type : 'UI.DataField',
            Value : director.lastName,
            Label : '{i18n>directorLastName}',
        },
    ],
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>mainMovieInfo}',
            Target : '@UI.FieldGroup#Main',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>casting}',
            ID : 'i18ncasting',
            Target : 'castings/@UI.LineItem#i18ncasting',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>expenses}',
            ID : 'i18nexpenses',
            Target : 'expenses/@UI.LineItem#i18nexpenses',
        }
        // ,
        // {
        //     $Type : 'UI.ReferenceFacet',
        //     Label : '{i18n>productionLogs}',
        //     ID : 'i18nproductionLogs',
        //     Target : 'productionStatusLogs/@UI.LineItem#i18nproductionLogs',
        // },
        // {
        //     $Type : 'UI.ReferenceFacet',
        //     Label : '{i18n>genreSecondary}',
        //     ID : 'i18ngenreSecondary',
        //     Target : 'genre_secondary/@UI.LineItem#i18ngenreSecondary',
        // },
    ],
);

annotate MovieService.Movies with {
    title @(
        Common.Label : '{i18n>Title}',
        Common.Text : {
            $value : title,
            ![@UI.TextArrangement] : #TextOnly,
        },
    )
};

annotate MovieService.Movies with {
    status @(
        Common.Label : '{i18n>Status}',
        Common.Text : {
            $value : status,
        },
    )
};

annotate MovieService.Castings with @(
    UI.LineItem #i18ncasting : [
        {
            $Type : 'UI.DataField',
            Value : person.lastName,
            Label : '{i18n>lastName}',
        },
        {
            $Type : 'UI.DataField',
            Value : person.firstName,
            Label : '{i18n>firstName}',
        },
        {
            $Type : 'UI.DataField',
            Value : isLeadRole,
            Label : '{i18n>isleadrole}',
        },
        {
            $Type : 'UI.DataField',
            Value : characterName,
            Label : '{i18n>characterName}',
        },
        {
            $Type : 'UI.DataField',
            Value : modifiedBy,
            Label : '{i18n>changedBy}',
        },
    ]
);

annotate MovieService.Expenses with @(
    UI.LineItem #i18nexpenses : [
        {
            $Type : 'UI.DataField',
            Value : amount,
            Label : '{i18n>amount}',
        },
        {
            $Type : 'UI.DataField',
            Value : currency_code,
        },
        {
            $Type : 'UI.DataField',
            Value : date,
            Label : '{i18n>date}',
        },
        {
            $Type : 'UI.DataField',
            Value : description,
            Label : '{i18n>description}',
        },
    ]
);
// annotate MovieService.ProductionStatusLog with @(
//     UI.LineItem #i18nproductionLogs : [
//     ]
// );

// annotate MovieService.MovieGenreSecondary with @(
//     UI.LineItem #i18ngenreSecondary : [
//     ]
// );

