using AssetsService as service from '../../srv/implementation/assets/assets-service';
annotate service.Assets with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : '{i18n>AssetName}',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>AssetTypecode}',
                Value : type_code,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>AssetStatuscode}',
                Value : status_code,
            },
            {
                $Type : 'UI.DataField',
                Value : location.address,
                Label : '{i18n>AssetAddress}',
            },
            {
                $Type : 'UI.DataField',
                Value : location.name,
                Label : '{i18n>AssetLocationName}',
            },
            {
                $Type : 'UI.DataField',
                Value : type.name,
                Label : '{i18n>AssetTypeName}',
            },
            {
                $Type : 'UI.DataField',
                Value : location.locationtype.name,
                Label : '{i18n>AssetLocationTypeName}',
            },
            {
                $Type : 'UI.DataField',
                Value : status.name,
                Label : '{i18n>AssetStatusName}',
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
            Label : '{i18n>AssetName}',
            Value : name,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>AssetTypecode}',
            Value : type_code,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>AssetStatuscode}',
            Value : status_code,
        },
    ],
    UI.HeaderInfo : {
        Title : {
            $Type : 'UI.DataField',
            Value : name,
        },
        TypeName : '',
        TypeNamePlural : '',
    },
);

annotate service.Assets with {
    location @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Location',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : location_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'address',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'locationtype_code',
            },
        ],
    }
};

annotate service.Assets with {
    type @Common.Text : {
        $value : type.name,
        ![@UI.TextArrangement] : #TextOnly
    }
};

annotate service.Assets with {
    status @Common.Text : {
        $value : status.name,
        ![@UI.TextArrangement] : #TextFirst
    }
};

