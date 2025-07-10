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
            Text: 'Budget',
            Label: 'Budget'
        }
    );
    releaseDate @title: 'Release Date' @(
        Common: {
            Text: 'Release Date',
            Label: 'Release Date'
        }
    );
    status @title: 'Status' @(
        Common: {
            Text: status,
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
                Value: title
            }
        },
        LineItem: [
            {
                $Type: 'UI.DataField',
                Value: title,
                Label: 'Title'
            },
            {
                $Type: 'UI.DataField',
                Value: budget,
                Label: 'Budget'
            },
            {
                $Type: 'UI.DataField',
                Value: releaseDate,
                Label: 'Release Date'
            },
            {
                $Type: 'UI.DataField',
                Value: status,
                Label: 'Status'
            }
        ],
        SelectionFields: [
            title,
            budget,
            releaseDate,
            status
        ]
    }
)
