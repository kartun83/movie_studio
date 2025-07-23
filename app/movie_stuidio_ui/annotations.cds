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
                Value : status_code,
                Label : '{i18n>Status}',
                Criticality : status.criticality,
                CriticalityRepresentation : #WithIcon,
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
            Value : status_code,
            Label : '{i18n>Status}',
            Criticality : status.criticality,
            CriticalityRepresentation : #WithIcon,
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
        {
            $Type : 'UI.DataField',
            Value : genre_primary_code,
            Label : '{i18n>genre_primary}',
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
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>productionLogs}',
            ID : 'i18nproductionLogs',
            Target : 'productionStatusLogs/@UI.LineItem#i18nproductionLogs',
        },
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
    UI.SelectionFields : [
        title,
        budget,
        releaseDate,
        status_code,
        genre_primary_code,
    ],
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'MovieService.cancelProject',
            Label : '{i18n>cancelProject}',
            Criticality : #Negative,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'MovieService.closeProject',
            Label : '{i18n>closeProject}',
            Criticality : #Negative,
        },
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
    ],
    UI.HeaderInfo : {
        TypeName : '{i18n>Casting}',
        TypeNamePlural : '{i18n>Castings}',
        Title : {
            $Type : 'UI.DataField',
            Value : characterName,
            Label : '{i18n>Casting}',
        },
    },
    UI.FieldGroup #Main : {
        Data : [
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
        ],
    },
    UI.SelectionFields : [
        person.lastName,
        person.firstName,
        characterName,
        isLeadRole,
    ],
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>casting_details}',
            ID : 'i18ncasting_details',
            Target : '@UI.FieldGroup#i18ncasting_details',
        },
    ],
    UI.FieldGroup #i18ncasting_details : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : person.firstName,
                Label : 'firstName',
            },
            {
                $Type : 'UI.DataField',
                Value : person.lastName,
                Label : 'lastName',
            },
            {
                $Type : 'UI.DataField',
                Value : characterName,
                Label : 'characterName',
            },
            {
                $Type : 'UI.DataField',
                Value : isLeadRole,
                Label : 'isLeadRole',
            },
        ],
    },
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
            Value : date,
            Label : '{i18n>date}',
        },
        {
            $Type : 'UI.DataField',
            Value : description,
            Label : '{i18n>description}',
        },
    ],
    UI.HeaderInfo : {
        TypeName : '{i18n>Expense}',
        TypeNamePlural : '{i18n>Expenses}',
        Title : {
            $Type : 'UI.DataField',
            Value : description,
            Label : '{i18n>Expense}',
        },
    },
    UI.FieldGroup #Main : {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : amount,
                Label : '{i18n>amount}',
            },
            {
                $Type : 'UI.DataField',
                Value : currency_code,
                Label : '{i18n>currency}',
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
            {
                $Type : 'UI.DataField',
                Value : category.name,
                Label : '{i18n>category}',
            },
        ],
    },
    UI.SelectionFields : [
        amount,
        date,
        description,
        category.name,
    ],
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>expense_details}',
            ID : 'i18nexpense_details',
            Target : '@UI.FieldGroup#i18nexpense_details',
        },
    ],
    UI.FieldGroup #i18nexpense_details : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : category_code,
                Label : 'category_code',
                ![@UI.Hidden],
            },
            {
                $Type : 'UI.DataField',
                Value : amount,
                Label : 'amount',
            },
            {
                $Type : 'UI.DataField',
                Value : currency_code,
            },
            {
                $Type : 'UI.DataField',
                Value : date,
                Label : 'date',
            },
            {
                $Type : 'UI.DataField',
                Value : description,
                Label : 'description',
            },
        ],
    },
);
// annotate MovieService.ProductionStatusLog with @(
//     UI.LineItem #i18nproductionLogs : [
//     ]
// );

// annotate MovieService.MovieGenreSecondary with @(
//     UI.LineItem #i18ngenreSecondary : [
//     ]
// );

annotate MovieService.Expenses with {
    amount @Measures.ISOCurrency : currency.code
};

annotate MovieService.Movies with {
    genre_primary @(
        Common.Label : '{i18n>genre_primary}',
        Common.Text : {
            $value : genre_primary.name,
            ![@UI.TextArrangement] : #TextOnly
        },
    )
};

annotate MovieService.Movies with {
    status @Common.Text : {
        $value : status.name,
        ![@UI.TextArrangement] : #TextOnly
    }
};

// annotate com.kartun.movie_studio.Casting with {
//     @UI. RowHighlight: #(Lead)
//   isLeadRole;
// }

annotate com.kartun.movie_studio.ProductionStatusLog with @(
    UI.LineItem #i18nproductionLogs : [
        {
            $Type : 'UI.DataField',
            Value : createdAt,
            Label : '{i18n>date}',
        },
        {
            $Type : 'UI.DataField',
            Value : status.name,
            Label : '{i18n>Status}',
        },
        {
            $Type : 'UI.DataField',
            Value : comment,
            Label : '{i18n>description}',
        },        
    ]
);

annotate MovieService.ProductionStatusLog with @(
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>productionlog_details}',
            ID : 'i18nproductionlog_details',
            Target : '@UI.FieldGroup#i18nproductionlog_details',
        },
    ],
    UI.FieldGroup #i18nproductionlog_details : {
        $Type : 'UI.FieldGroupType',
        Data : [
        ],
    }
);

