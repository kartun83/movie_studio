using HRService as service from '../../srv/implementation/hr/hr-service';
using from '@sap/cds/common';

annotate service.Person with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Firstname}',
                Value : firstName,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Lastname}',
                Value : lastName,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>PersonRole}',
                Value : role_code,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Birthdate}',
                Value : birthDate,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Agency}',
                Value : agency,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Countrycode}',
                Value : country_code,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : '{i18n>GeneralInformation}',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : '{i18n>Firstname}',
            Value : firstName,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>Lastname}',
            Value : lastName,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>Rolecode}',
            Value : role_code,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>Birthdate}',
            Value : birthDate,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>Agency}',
            Value : agency,
        },
    ],
    UI.HeaderInfo : {
        Title : {
            $Type : 'UI.DataField',
            Value : fullName,
        },
        TypeName : '',
        TypeNamePlural : '',
    },
);

annotate service.Person with {
    role @Common.Text : {
        $value : role.name,
        ![@UI.TextArrangement] : #TextOnly
    }
};

annotate service.Person with {
    country @Common.Text : {
        $value : country.name,
        ![@UI.TextArrangement] : #TextFirst
    }
};

