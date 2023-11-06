using CatalogService as service from '../../srv/CatalogService';

annotate CatalogService.POs with @(
    UI.SelectionFields   : [
        PO_ID,
        GROSS_AMOUNT,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY
    ],

    UI.LineItem          : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.boost',
            Inline : true,
            Label : 'Boost',
        },
        {
            $Type                    : 'UI.DataField',
            Value                    : OVERALL_STATUS,
            Criticality              : Spiderman,
            CriticalityRepresentation: #WithIcon
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
    ],

    UI.HeaderInfo        : {
        TypeName      : '{i18n>PO}',
        TypeNamePlural: '{i18n>POs}',
        Title         : {Value: PO_ID},
        Description   : {Value: PARTNER_GUID.COMPANY_NAME},
        ImageUrl      : 'https://yt3.googleusercontent.com/zCgSuKDRBWCoEFP52F5WNm-8q6FYKiiIlgpdqjdQaZekQc-PDcyFhi-cO8bkvtvOvH6qPBSg=s900-c-k-c0x00ffffff-no-rj'
    },

    UI.Identification    : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: OVERALL_STATUS,
        },{
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.setOrderProcessing',
            Label: 'Set to delivered'
        },
    ],

    UI.FieldGroup #Price : {
        Label: 'Prices',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: GROSS_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Value: NET_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Value: TAX_AMOUNT,
            },
        ],
    },

    UI.FieldGroup #Status: {
        Label: 'Status',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: LIFECYCLE_STATUS,
            },
            {
                $Type: 'UI.DataField',
                Value: CURRENCY_code,
            },
        ],
    },

    UI.Facets            : [
        {
            $Type : 'UI.CollectionFacet',
            Label : '{i18n>Info}',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : '{i18n>headerInfo}',
                    Target: '@UI.Identification',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Prices',
                    Target: '@UI.FieldGroup#Price',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Status',
                    Target: '@UI.FieldGroup#Status',
                },
            ]
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Items',
            Target: 'Items/@UI.LineItem',
        },
    ]
);

annotate CatalogService.POItems with @(
    UI.HeaderInfo             : {
        TypeName      : 'PO Item',
        TypeNamePlural: 'PO Items',
        Title         : {Value: PO_ITEM_POS},
        Description   : {Value: PRODUCT_GUID.DESCRIPTION},
    },
    UI.FieldGroup #BasicData  : {
        Label: 'Basic Data',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: PO_ITEM_POS,
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT_GUID_NODE_KEY,
            },
            {
                $Type: 'UI.DataField',
                Value: CURRENCY_code,
            },
        ],
    },
    UI.FieldGroup #PricingData: {
        Label: 'Item Pricing',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: GROSS_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Value: TAX_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Value: NET_AMOUNT,
            },
        ],
    },
    UI.Facets                 : [{
        $Type : 'UI.CollectionFacet',
        Label : 'Item Information',
        Facets: [
            {
                $Type : 'UI.ReferenceFacet',
                Label : 'Basic Data',
                Target: '@UI.FieldGroup#BasicData',
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : 'Pricing Data',
                Target: '@UI.FieldGroup#PricingData',
            },
        ]
    }, ],
    UI.LineItem               : [
        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS,
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code,
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT,
        },
    ]
);

@cds.odata.valuelist annotate CatalogService.BusinessPartnerSet with  @(UI.Identification: [{
    $Type: 'UI.DataField',
    Value: COMPANY_NAME
}]);

@cds.odata.valuelist annotate CatalogService.ProductSet with  @(UI.Identification: [{
    $Type: 'UI.DataField',
    Value: DESCRIPTION,
}, ]);


annotate CatalogService.POs with {
    PARTNER_GUID @(
        Common          : {
            Text           : PARTNER_GUID.COMPANY_NAME,
            TextArrangement: #TextFirst
        },
        ValueList.entity: CatalogService.BusinessPartnerSet
    );
};

annotate CatalogService.POItems with {
    PRODUCT_GUID @(
        Common.Text     : PRODUCT_GUID.DESCRIPTION,
        ValueList.entity: CatalogService.ProductSet
    );
};
