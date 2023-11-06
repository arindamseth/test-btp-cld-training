using {
    anubhav.db.master,
    anubhav.db.transaction
} from '../db/datamodel';
using {cappo.cds} from '../db/CDSViews';

service CatalogService @(path: 'CatalogService') {

    entity BusinessPartnerSet                              as projection on master.businesspartner;
    entity BPAddress                                       as projection on master.address;
    entity EmployeeSet                                     as projection on master.employees;
    entity ProductSet                                      as projection on master.product;

    entity POs                      @(odata.draft.enabled) as projection on transaction.purchaseorder {
        *,
        ROUND(
            GROSS_AMOUNT, 0
        )   as GROSS_AMOUNT : Int64 @(title: '{i18n>GrossAmount}'),
        Items,
        // case OVERALL_STATUS
        //     when
        //         'A'
        //     then
        //         'Approved'
        //     when
        //         'P'
        //     then
        //         'Pending'
        //     when
        //         'N'
        //     then
        //         'New'
        //     when
        //         'X'
        //     then
        //         'Rejected'
        //     else
        //         'NA'
        // end as OVERALL_STATUS : String(10) @(title: '{i18n>OVERALL_STATUS}'),
        case OVERALL_STATUS
            when
                'A'
            then
                3
            when
                'P'
            then
                2
            when
                'N'
            then
                2
            when
                'X'
            then
                1
            else
                4
        end as Spiderman    : Int16
    } actions {
        @cds.odata.bindingparameter.name: '_arindam'
        @Common.SideEffects             : {TargetProperties: ['_arindam/GROSS_AMOUNT']}
        action   boost();
        action   setOrderProcessing();
        function largestOrder() returns array of POs;
    };

    entity POItems                                         as projection on transaction.poitems;

}
