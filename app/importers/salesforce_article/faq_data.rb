module SalesforceArticle
  class FaqData < BaseData
    include ::Importable
    include ::VersionableResource

    FIELD_MAPPING = {
      'Id'                 => :id,
      'FirstPublishedDate' => :first_published_date,
      'LastPublishedDate'  => :last_published_date,
      'References__c'      => :references,
      'Summary'            => :summary,
      'Title'              => :question,
      'UrlName'            => :url_name,
      'Atom__c'            => :answer,
    }

    def query_string
      @query_string ||= <<-SOQL
        SELECT Id,
               Atom__c,
               FirstPublishedDate,
               LastPublishedDate,
               Public_URL__c,
               References__c,
               Summary,
               Title,
               UrlName,
               (SELECT Id, DataCategoryName, DataCategoryGroupName FROM DataCategorySelections)
        FROM FAQ__kav
        WHERE PublishStatus = 'Online'
        AND Language = 'en_US'
        AND IsLatestVersion=true
        AND IsVisibleInPkb=true
      SOQL
    end
  end
end
