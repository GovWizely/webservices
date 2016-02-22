module SalesforceArticle
  class TradeAgreementData < BaseData
    include ::Importable
    include ::VersionableResource

    def query_string
      @query_string ||= <<-SOQL
        SELECT Id,
               Agreement_Description__c,
               Agreement_Status__c,
               Agreement_Type__c,
               Approval_Date__c,
               Approval_Status__c,
               Approver__C,
               Article_Expiration_Date__c,
               FirstPublishedDate,
               LastPublishedDate,
               Lead_DMO__c,
               Notes__c,
               Summary,
               Support_DMO__c,
               TARA_Document_Title__c,
               Title,
               UrlName,
               (SELECT Id, DataCategoryName, DataCategoryGroupName FROM DataCategorySelections)
        FROM Trade_Agreement__kav
        WHERE PublishStatus = 'Online'
        AND Language = 'en_US'
        AND IsLatestVersion=true
        AND IsVisibleInPkb=true
      SOQL
    end
  end
end
